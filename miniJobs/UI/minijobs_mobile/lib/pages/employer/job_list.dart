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


class JobList extends StatefulWidget {
  const JobList({super.key});

  @override
  _JobListState createState() => _JobListState();
}

class _JobListState extends State<JobList> {
  late EmployerProvider employerProvider;
  late JobProvider jobProvider;
  late Future<List<Job>> jobsFuture;
  List<Job> jobs = [];
  int userId = int.parse(GetStorage().read('userId'));

  @override
  void initState() {
    super.initState();
    employerProvider = EmployerProvider();
    jobProvider = JobProvider();
    jobsFuture = getJobs(); // Initialize the jobs fetch
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Re-fetch jobs when the widget is rebuilt after navigation
    jobsFuture = getJobs();
  }

  Future<List<Job>> getJobs() async {
    return await employerProvider.getJobs(userId); // Fetch jobs from the provider
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vaši poslovi'),
      ),
      body: FutureBuilder<List<Job>>(
        future: jobsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Došlo je do greške pri učitavanju podataka.'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nema poslova za prikaz.'));
          } else {
            final jobs = snapshot.data!;
            return ListView.builder(
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                final job = jobs[index];
                return Card(
                  margin:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                        if (job.numberOfApplications != null &&
                            job.numberOfApplications! > 0)
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
                      ).then((_) {
                        // Re-fetch jobs when returning from JobDetails
                        setState(() {
                          jobsFuture = getJobs();
                        });
                      });
                    },
                    onLongPress: () {
                      _showActionDialog(context, job);
                    },
                    leading: PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, size: 24),
                      itemBuilder: (BuildContext context) {
                        List<PopupMenuEntry<String>> menuItems = [
                          if (job.numberOfApplications != null &&
                              job.numberOfApplications! > 0)
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
                          if (job.status !=
                              JobStatus
                                  .Zavrsen) // Hide delete if job is finished
                            const PopupMenuItem<String>(
                              value: 'delete',
                              child: ListTile(
                                leading: Icon(Icons.delete, color: Colors.red),
                                title: Text('Obriši'),
                              ),
                            ),
                          if (job.status == JobStatus.AplikacijeZavrsene)
                            const PopupMenuItem<String>(
                              value: 'finish',
                              child: ListTile(
                                leading: Icon(Icons.check_circle, color: Colors.green),
                                title: Text('Završi posao'),
                              ),
                            ),
                          if (job.status == JobStatus.Aktivan && job.numberOfApplications! > 0)
                            const PopupMenuItem<String>(
                              value: 'complete_applications',
                              child: ListTile(
                                leading: Icon(Icons.done_all, color: Colors.blue),
                                title: Text('Završi aplikacije'),
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
                          ).then((_) {
                            // Re-fetch jobs after returning from details
                            setState(() {
                              jobsFuture = getJobs();
                            });
                          });
                        } else if (value == 'delete') {
                          _handleDelete(job);
                        }else if (value == 'applicants') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => JobApplicantsView(
                                  jobId: job.id!,
                                  jobStatus: job.status!
                              ),
                            ),
                          );
                        }
                        else if (value == 'finish') {
                          finishJob(job);
                        }
                        else if (value == 'complete_applications') {
                          completeApplicationsJob(job); // Call completeApplicationsJob for "Završi aplikacije"
                        }
                      },
                    ),
                  ),
                );
              },
            );
          }
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
                  await jobProvider
                      .delete(job.id!); // Ensure deletion is completed
                  setState(() {
                    jobsFuture = Future.value(
                      (jobsFuture).then((jobsList) {
                        return jobsList.where((j) => j.id != job.id).toList();
                      }),
                    );
                  });
                  Navigator.of(context).pop(); // Close the dialog

              },
            ),
          ],
        );
      },
    );
  }
  Future<void> finishJob(Job job) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Završi posao'),
          content: const Text(
            'Jeste li sigurni da želite završiti posao? Provjerite jeste li odabrali sve aplikante koji su sudjelovali.',
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
      var response = await jobProvider.finish(job.id!);

      if (response != null && response.id != null) {
        setState(() {
          jobsFuture = getJobs(); // Refresh the job list
        });
      }
    }
  }
  Future<void> completeApplicationsJob(Job job) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Završi aplikacije'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Jeste li sigurni da želite završiti aplikacije?"),
              const SizedBox(height: 8),
              const Text("- Nakon ovoga niko neće moći da aplicira.", style: TextStyle(fontSize: 14)),
              const Text("- Ova opcija je za slučaj da ste se dogovorili sa radnikom.", style: TextStyle(fontSize: 14)),
              const SizedBox(height: 8),
              Text("Ako niste sigurni, možete sačekati ili se vratiti kasnije.", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ],
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
      var response = await jobProvider.completeApplications(job.id!);

      if (response != null && response.id != null) {
        setState(() {
          job.status = JobStatus.AplikacijeZavrsene;
          jobsFuture = getJobs(); // Refresh the job list
        });
      }
    }
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
