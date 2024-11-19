import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/applicant_provider.dart';
import '../employer/job/job_card.dart';

class ApplicantSavedJobsView extends StatefulWidget {
  const ApplicantSavedJobsView({super.key});

  @override
  _ApplicantSavedJobsViewState createState() => _ApplicantSavedJobsViewState();
}

class _ApplicantSavedJobsViewState extends State<ApplicantSavedJobsView> {
  late Future<void> _savedJobsFuture;

  @override
  void initState() {
    super.initState();
    // Fetch the saved jobs when the view is created
    _savedJobsFuture = _fetchSavedJobs();
  }

  Future<void> _fetchSavedJobs() async {
    final applicantProvider = context.read<ApplicantProvider>();
    await applicantProvider.getSavedJobs();
  }

  @override
  Widget build(BuildContext context) {
    final applicantProvider = context.watch<ApplicantProvider>();
    final savedJobs = applicantProvider.savedJobs;

    return Scaffold(
      appBar:  AppBar(title: Text('Spašeni poslovi')),
      body: FutureBuilder<void>(
        future: _savedJobsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (savedJobs == null || savedJobs.isEmpty) {
            return const Center(
              child: Text(
                'Nemate spremljenih poslova',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: savedJobs.length,
            itemBuilder: (context, index) {
              final job = savedJobs[index];
              return JobCard(job: job,isInSavedJobs: true);
            },
          );
        },
      ),
    );
  }
}
