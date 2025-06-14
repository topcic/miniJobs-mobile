import 'package:flutter/material.dart';
import 'package:minijobs_mobile/models/job/job_card_dto.dart';
import 'package:minijobs_mobile/pages/employer/job/job_card.dart';
import 'package:minijobs_mobile/providers/employer_provider.dart';
import 'package:provider/provider.dart';

class ActiveJobsView extends StatefulWidget {
  final int userId;

  const ActiveJobsView({super.key, required this.userId});

  @override
  State<ActiveJobsView> createState() => _ActiveJobsViewState();
}

class _ActiveJobsViewState extends State<ActiveJobsView> {
  late EmployerProvider employerProvider;
  List<JobCardDTO> jobs = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    employerProvider = context.read<EmployerProvider>();
    getFinishedJobs();
  }

  getFinishedJobs() async {
    jobs = await employerProvider.getActiveJobs(widget.userId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Broj kartica u redu
          crossAxisSpacing: 10.0, // Razmak između kartica u redu
          mainAxisSpacing: 10.0, // Razmak između redova kartica
          childAspectRatio: 7 / 8,
        ),
        itemCount: jobs.length,
        // Zamijenite ovu vrijednost s vašim brojem poslova
        itemBuilder: (BuildContext context, int index) {
          final job = jobs[index];
          return JobCard(job: job);
        });
  }
}
