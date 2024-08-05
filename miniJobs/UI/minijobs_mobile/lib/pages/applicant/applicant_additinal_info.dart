import 'dart:io';
import 'dart:typed_data';
import 'package:decimal/decimal.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mime/mime.dart';
import 'package:minijobs_mobile/models/applicant/applicant.dart';
import 'package:minijobs_mobile/providers/applicant_provider.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import '../../models/applicant/applicant_save_request.dart';
import '../../models/job_type.dart';
import '../../providers/job_type_provider.dart';

class ApplicantAdditionalInfo extends StatefulWidget {
  final int applicantId;
  const ApplicantAdditionalInfo({super.key, required this.applicantId});

  @override
  State<ApplicantAdditionalInfo> createState() => _ApplicantAdditionalInfoState();
}

class _ApplicantAdditionalInfoState extends State<ApplicantAdditionalInfo> {
  final _formKey = GlobalKey<FormBuilderState>();
  late ApplicantProvider applicantProvider;
  late JobTypeProvider jobTypeProvider = JobTypeProvider();

  Applicant? applicant;
  bool isLoading = true;
  Uint8List? cvBytes;
  String? cvFileName;
  List<JobType>? jobTypes;
  List<int>? selectedJobTypeIds;

  final experienceOptions = [
    'Bez iskustva',
    'Manje od 1 godinu',
    'Od 1-3 godine',
    '5+ godina'
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    applicantProvider = context.read<ApplicantProvider>();
    getApplicant();
    getJobTypes();
  }

  Future<void> getApplicant() async {
    applicant = await applicantProvider.get(widget.applicantId);
    setState(() {
      isLoading = false;
      if (applicant?.cv != null) {
        cvBytes = applicant!.cv;
        cvFileName = "CV.${_getFileExtension(applicant!.cv!)}";
      }
      selectedJobTypeIds = applicant?.jobTypes
          ?.map((jt) => jt.id)
          .whereType<int>()
          .toList();
    });
  }

  Future<void> getJobTypes() async {
    jobTypes = await jobTypeProvider.getAll();
    setState(() {});
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

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final formData = _formKey.currentState!.value;

      final String? wageProposalStr = formData['wageProposal'];
      Decimal? wageProposal;
      if (wageProposalStr != null && wageProposalStr.isNotEmpty) {
        try {
          wageProposal = Decimal.parse(wageProposalStr);
        } catch (e) {
          wageProposal = null;
        }
      }

      final request = ApplicantSaveRequest(
        applicant?.firstName,
        applicant?.lastName,
        applicant?.phoneNumber,
        applicant?.cityId,
        formData['description'],
        formData['experience'],
        wageProposal,
        cvBytes,
        cvFileName,
        selectedJobTypeIds ?? [],
      );

      try {
        await applicantProvider.update(widget.applicantId, request);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Changes saved successfully')),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save changes: $error')),
        );
      }
    }
  }

  Future<void> _pickCVFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      if (file.path != null) {
        final File selectedFile = File(file.path!);
        final bytes = await selectedFile.readAsBytes();
        setState(() {
          cvBytes = bytes;
          cvFileName = file.name;
        });
      }
    }
  }

  Future<void> _downloadCVFile() async {
    if (cvBytes != null && cvFileName != null) {
      String? path = await FileSaver.instance.saveFile(name: cvFileName!, bytes: cvBytes!, ext: "");
        OpenFile.open(path);
    }
  }

  void _removeCVFile() {
    setState(() {
      cvBytes = null;
      cvFileName = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const SpinKitRing(color: Colors.brown)
        : SingleChildScrollView(
      child: FormBuilder(
        key: _formKey,
        initialValue: applicant != null
            ? {
          'description': applicant!.description,
          'experience': applicant!.experience,
          'wageProposal': applicant!.wageProposal?.toString(),
          'jobTypes': selectedJobTypeIds,
        }
            : {},
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildTextField('description', 'Opis', maxLines: 5),
              const SizedBox(height: 16),
              FormBuilderDropdown<String>(
                name: 'experience',
                decoration: const InputDecoration(labelText: 'Iskustvo'),
                items: experienceOptions
                    .map((experience) => DropdownMenuItem(
                  value: experience,
                  child: Text(experience),
                ))
                    .toList(),
              ),
              const SizedBox(height: 16),
              _buildTextField('wageProposal', 'Plata (KM)'),
              const SizedBox(height: 16),
              MultiSelectDialogField<int>(
                items: jobTypes?.map((jobType) => MultiSelectItem<int>(jobType.id!, jobType.name!)).toList() ?? [],
                title: const Text("Tipovi posla"),
                initialValue: selectedJobTypeIds ?? [], // Use initialValue instead of selectedItems
                  buttonText: const Text(
                    "Izaberite tip posla jim se bavite", // Your placeholder text here
                    style: TextStyle(
                      color: Colors.grey, // Placeholder text color
                    ),
                  ),
                onConfirm: (values) {
                  setState(() {
                    selectedJobTypeIds = values.cast<int>();
                  });
                }
              ),

              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _pickCVFile,
                      icon: const Icon(Icons.upload_file),
                      label: const Text('Odaberi CV'),
                    ),
                  ),
                ],
              ),
              if (cvFileName != null) ...[
                const SizedBox(height: 10),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextButton.icon(
                              onPressed: _downloadCVFile,
                              icon: const Icon(Icons.download,
                                  color: Colors.blue),
                              label: const Text(
                                'Preuzmi',
                                style: TextStyle(color: Colors.blue),
                              ),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8),
                              ),
                            ),
                            const SizedBox(width: 10),
                            TextButton.icon(
                              onPressed: _removeCVFile,
                              icon: const Icon(Icons.delete,
                                  color: Colors.red),
                              label: const Text(
                                'Ukloni',
                                style: TextStyle(color: Colors.red),
                              ),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveChanges,
                      child: const Text('Spasi promjene'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String name, String label, {int maxLines = 1}) {
    return FormBuilderTextField(
      name: name,
      maxLines: maxLines,
      decoration: InputDecoration(labelText: label),
      validator: (value) {
        return null;
      },
    );
  }
}
