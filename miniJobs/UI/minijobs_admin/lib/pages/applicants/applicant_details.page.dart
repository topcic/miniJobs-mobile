import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/applicant/applicant.dart';
import '../../providers/applicant_provider.dart';
import '../../providers/user_provider.dart';
import '../../utils/photo_view.dart';

class ApplicantDetailsPage extends StatefulWidget {
  final Applicant applicant;

  const ApplicantDetailsPage({Key? key, required this.applicant}) : super(key: key);

  @override
  State<ApplicantDetailsPage> createState() => _ApplicantDetailsPageState();
}

class _ApplicantDetailsPageState extends State<ApplicantDetailsPage> {
  late ApplicantProvider _applicantProvider;
  late UserProvider _userProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _applicantProvider = context.read<ApplicantProvider>();
    _userProvider = context.read<UserProvider>();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    // Add logic to fetch user-specific data if required
  }

  Future<void> blockUser() async {
    await _userProvider.delete(widget.applicant.id!);
    setState(() {
      widget.applicant.deleted = true;
    });
  }

  Future<void> activateUser() async {
    await _userProvider.activate(widget.applicant.id!);
    setState(() {
      widget.applicant.deleted = false;
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
              onConfirm();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final applicant = widget.applicant;
    return Scaffold(
      appBar: AppBar(
        title: Text('${applicant.firstName} ${applicant.lastName}'),
        centerTitle: true,
      ),
      body: LayoutBuilder(
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
    final applicant = widget.applicant;

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
                    photo: applicant.photo,
                    editable: false,
                    userId: applicant.id!,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _detailRow('Ime i prezime:', '${applicant.firstName} ${applicant.lastName}'),
            _detailRow('Email:', applicant.email ?? '-'),
            _detailRow('Broj telefona:', applicant.phoneNumber ?? '-'),
            _detailRow('Grad:', applicant.city?.name ?? '-'),
            _detailRow('Račun potvrđen:', applicant.accountConfirmed == true ? 'Da' : 'Ne'),
            _detailRow('Broj završenih poslova:', applicant.numberOfFinishedJobs?.toString() ?? '0'),
            _detailRow('Prosječna ocjena:', applicant.averageRating?.toString() ?? '-'),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  if (applicant.deleted!) {
                    _showConfirmationDialog(
                      context: context,
                      title: 'Aktiviraj',
                      content:
                      'Da li ste sigurni da želite aktivirati ${applicant.firstName} ${applicant.lastName}?',
                      onConfirm: activateUser,
                    );
                  } else {
                    _showConfirmationDialog(
                      context: context,
                      title: 'Blokiraj',
                      content:
                      'Da li ste sigurni da želite blokirati ${applicant.firstName} ${applicant.lastName}?',
                      onConfirm: blockUser,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: applicant.deleted!
                      ? Colors.greenAccent[700]
                      : Colors.redAccent[700],
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                icon: Icon(
                  applicant.deleted! ? Icons.refresh : Icons.block,
                  color: Colors.white,
                ),
                label: Text(
                  applicant.deleted! ? 'Aktiviraj korisnika' : 'Blokiraj korisnika',
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
    final applicant = widget.applicant;

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dodatni detalji',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            _detailRow('Opis:', applicant.description ?? '-'),
            _detailRow('Iskustvo:', applicant.experience ?? '-'),
            _detailRow(
              'Predložena plata:',
              applicant.wageProposal != null
                  ? '${applicant.wageProposal.toString()} KM'
                  : '-',
            ),
            const Divider(),
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: applicant.jobTypes?.length ?? 0,
                itemBuilder: (context, index) {
                  final jobType = applicant.jobTypes![index];
                  return ListTile(
                    title: Text(jobType.name ?? '-'),
                    leading: const Icon(Icons.work_outline),
                  );
                },
              ),
            ),
            if (applicant.cv != null)
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.download),
                  label: const Text('Preuzmi CV'),
                  onPressed: () {
                    // Add CV download functionality
                  },
                ),
              ),
          ],
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
