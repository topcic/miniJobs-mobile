import 'package:flutter/material.dart';
import 'package:minijobs_admin/models/job/job.dart';
import 'package:minijobs_admin/pages/jobs/job_card.dart';
import 'package:minijobs_admin/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../../models/job/job_card_dto.dart';

class FinishedJobsView extends StatefulWidget {
  final int userId;
  const FinishedJobsView({super.key,required this.userId});

  @override
  State<FinishedJobsView> createState() => _FinishedJobsViewState();
}

class _FinishedJobsViewState extends State<FinishedJobsView> {
  late UserProvider userProvider;
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
    userProvider=context.read<UserProvider>();
    getFinishedJobs();
  }
    getFinishedJobs()async{
      jobs=await userProvider.getUserFinishedJobs(widget.userId);
      setState(() {
        
      });
    }

  @override
  Widget build(BuildContext context) {
    if (jobs.isEmpty) {
      return const Center(
        child: Text(
          'Korisnik nema završenih poslova',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return SingleChildScrollView( // Make the GridView scrollable
      child: GridView.builder(
        shrinkWrap: true, // Prevents the GridView from taking more space than necessary
        physics: NeverScrollableScrollPhysics(), // Prevents inner scroll of GridView
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of cards in a row
          crossAxisSpacing: 10.0, // Space between cards horizontally
          mainAxisSpacing: 10.0, // Space between cards vertically
        ),
        itemCount: jobs.length, // Number of jobs
        itemBuilder: (BuildContext context, int index) {
          final job = jobs[index];
          return JobCard(job: job);
        },
      ),
    );
  }

}