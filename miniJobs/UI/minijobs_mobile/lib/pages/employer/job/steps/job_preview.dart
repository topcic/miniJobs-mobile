import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:minijobs_mobile/enumerations/job_statuses.dart';
import 'package:minijobs_mobile/models/job/job.dart';
import 'package:minijobs_mobile/providers/job_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class JobPreview extends StatefulWidget {
  const JobPreview({super.key});

  @override
  State<JobPreview> createState() => _JobPreviewState();
}

class _JobPreviewState extends State<JobPreview> {
  bool isJobCompleted = false;

  @override
  void initState() {
    super.initState();
    // Initialize job status
    final jobProvider = Provider.of<JobProvider>(context, listen: false);
    final Job? job = jobProvider.getCurrentJob();
    if (job?.status == JobStatus.Zavrsen) {
      setState(() {
        isJobCompleted = true;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final jobProvider = Provider.of<JobProvider>(context, listen: false);
    final Job? job = jobProvider.getCurrentJob();
    setState(() {
      isJobCompleted = job?.status == JobStatus.Zavrsen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final jobProvider = Provider.of<JobProvider>(context);
    final Job? job = jobProvider.getCurrentJob();
    final userName =
        '${GetStorage().read('givenname')} ${GetStorage().read('surname')}';

    if (job == null) {
      return const SizedBox.shrink(); // Returns an empty widget
    }

    Future<void> finishJob() async {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Završi posao'),
            content: const Text(
              'Jeste li sigurni da želite završiti posao? Provjerite jeste li odabrali sve aplikante koji su sudjelovali.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Ne'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Da'),
              ),
            ],
          );
        },
      );

      if (confirmed ?? false) {
        var response = await jobProvider.finish(job.id!);

        if (response != null && response.id != null) {
          setState(() {
            isJobCompleted = true;
          });
        }
      }
    }

    Future<void> completeApplicationsJob() async {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Završi aplikacije'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Jeste li sigurni da želite završiti aplikacije?"),
                const SizedBox(height: 8),
                const Text("- Nakon ovoga niko neće moći da aplicira.",
                    style: TextStyle(fontSize: 14)),
                const Text(
                    "- Ova opcija je za slučaj da ste se dogovorili sa radnikom.",
                    style: TextStyle(fontSize: 14)),
                const SizedBox(height: 8),
                Text(
                    "Ako niste sigurni, možete sačekati ili se vratiti kasnije.",
                    style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Ne'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Da'),
              ),
            ],
          );
        },
      );

      if (confirmed ?? false) {
        var response = await jobProvider.completeApplications(job.id!);

        if (response != null && response.id != null) {
          setState(() {
            job.status = JobStatus.AplikacijeZavrsene;
          });
        }
      }
    }

    // Create a QuillController for rendering the description
    final quillController = quill.QuillController(
      document: job.description != null
          ? quill.Document.fromJson(jsonDecode(job.description!))
          : quill.Document(),
      selection: const TextSelection.collapsed(offset: 0),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              job.name!,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.deepPurple[800],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '$userName - ${job.city?.name ?? ''}',
              style: TextStyle(fontSize: 16, color: Colors.deepPurple[300]),
            ),
            Divider(color: Colors.grey[400], height: 20),
            Text(
              'Opis posla:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.deepPurple[700],
              ),
            ),
            const SizedBox(height: 8),
            // Render rich text using a read-only QuillEditor
            Container(
              padding: const EdgeInsets.all(8),
              child: SizedBox(

                child: IgnorePointer(
                  child: quill.QuillEditor(
                    controller: quill.QuillController(
                      document: job.description != null
                          ? quill.Document.fromJson(jsonDecode(job.description!))
                          : quill.Document(),
                      selection: const TextSelection.collapsed(offset: 0),
                    ),
                    focusNode: FocusNode(),
                    scrollController: ScrollController(),

                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  'Tip posla:',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.deepPurple[700],
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  job.jobType?.name ?? '',
                  style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'Potrebno radnika:',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.deepPurple[700],
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  job.requiredEmployees?.toString() ?? '0',
                  style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'Plaćanje:',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.deepPurple[700],
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  job.paymentQuestion?.answer ?? '',
                  style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                ),
                if (job.wage != null && job.wage! > 0)
                  Text(
                    ': ${job.wage!} KM',
                    style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Raspored posla:',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.deepPurple[700],
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: job.schedules?.map((schedule) {
                return Text(
                  schedule.answer ?? '',
                  style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                );
              }).toList() ??
                  [],
            ),
            if (job.additionalPaymentOptions != null &&
                job.additionalPaymentOptions!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Dodatno plaća:',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.deepPurple[700],
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: job.additionalPaymentOptions!.map((option) {
                  return Text(
                    option.answer!,
                    style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 12),
            if (isJobCompleted) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle, color: Colors.red[800]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Posao je završen',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.red[800],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Aplikacije traju do:',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue[800],
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('dd.MM.yyyy').format(job.status ==
                          JobStatus.Kreiran
                          ? DateTime.now()
                          : job.applicationsStart!.add(
                          Duration(days: job.applicationsDuration!))),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue[800],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16.0),
            if (job.status == JobStatus.Aktivan &&
                !isJobCompleted &&
                job.numberOfApplications! > 0)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: completeApplicationsJob,
                  child: const Text('Završi aplikacije'),
                ),
              ),
            const SizedBox(height: 16.0),
            if (job.status == JobStatus.AplikacijeZavrsene &&
                !isJobCompleted)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: finishJob,
                  child: const Text('Završi posao'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}