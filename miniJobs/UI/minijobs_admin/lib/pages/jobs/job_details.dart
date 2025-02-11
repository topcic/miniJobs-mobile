import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../enumerations/job_statuses.dart';
import '../../models/job/job.dart';
import '../../providers/job_provider.dart';
import '../main/constants.dart';
import 'job_applications_view.dart';
import 'job_details_content.dart';

class JobDetailsPage extends StatefulWidget {
  final int jobId;

  const JobDetailsPage({super.key, required this.jobId});

  @override
  _JobDetailsPageState createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage> {
  late JobProvider jobProvider;
  Job? job;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    jobProvider = context.read<JobProvider>();
    _fetchJob();
  }

  Future<void> _fetchJob() async {
    try {
      final fetchedJob = await jobProvider.get(widget.jobId);
      setState(() {
        job = fetchedJob;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Greška pri dohvaćanju podataka o poslu')),
      );
    }
  }

  void _onBackPressed() {
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return false; // Prevent default pop
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detalji posla'),
          backgroundColor: secondaryColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _onBackPressed, // ✅ Ensure back button also returns data
          ),
        ),
        backgroundColor: bgColor,
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : job == null
            ? const Center(
            child: Text('Podaci nisu dostupni',
                style: TextStyle(color: Colors.white)))
            : SingleChildScrollView(
          padding: const EdgeInsets.all(defaultPadding),
          child: JobDetailsContent(job: job!),
        ),
      ),
    );
  }
}
class JobActions extends StatefulWidget {
  final Job job;

  const JobActions({super.key, required this.job});

  @override
  _JobActionsState createState() => _JobActionsState();
}

class _JobActionsState extends State<JobActions> {
  late Job job;
  late JobProvider jobProvider;

  @override
  void initState() {
    super.initState();
    job = widget.job;
    jobProvider = context.read<JobProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: defaultPadding),
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: primaryColor.withOpacity(0.15)),
        borderRadius: const BorderRadius.all(Radius.circular(defaultPadding)),
      ),
      child: Row(
        children: [
          if (job.deletedByAdmin)
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh, color: Colors.green),
              label: const Text('Aktiviraj'),
              style: ElevatedButton.styleFrom(backgroundColor: secondaryColor),
              onPressed: () => _confirmAction(context, 'Aktiviraj posao?', () {
                jobProvider.activateByAdmin(job.id!);
                setState(() => job.deletedByAdmin = false);
              }),
            )
          else
            ElevatedButton.icon(
              icon: const Icon(Icons.block, color: Colors.red),
              label: const Text('Obriši'),
              style: ElevatedButton.styleFrom(backgroundColor: secondaryColor),
              onPressed: () => _confirmAction(context, 'Obriši posao?', () {
                jobProvider.deleteByAdmin(job.id!);
                setState(() => job.deletedByAdmin = true);
              }),
            ),
          const SizedBox(width: 10),
          if (job.status == JobStatus.Aktivan ||
              job.status == JobStatus.AplikacijeZavrsene ||
              job.status == JobStatus.Zavrsen)
            ElevatedButton.icon(
              icon: const Icon(Icons.group, color: primaryColor),
              label: const Text('Aplikanti'),
              style: ElevatedButton.styleFrom(backgroundColor: secondaryColor),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JobApplicationsView(jobId: job.id!),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  void _confirmAction(BuildContext context, String title, VoidCallback action) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: const Text('Da li ste sigurni?'),
        actions: [
          TextButton(
            child: const Text('Odustani'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Potvrdi'),
            onPressed: () {
              action();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
