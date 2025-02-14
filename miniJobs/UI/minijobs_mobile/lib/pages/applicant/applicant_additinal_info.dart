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
import '../../services/notification.service.dart';

class ApplicantAdditionalInfo extends StatefulWidget {
  final int applicantId;
  const ApplicantAdditionalInfo({super.key, required this.applicantId});

  @override
  State<ApplicantAdditionalInfo> createState() => _ApplicantAdditionalInfoState();
}

class _ApplicantAdditionalInfoState extends State<ApplicantAdditionalInfo> {
  final notificationService = NotificationService();
  final _formKey = GlobalKey<FormBuilderState>();
  late ApplicantProvider applicantProvider;
  late JobTypeProvider jobTypeProvider;

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
    jobTypeProvider = context.read<JobTypeProvider>();
    fetchData();
  }

  Future<void> fetchData() async {
    await Future.wait([getApplicant(), getJobTypes()]);
    setState(() => isLoading = false);
  }

  Future<void> getApplicant() async {
    applicant = await applicantProvider.get(widget.applicantId);
    if (applicant?.cv != null) {
      cvBytes = applicant!.cv;
      cvFileName = "CV.${_getFileExtension(applicant!.cv!)}";
    }
    selectedJobTypeIds = applicant?.jobTypes?.map((jt) => jt.id).whereType<int>().toList();
  }

  Future<void> getJobTypes() async {
    jobTypes = await jobTypeProvider.getAll();
  }

  String _getFileExtension(Uint8List bytes) {
    final mimeType = lookupMimeType('', headerBytes: bytes);
    if (mimeType != null) return mimeType.split('/').last;

    final signatures = {
      '25504446': 'pdf',
      '504B0304': 'docx',
      'D0CF11E0': 'doc',
    };
    final header = bytes.take(4).map((byte) => byte.toRadixString(16).padLeft(2, '0')).join().toUpperCase();
    return signatures[header] ?? '';
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final formData = _formKey.currentState!.value;

      Decimal? wageProposal;
      final wageProposalStr = formData['wageProposal'];
      if (wageProposalStr != null && wageProposalStr.isNotEmpty) {
        try {
          wageProposal = Decimal.parse(wageProposalStr);
          if (wageProposal < Decimal.zero) {
            notificationService.error('Plata ne može biti negativna.');
            return;
          }
        } catch (e) {
          notificationService.error('Neispravan unos plate.');
          return;
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
        notificationService.success('Promjene uspješno spašene');
      } catch (_) {
        notificationService.error('Došlo je do greške');
      }
    }
  }

  Future<void> _pickCVFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null && result.files.isNotEmpty) {
      PlatformFile file = result.files.first;
      if (file.path != null) {
        final bytes = await File(file.path!).readAsBytes();
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
        initialValue: {
          'description': applicant?.description,
          'experience': applicant?.experience,
          'wageProposal': applicant?.wageProposal?.toString(),
          'jobTypes': selectedJobTypeIds,
        },
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
                    .map((exp) => DropdownMenuItem(value: exp, child: Text(exp)))
                    .toList(),
              ),
              const SizedBox(height: 16),
              _buildTextField('wageProposal', 'Plata (KM)', isNumeric: true),
              const SizedBox(height: 16),
              MultiSelectDialogField<int>(
                items: jobTypes?.map((jt) => MultiSelectItem<int>(jt.id!, jt.name!)).toList() ?? [],
                title: const Text("Tipovi posla"),
                initialValue: selectedJobTypeIds ?? [],
                buttonText: const Text("Izaberite tip posla kojim se bavite"),
                onConfirm: (values) => setState(() => selectedJobTypeIds = values.cast<int>()),
              ),
              const SizedBox(height: 16),
              _buildFilePicker(),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _saveChanges, child: const Text('Spasi promjene')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String name, String label, {int maxLines = 1, bool isNumeric = false}) {
    return FormBuilderTextField(
      name: name,
      maxLines: maxLines,
      decoration: InputDecoration(labelText: label),
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      validator: (value) => isNumeric && value != null && double.tryParse(value) == null
          ? 'Unesite ispravnu vrijednost'
          : null,
    );
  }

  Widget _buildFilePicker() {
    return Column(
      children: [
        ElevatedButton.icon(onPressed: _pickCVFile, icon: const Icon(Icons.upload_file), label: const Text('Odaberi CV')),
        if (cvFileName != null)
          ListTile(
            leading: const Icon(Icons.description, color: Colors.green),
            title: Text(cvFileName!, overflow: TextOverflow.ellipsis),
            trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: _removeCVFile),
          ),
      ],
    );
  }
}
