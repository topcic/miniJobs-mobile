import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:minijobs_mobile/models/job/job.dart';
import 'package:minijobs_mobile/pages/employer/job/job_details.dart';
import 'package:intl/intl.dart';
import 'package:minijobs_mobile/widgets/badges.dart';

import '../../enumerations/job_statuses.dart';
import '../../providers/employer_provider.dart';
import '../../providers/job_provider.dart';
import 'job/job_applicans_view.dart';
import 'job/job_finish_page.dart';

class JobList extends StatefulWidget {
  const JobList({super.key});

  @override
  _JobListState createState() => _JobListState();
}

class _JobListState extends State<JobList> {
  late EmployerProvider employerProvider;
  late JobProvider jobProvider;
  List<Job> jobs = [];
  bool isLoading = true;
  int userId = int.parse(GetStorage().read('userId'));

  @override
  void initState() {
    super.initState();
    employerProvider = EmployerProvider();
    jobProvider = JobProvider();
    getJobs();
  }

  Future<void> getJobs() async {
    setState(() {
      isLoading = true;
    });
    jobs = await employerProvider.getJobs(userId);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vaši poslovi'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: jobs.length,
        itemBuilder: (context, index) {
          final job = jobs[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            elevation: 4,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(job.name ?? 'No Name'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (job.created != null)
                    Text(
                      'Kreirano: ${DateFormat('dd.MM.yyyy.').format(job.created!)}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  if (job.applicationsDuration != null)
                    Text(
                      'Prijave traju do: ${DateFormat('dd.MM.yyyy.').format(DateTime.now().add(Duration(days: job.applicationsDuration!)))}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  if (job.numberOfApplications != null && job.numberOfApplications! > 0)
                    Text(
                      'Broj prijava: ${job.numberOfApplications}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                ],
              ),
              trailing: JobBadge(status: job.status!),
              isThreeLine: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JobDetails(jobId: job.id!),
                  ),
                );
              },
              onLongPress: () {
                _showActionDialog(context, job);
              },
              leading: PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, size: 24),
                itemBuilder: (BuildContext context) {
                  List<PopupMenuEntry<String>> menuItems = [
                    if (job.numberOfApplications != null && job.numberOfApplications! > 0)
                      const PopupMenuItem<String>(
                        value: 'applicants',
                        child: ListTile(
                          leading: Icon(Icons.people, color: Colors.blue),
                          title: Text('Aplikanti'),
                        ),
                      ),
                    const PopupMenuItem<String>(
                      value: 'details',
                      child: ListTile(
                        leading: Icon(Icons.reorder),
                        title: Text('Detalji'),
                      ),
                    ),
                    if (job.numberOfApplications != null && job.numberOfApplications! > 0 && job.status == JobStatus.Aktivan)
                      const PopupMenuItem<String>(
                        value: 'complete',
                        child: ListTile(
                          leading: Icon(Icons.check, color: Colors.green),
                          title: Text('Završi posao'),
                        ),
                      ),
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: ListTile(
                        leading: Icon(Icons.delete, color: Colors.red),
                        title: Text('Obriši'),
                      ),
                    ),
                  ];
                  return menuItems;
                },
                onSelected: (String value) {
                  if (value == 'details') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JobDetails(jobId: job.id!),
                      ),
                    );
                  } else if (value == 'delete') {
                    _handleDelete(job);
                  } else if (value == 'complete') {
                    _handleComplete(job);
                  } else if (value == 'applicants') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JobApplicantsView(jobId: job.id!),
                      ),
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleDelete(Job job) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Potvrda brisanja'),
          content: const Text('Da li ste sigurni da želite da obrišete?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Otkaži'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Obriši'),
              onPressed: () async {
                try {
                  await jobProvider.delete(job.id!); // Ensure deletion is completed
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Uspješno obrisano')),
                  );
                  setState(() {
                    jobs.remove(job); // Remove the job from the list
                  });
                  Navigator.of(context).pop(); // Close the dialog
                } catch (e) {
                  // Handle errors here, e.g., show a snackbar or alert
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Došlo je do greške pri brisanju')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _handleComplete(Job job) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JobFinishPage(jobId: job.id!),
      ),
    );
  }

  void _showActionDialog(BuildContext context, Job job) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Actions for ${job.name}'),
          actions: <Widget>[
            TextButton(
              child: const Text('Details'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JobDetails(jobId: job.id!),
                  ),
                );
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Complete'),
              onPressed: () {
                // Handle complete action
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                // Handle delete action
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
