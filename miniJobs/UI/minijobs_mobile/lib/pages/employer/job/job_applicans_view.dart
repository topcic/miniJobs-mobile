import 'package:flutter/material.dart';
import 'package:minijobs_mobile/enumerations/job_statuses.dart';
import 'package:minijobs_mobile/models/applicant/applicant.dart';
import 'package:minijobs_mobile/pages/applicant/applicant_card.dart';
import 'package:minijobs_mobile/providers/job_provider.dart';
import 'package:provider/provider.dart';

class JobApplicantsView extends StatefulWidget {
  final int jobId;
  final JobStatus jobStatus;

  const JobApplicantsView(
      {super.key, required this.jobId, required this.jobStatus});

  @override
  State<JobApplicantsView> createState() => _JobApplicantsViewState();
}

class _JobApplicantsViewState extends State<JobApplicantsView> {
  late JobProvider jobProvider;
  List<Applicant> applicants = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    jobProvider = context.read<JobProvider>();
    getAppplicants();
  }

  getAppplicants() async {
    applicants = await jobProvider.getApplicantsForJob(widget.jobId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aplikanti'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Instructional Header
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Izaberite aplikanta/ke sa kojima ste surađivali na poslu',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Ovdje možete odabrati aplikante s kojima ste surađivali. Pregledajte listu ispod i označite odgovarajuće aplikante.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: applicants.isEmpty
                ? const Center(
                    child: Text(
                      'Nema dostupnih aplikanta za ovaj posao.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: applicants.length,
                    itemBuilder: (context, index) {
                      final applicant = applicants[index];
                      return ApplicantCard(
                          applicant: applicant,
                          jobStatus: widget.jobStatus,
                          jobId: widget.jobId);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
