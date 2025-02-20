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
List<JobCardDTO> jobs=[];
@override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    employerProvider=context.read<EmployerProvider>();
    getFinishedJobs();
  }
    getFinishedJobs()async{
      jobs=await employerProvider.getActiveJobs(widget.userId);
      setState(() {
        
      });
    }

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: ListView.builder(
        itemCount: jobs.length,
        itemBuilder: (context, index) {
          final job = jobs[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: JobCard(job: job),
          );
        },
      ),
      desktop: SingleChildScrollView( // Make the content scrollable on desktop
        child: Container(
          child: GridView.builder(
            shrinkWrap: true, // Prevents the GridView from taking more space than necessary
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 2, // Height is double the width
            ),
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final job = jobs[index];
              return JobCard(job: job);
            },
          ),
        ),
      ),
    );
  }
}