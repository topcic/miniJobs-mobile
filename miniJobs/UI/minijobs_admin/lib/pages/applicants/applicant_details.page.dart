import 'dart:typed_data';

import 'package:decimal/decimal.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:minijobs_admin/pages/main/constants.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import '../../models/applicant/applicant.dart';
import '../../providers/applicant_provider.dart';
import '../../providers/user_provider.dart';
import '../../utils/photo_view.dart';
import '../user-profile/finished_job_view.dart';
import '../user-profile/user_ratings_view.dart';

class ApplicantDetailsPage extends StatefulWidget {
  final int id;

  const ApplicantDetailsPage({super.key, required this.id});

  @override
  State<ApplicantDetailsPage> createState() => _ApplicantDetailsPageState();
}

class _ApplicantDetailsPageState extends State<ApplicantDetailsPage> {
  late ApplicantProvider _applicantProvider;
  late UserProvider _userProvider;
  Applicant? applicant;
  bool isLoading = true;
  Uint8List? cvBytes;
  String? cvFileName;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _applicantProvider = context.read<ApplicantProvider>();
    _userProvider = context.read<UserProvider>();
    fetchUser();
  }

  Future<void> fetchUser() async {
    try {
      final fetchedApplicant = await _applicantProvider.get(widget.id);
      setState(() {
        applicant = fetchedApplicant;
        isLoading = false;
        if (applicant?.cv != null) {
          cvBytes = applicant!.cv;
          cvFileName = "CV.${_getFileExtension(applicant!.cv!)}";
        }
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }
  String _getFileExtension(Uint8List bytes) {
    final mimeType = lookupMimeType('', headerBytes: bytes);

    if (mimeType != null) {
      final extension = mimeType.split('/').last;
      return extension;
    }

    final signatures = {
      '25504446': 'pdf',
      '504B0304': 'docx',
      'D0CF11E0': 'doc',
    };

    final headerBytes = bytes
        .take(4)
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join()
        .toUpperCase();
    final extension = signatures[headerBytes];

    if (extension != null) {
      return extension;
    }

    return '';
  }
  Future<void> blockUser() async {
    setState(() => isLoading = true);
    await _userProvider.delete(applicant!.id!);
    setState(() {
      applicant!.deleted = true;
      isLoading = false;
    });
  }
  Future<void> _downloadCVFile() async {
    if (cvBytes != null && cvFileName != null) {
      String? path = await FileSaver.instance.saveFile(name: cvFileName!, bytes: cvBytes!, ext: "");
      OpenFile.open(path);
    }
  }

  Future<void> activateUser() async {
    setState(() => isLoading = true);
    await _userProvider.activate(applicant!.id!);
    setState(() {
      applicant!.deleted = false;
      isLoading = false;
    });
  }

  void _showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            child: const Text('Odustani'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Potvrdi'),
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(applicant != null ? '${applicant!.firstName} ${applicant!.lastName}' : 'Korisnik'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxWidth < 800;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: isSmallScreen
                ? ListView(
              children: [
                _buildApplicantDetailsCard(context),
                const SizedBox(height: 16),
                _buildAdditionalDetailsCard(),
              ],
            )
                : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 1, child: _buildApplicantDetailsCard(context)),
                const SizedBox(width: 16),
                Expanded(flex: 2, child: _buildAdditionalDetailsCard()),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildApplicantDetailsCard(BuildContext parentContext) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                child: ClipOval(
                  child: PhotoView(
                    photo: applicant!.photo,
                    editable: false,
                    userId: applicant!.id!,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Two-column layout for details with icons
            _buildDetailRow(
              icon: Icons.person,
              label: 'Ime i prezime',
              value: '${applicant!.firstName} ${applicant!.lastName}',
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              icon: Icons.email,
              label: 'Email',
              value: applicant!.email ?? '-',
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              icon: Icons.phone,
              label: 'Broj telefona',
              value: applicant!.phoneNumber ?? '-',
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              icon: Icons.location_city,
              label: 'Grad',
              value: applicant!.city?.name ?? '-',
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              icon: Icons.verified_user,
              label: 'Račun potvrđen',
              value: applicant!.accountConfirmed == true ? 'Da' : 'Ne',
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              icon: Icons.work,
              label: 'Broj završenih poslova',
              value: applicant!.numberOfFinishedJobs?.toString() ?? '0',
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              icon: Icons.star,
              label: 'Prosječna ocjena',
              value: applicant!.averageRating?.toString() ?? '-',
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: isLoading
                    ? null
                    : () {
                  if (applicant!.deleted!) {
                    _showConfirmationDialog(
                      context: parentContext,
                      title: 'Aktiviraj',
                      content: 'Da li ste sigurni da želite aktivirati ${applicant!.firstName} ${applicant!.lastName}?',
                      onConfirm: activateUser,
                    );
                  } else {
                    _showConfirmationDialog(
                      context: parentContext,
                      title: 'Blokiraj',
                      content: 'Da li ste sigurni da želite blokirati ${applicant!.firstName} ${applicant!.lastName}?',
                      onConfirm: blockUser,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: applicant!.deleted! ? Colors.greenAccent[700] : Colors.redAccent[700],
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                icon: Icon(
                  applicant!.deleted! ? Icons.refresh : Icons.block,
                  color: Colors.white,
                ),
                label: Text(
                  applicant!.deleted! ? 'Aktiviraj korisnika' : 'Blokiraj korisnika',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon
        Icon(
          icon,
          color: primaryColor,
          size: 20,
        ),
        const SizedBox(width: 8),
        // Label column
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        // Value column
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }
  Widget _buildAdditionalDetailsCard() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Wrap the entire content in a SingleChildScrollView
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Dodatni detalji',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              _buildDetailRow(
                icon: Icons.description,
                label: 'Opis',
                value: applicant!.description ?? '-',
              ),
              const SizedBox(height: 12),

              _buildDetailRow(
                icon: Icons.work,
                label: 'Iskustvo',
                value: applicant!.experience ?? '-',
              ),
              const SizedBox(height: 12),

              _buildDetailRow(
                icon: Icons.attach_money,
                label: 'Predložena plata',
                value: applicant!.wageProposal != null && applicant!.wageProposal!> Decimal.zero ? '${applicant!.wageProposal} KM' : '-',
              ),
              const SizedBox(height: 12),

              _buildDetailRow(
                icon: Icons.work_outline, // Icon for job types
                label: 'Tipovi posla',
                value: applicant!.jobTypes != null && applicant!.jobTypes!.isNotEmpty
                    ? applicant!.jobTypes!.map((jobType) => jobType.name).join(', ')
                    : '-',
              ),
              if (applicant!.cv != null)
                Container(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.download),
                    label: const Text('Preuzmi CV'),
                    onPressed: () {
                      _downloadCVFile();
                    },
                  ),
                ),
              const Divider(),
              DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    const TabBar(
                      tabs: [
                        Tab(text: 'Završeni'),
                        Tab(text: 'Utisci'),
                      ],
                    ),
                    // SizedBox for responsiveness, adjusting the TabBarView's height
                    SizedBox(
                      height: 300,
                      child: TabBarView(
                        children: [
                          FinishedJobsView(userId: applicant!.id!),
                          UserRatingsView(userId: applicant!.id!),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

}
