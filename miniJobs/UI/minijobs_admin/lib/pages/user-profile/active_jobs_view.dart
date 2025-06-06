import 'package:flutter/material.dart';
import 'package:minijobs_admin/models/job/job.dart';
import 'package:minijobs_admin/pages/jobs/job_card.dart';
import 'package:minijobs_admin/providers/employer_provider.dart';
import 'package:provider/provider.dart';

import '../../models/job/job_card_dto.dart';
import '../main/responsve.dart';

class ActiveJobsView extends StatefulWidget {
  final int userId;
  const ActiveJobsView({super.key,required this.userId});

  @override
  State<ActiveJobsView> createState() => _ActiveJobsViewState();
}

class _ActiveJobsViewState extends State<ActiveJobsView> {
  late EmployerProvider employerProvider;
  List<JobCardDTO> jobs = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    employerProvider = context.read<EmployerProvider>();
    getFinishedJobs();
  }

  getFinishedJobs() async {
    jobs = await employerProvider.getActiveJobs(widget.userId);
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    if (jobs.isEmpty) {
      return const Center(
        child: Text(
          'Korisnik nema aktivnih poslova',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return  Responsive(
      mobile: ListView.builder(
        itemCount: jobs.length,
        itemBuilder: (context, index) {
          final job = jobs[index];
          return Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 8.0, horizontal: 16.0),
            child: JobCard(job: job),
          );
        },
      ),
      desktop: LayoutBuilder(
        builder: (context, constraints) {
          // Determine crossAxisCount based on width
          final width = constraints.maxWidth;
          final crossAxisCount = width > 1100
              ? 3
              : width > 700
              ? 2
              : 1;

          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                shrinkWrap: true,
                // Prevents GridView from taking infinite height
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 600, // Matches JobCard's maxWidth
                  mainAxisExtent: 200, // Matches JobCard's maxHeight
                  crossAxisSpacing: 10.0, // Space between cards horizontally
                  mainAxisSpacing: 10.0, // Space between cards vertically
                ),
                itemCount: jobs.length,
                itemBuilder: (context, index) {
                  final job = jobs[index];
                  return JobCard(job: job);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}