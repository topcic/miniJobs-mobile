import 'package:flutter/material.dart';
import 'applicant_applied_jobs.dart';
import 'applicant_saved_jobs_view.dart';

class ApplicantJobs extends StatelessWidget {
  const ApplicantJobs({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      initialIndex: 0, // Default tab (Aplicirani poslovi)
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Poslovi'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Aplicirani poslovi'),
              Tab(text: 'Spašeni poslovi'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ApplicantAppliedJobsView(), // View for Aplicirani poslovi
            ApplicantSavedJobsView(), // View for Spašeni poslovi
          ],
        ),
      ),
    );
  }
}
