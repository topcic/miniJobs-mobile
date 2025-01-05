import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:minijobs_mobile/providers/job_provider.dart';
import '../../../enumerations/job_statuses.dart';
import '../../../models/applicant/applicant.dart';
import '../../applicant/applicant_card.dart';

class JobFinishPage extends StatefulWidget {
  final int jobId;
  final JobStatus jobStatus;

  const JobFinishPage({super.key, required this.jobId,required this.jobStatus});

  @override
  _JobFinishPageState createState() => _JobFinishPageState();
}

class _JobFinishPageState extends State<JobFinishPage> {
  List<Applicant> applicants =
  []; // Replace 'dynamic' with your applicant model.
  bool _isLoading = false;
  late JobProvider jobProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    jobProvider = context.read<JobProvider>();
    getApplicants();
  }

  getApplicants() async {
    applicants = await jobProvider.getApplicantsForJob(widget.jobId);
    setState(() {});
  }

  Future<void> _finishJob() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Završi posao'),
          content: Text(
            applicants.isNotEmpty
                ? 'Jeste li sigurni da želite završiti posao? Provjerite jeste li ocijenili sve aplikante koji su sudjelovali.'
                : 'Završetak posla bez odabira i ocjenjivanja aplikanata može utjecati na povratne informacije. Jeste li sigurni da želite nastaviti?',
          ),
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

    if (confirmed ?? false) {
      setState(() => _isLoading = true);

      try {
        // Replace with your job finishing logic
        await Future.delayed(const Duration(seconds: 1)); // Simulated delay
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Došlo je do greške: $e')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Završi posao')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Odaberite aplikante za završetak posla.',
              style: Theme
                  .of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Prije završetka posla, ocijenite i dodajte komentare za aplikante koji su sudjelovali.',
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyMedium,
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: applicants.isEmpty
                  ? const Center(
                child: Text(
                  'Trenutno nema prijavljenih aplikanata za ovaj posao. Možete završiti posao bez odabira aplikanata ili provjeriti status prijava.',
                  textAlign: TextAlign.center,
                ),
              )
                  : ListView.builder(
                itemCount: applicants.length,
                itemBuilder: (context, index) {
                  final applicant = applicants[index];
                  return ApplicantCard(
                    applicant: applicant,
                    jobStatus: widget.jobStatus,
                    jobId: widget.jobId,
                  );
                },
              ),

            ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _finishJob,
                child: const Text('Završi posao'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}