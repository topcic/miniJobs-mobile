import 'package:flutter/material.dart';
import 'package:minijobs_mobile/models/job/job.dart';
import 'package:minijobs_mobile/models/job/job_card_dto.dart';
import 'package:minijobs_mobile/pages/employer/job/job_card.dart';
import 'package:minijobs_mobile/providers/user_provider.dart';
import 'package:provider/provider.dart';

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
    return   GridView.builder(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2, // Broj kartica u redu
      crossAxisSpacing: 10.0, // Razmak između kartica u redu
      mainAxisSpacing: 10.0, // Razmak između redova kartica
    ),
    itemCount: jobs.length, // Zamijenite ovu vrijednost s vašim brojem poslova
    itemBuilder: (BuildContext context, int index) {
       final job= jobs[index];
     return JobCard(job:job);
    }
    );
  }
}