import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:minijobs_mobile/providers/job_provider.dart';

import '../../../models/applicant/applicant.dart';
import '../../applicant/applicant_card.dart';

class JobFinishPage extends StatefulWidget {
  final int jobId;

  const JobFinishPage({Key? key, required this.jobId}) : super(key: key);

  @override
  _JobFinishPageState createState() => _JobFinishPageState();
}

class _JobFinishPageState extends State<JobFinishPage> {
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
    getApplicants();
  }

  Future<void> getApplicants() async {
    applicants = await jobProvider.getApplicantsForJob(widget.jobId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Završi posao'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Izaberite aplikanta sa kojim ste surađivali.',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Da bi ste završili posao potrebno je da ocijenite i dodate komentar za aplikanta koji su Vam obavili posao.',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: applicants.isEmpty
                  ? const Center(child: Text('No applicants found.'))
                  : ListView.builder(
                itemCount: applicants.length,
                itemBuilder: (context, index) {
                  final applicant = applicants[index];
                  return ApplicantCard(applicant: applicant,showChooseButton:true);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
