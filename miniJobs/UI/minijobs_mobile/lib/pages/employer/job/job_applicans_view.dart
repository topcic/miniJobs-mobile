import 'package:flutter/material.dart';
import 'package:minijobs_mobile/models/applicant.dart';
import 'package:minijobs_mobile/pages/applicant/applicant_card.dart';
import 'package:minijobs_mobile/pages/employer/job/steps/job_preview.dart';
import 'package:minijobs_mobile/providers/job_provider.dart';
import 'package:provider/provider.dart';

class JobApplicantsView extends StatefulWidget {
  final int jobId;
  const JobApplicantsView({super.key, required this.jobId});

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
      body: applicants.isEmpty
          ? Center(child: Text('No applicants found.'))
          : ListView.builder(
              itemCount: applicants.length,
              itemBuilder: (context, index) {
                final applicant = applicants[index];
                return ApplicantCard(applicant: applicant);
              },
            ),
    );
  }
}
