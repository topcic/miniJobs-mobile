import 'package:flutter/material.dart';
import 'package:minijobs_mobile/enumerations/job_application_status.dart';
import 'package:minijobs_mobile/enumerations/job_statuses.dart';
import 'package:minijobs_mobile/models/applicant/applicant.dart';
import 'package:minijobs_mobile/pages/applicant/applicant_card.dart';
import 'package:minijobs_mobile/providers/job_provider.dart';
import 'package:provider/provider.dart';

class JobApplicantsView extends StatefulWidget {
  final int jobId;
  final JobStatus jobStatus;

  const JobApplicantsView({super.key, required this.jobId, required this.jobStatus});

  @override
  State<JobApplicantsView> createState() => _JobApplicantsViewState();
}

class _JobApplicantsViewState extends State<JobApplicantsView> {
  late JobProvider jobProvider;
  List<Applicant> applicants = [];
  bool isJobCompleted=false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    jobProvider = context.read<JobProvider>();
    if(widget.jobStatus==JobStatus.Zavrsen) {
      setState(() {
        isJobCompleted = true; // Update state to reflect job completion
      });
    }
    getAppplicants();
  }

  getAppplicants() async {
    applicants = await jobProvider.getApplicantsForJob(widget.jobId);
    setState(() {});
  }
  Future<void> _finishJob() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Završi posao'),
          content: const Text(
              'Jeste li sigurni da želite završiti posao? Provjerite jeste li ocijenili sve aplikante koji su sudjelovali.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Close dialog
              child: const Text('Ne'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true), // Close dialog
              child: const Text('Da'),
            ),
          ],
        );
      },
    );

    if (confirmed ?? false) {
      // Call jobProvider to finish the job
      var response = await jobProvider.finish(widget.jobId);

      if (response != null && response.id != null) {
        setState(() {
          isJobCompleted = true; // Update state to reflect job completion
        });
      }
    }
  }
  bool hasAcceptedApplicants() {
    return applicants.any((applicant) => applicant.applicationStatus==JobApplicationStatus.Prihvaceno);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aplikanti')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Instructional Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Izaberite aplikanta/e sa kojima ste surađivali na poslu',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, size: 20, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Ovdje možete odabrati aplikante s kojima ste surađivali. Pregledajte listu ispod i označite odgovarajuće aplikante. ',
                              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                            ),
                            TextSpan(
                              text: 'Nakon završetka aplikacija, odobrite ili odbijte aplikacije.',
                              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: applicants.isEmpty
                ? const Center(child: CircularProgressIndicator()) // Added loading indicator
                : ListView.builder(
              itemCount: applicants.length,
              itemBuilder: (context, index) {
                final applicant = applicants[index];
                return ApplicantCard(
                  applicant: applicant,
                  jobStatus: widget.jobStatus,
                  jobId: widget.jobId,
                );
              },
            ),
          ),
          if (hasAcceptedApplicants() && !isJobCompleted)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _finishJob,
                  child: const Text('Završi posao'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
