import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/applicant_provider.dart';
import '../employer/job/job_application_card.dart';
import '../employer/job/job_card.dart';

class ApplicantAppliedJobsView extends StatefulWidget {
  const ApplicantAppliedJobsView({super.key});

  @override
  _ApplicantAppliedJobsViewState createState() => _ApplicantAppliedJobsViewState();
}

class _ApplicantAppliedJobsViewState extends State<ApplicantAppliedJobsView> {
  late Future<void> _appliedJobsFuture;

  @override
  void initState() {
    super.initState();
    _appliedJobsFuture = _fetchAppliedJobs();
  }

  Future<void> _fetchAppliedJobs() async {
    final applicantProvider = context.read<ApplicantProvider>();
    await applicantProvider.getAppliedJobs();
  }

  @override
  Widget build(BuildContext context) {
    final applicantProvider = context.watch<ApplicantProvider>();
    final appliedJobs = applicantProvider.appliedJobs;

    return Scaffold(
      appBar:  AppBar(title: Text('Aplicirani poslovi')),
      body: FutureBuilder<void>(
        future: _appliedJobsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (appliedJobs == null || appliedJobs.isEmpty) {
            return const Center(
              child: Text(
                'Niste još uvijek aplicirali na posao',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: appliedJobs.length,
            itemBuilder: (context, index) {
              final jobApplication = appliedJobs[index];
              return JobApplicationCard(jobApplication: jobApplication,isInAppliedJobs: true);
            },
          );
        },
      ),
    );
  }
}
