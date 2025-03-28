import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
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
            _detailRow('Ime i prezime:', '${applicant!.firstName} ${applicant!.lastName}'),
            _detailRow('Email:', applicant!.email ?? '-'),
            _detailRow('Broj telefona:', applicant!.phoneNumber ?? '-'),
            _detailRow('Grad:', applicant!.city?.name ?? '-'),
            _detailRow('Račun potvrđen:', applicant!.accountConfirmed == true ? 'Da' : 'Ne'),
            _detailRow('Broj završenih poslova:', applicant!.numberOfFinishedJobs?.toString() ?? '0'),
            _detailRow('Prosječna ocjena:', applicant!.averageRating?.toString() ?? '-'),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: isLoading
                    ? null
                    : () {
                  if (applicant!.deleted!) {
                    _showConfirmationDialog(
                      context: context,
                      title: 'Aktiviraj',
                      content: 'Da li ste sigurni da želite aktivirati ${applicant!.firstName} ${applicant!.lastName}?',
                      onConfirm: activateUser,
                    );
                  } else {
                    _showConfirmationDialog(
                      context: context,
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
              _detailRow('Opis:', applicant!.description ?? '-'),
              _detailRow('Iskustvo:', applicant!.experience ?? '-'),
              _detailRow(
                'Predložena plata:',
                applicant!.wageProposal != null
                    ? '${applicant!.wageProposal.toString()} KM'
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


  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.grey),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
