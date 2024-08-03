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
  bool _isLoading = false;

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

  bool get _canFinishJob {
    return applicants.any((applicant) => applicant.isRated == true);
  }

  Future<void> _finishJob() async {
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Završi posao'),
          content: const Text('Da li ste sigurni da ste ocjenili sve aplikante i da želite završiti posao?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Ne'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Da'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      setState(() {
        _isLoading = true;
      });

      try {
        await jobProvider.finish(widget.jobId);
        Navigator.of(context).pop(); // Navigate back after finishing the job
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Došlo je do greške: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
                  return ApplicantCard(
                    applicant: applicant,
                    showChooseButton: true,
                  );
                },
              ),
            ),
            const SizedBox(height: 16.0), // Add spacing above the button
            Visibility(
              visible: _canFinishJob,
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _finishJob,
                      child: const Text('Završi posao'),
                    ),
                  ),
                  if (_isLoading)
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
