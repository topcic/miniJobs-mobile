import 'package:flutter/material.dart';
import 'package:minijobs_mobile/providers/applicant_provider.dart';
import 'package:provider/provider.dart';

import '../../models/job/job.dart';
import '../employer/job/job_card.dart';

class ApplicantSavedJobsView extends StatefulWidget {
  const ApplicantSavedJobsView({super.key});

  @override
  State<ApplicantSavedJobsView> createState() => _ApplicantSavedJobsViewState();
}

class _ApplicantSavedJobsViewState extends State<ApplicantSavedJobsView> {
  late ApplicantProvider _applicantProvider;
  List<Job> jobs = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _applicantProvider = context.read<ApplicantProvider>();
    getJobs();
  }

  Future<void> getJobs() async {
    try {
      jobs = await _applicantProvider.getSavedJobs();
    } catch (error) {
      // Handle error if necessary
      jobs = [];
    } finally {
      setState(() {}); // Triggers rebuild after jobs are fetched
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Jobs')),
      body: jobs.isEmpty
          ? const Center(
        child: Text(
          'Nemate spremljenih poslova',
          style: TextStyle(fontSize: 16),
        ),
      )
          : ListView.builder(
        itemCount: jobs.length,
        itemBuilder: (context, index) {
          final job = jobs[index];
          return ListView.builder(
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final job = jobs[index];
              return JobCard(job: job);
            },
          );
        },
      ),
    );
  }
}
