import 'package:flutter/material.dart';
import 'package:minijobs_admin/models/applicant/applicant.dart';
import '../../utils/photo_view.dart';

class ApplicantDetailsPage extends StatelessWidget {
  final Applicant applicant;

  const ApplicantDetailsPage({Key? key, required this.applicant})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            _detailRow('Uloga:', applicant.role ?? '-'),
            _detailRow('Račun potvrđen:', applicant.accountConfirmed == true ? 'Da' : 'Ne'),
            _detailRow('Broj završenih poslova:', applicant.numberOfFinishedJobs?.toString() ?? '0'),
            _detailRow('Prosječna ocjena:', applicant.averageRating?.toString() ?? '-'),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => _showBlockConfirmation(parentContext),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                icon: const Icon(Icons.block),
                label: const Text('Blokiraj korisnika'),
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
              height: 200, // Limit list height
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
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
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

  void _showBlockConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Blokiraj korisnika'),
        content: const Text('Da li ste sigurni da želite blokirati ovog korisnika?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Otkaži'),
          ),
          TextButton(
            onPressed: () {
              // Add block functionality
              Navigator.of(context).pop();
            },
            child: const Text('Blokiraj', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
