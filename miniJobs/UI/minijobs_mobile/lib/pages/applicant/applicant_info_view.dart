import 'dart:typed_data';
import 'package:decimal/decimal.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:minijobs_mobile/providers/applicant_provider.dart';

import '../../models/applicant/applicant.dart';

class ApplicantInfoView extends StatefulWidget {
  final int applicantId;
  const ApplicantInfoView({super.key, required this.applicantId});

  @override
  State<ApplicantInfoView> createState() => ApplicantInfoViewState();
}

class ApplicantInfoViewState extends State<ApplicantInfoView> {
  late ApplicantProvider applicantProvider;
  Applicant? applicant;
  bool isLoading = true;
  Uint8List? cvBytes;
  String? cvFileName;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    applicantProvider = context.read<ApplicantProvider>();
    getApplicant();
  }
  void refresh() {
    getApplicant(); // Refresh the data
  }
  Future<void> getApplicant() async {
    applicant = await applicantProvider.get(widget.applicantId);
    setState(() {
      isLoading = false;
      if (applicant?.cv != null) {
        cvBytes = applicant!.cv;
        cvFileName = "CV.${_getFileExtension(applicant!.cv!)}";
      }
    });
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

  Future<void> _downloadCVFile() async {
    if (cvBytes != null && cvFileName != null) {
      String? path = await FileSaver.instance.saveFile(name: cvFileName!, bytes: cvBytes!, ext: "");
      OpenFile.open(path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const SpinKitRing(color: Colors.brown)
        : SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (applicant?.description != null)
              _buildInfoSection('Opis', applicant!.description!),
            if (applicant?.experience != null)
              _buildInfoSection('Iskustvo', applicant!.experience!),
            if (applicant?.wageProposal != null && applicant!.wageProposal!>Decimal.fromInt(0) )
              _buildInfoSection('Plata (KM)', applicant!.wageProposal.toString()),
            if (applicant?.jobTypes != null && applicant!.jobTypes!.isNotEmpty)
              _buildInfoSection(
                'Tipovi posla',
                applicant!.jobTypes!.map((jt) => jt.name).join(', '),
              ),
            if (cvFileName != null) ...[
              const SizedBox(height: 16),
              Card(
                color: Colors.grey[200],
                elevation: 2,
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.description,
                            color: Colors.green[700],
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              cvFileName!,
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: _downloadCVFile,
                        icon: const Icon(Icons.download, color: Colors.blue),
                        label: const Text(
                          'Preuzmi',
                          style: TextStyle(color: Colors.blue),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            if (_allFieldsAreEmpty())
              const Center(
                child: Text(
                  'Korisnik nije dodao dodatne informacije',
                  style: TextStyle(fontSize: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  bool _allFieldsAreEmpty() {
    return applicant?.description == null &&
        applicant?.experience == null &&
        applicant?.wageProposal == null &&
        (applicant?.jobTypes == null || applicant!.jobTypes!.isEmpty) &&
        cvFileName == null;
  }
}
