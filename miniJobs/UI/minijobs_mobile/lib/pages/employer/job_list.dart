import 'package:flutter/material.dart';
import 'package:minijobs_mobile/models/job/job.dart';
import 'package:minijobs_mobile/pages/employer/job/job_applicans_view.dart';
import 'package:minijobs_mobile/pages/employer/job/job_details.dart';
import 'package:minijobs_mobile/providers/job_provider.dart';
import 'package:intl/intl.dart';
import 'package:minijobs_mobile/widgets/badges.dart';

class JobList extends StatefulWidget {
  const JobList({super.key});

  @override
  _JobListState createState() => _JobListState();
}

class _JobListState extends State<JobList> {
  late JobProvider _jobProvider;
  List<Job> jobs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _jobProvider = JobProvider();
    getJobs();
  }

  Future<void> getJobs() async {
    setState(() {
      isLoading = true;
    });
    jobs = await _jobProvider.getAll();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job List'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
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
                        if( job.created != null)
                        Text(
                         'Kreirano: ${DateFormat('dd.MM.yyyy.').format(job.created!)}',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        if (job.applicationsDuration != null)
                          Text(
                            'Prijave traju do: ${DateFormat('dd.MM.yyyy.').format(DateTime.now().add(Duration(days: job.applicationsDuration!)))}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                             if( job.numberOfApplications != null && job.numberOfApplications! >0)
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
      const PopupMenuItem<String>(
        value: 'details',
        child: ListTile(
          leading: Icon(Icons.reorder),
          title: Text('Details'),
        ),
      ),
      const PopupMenuItem<String>(
        value: 'complete',
        child: ListTile(
          leading: Icon(Icons.check, color: Colors.green),
          title: Text('Complete'),
        ),
      ),
      const PopupMenuItem<String>(
        value: 'delete',
        child: ListTile(
          leading: Icon(Icons.delete, color: Colors.red),
          title: Text('Delete'),
        ),
      ),
    ];

    if (job.numberOfApplications != null && job.numberOfApplications! > 0) {
      menuItems.insert(
        0,
        const PopupMenuItem<String>(
          value: 'applicants',
          child: ListTile(
            leading: Icon(Icons.people, color: Colors.blue),
            title: Text('Applicants'),
          ),
        ),
      );
    }

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
      // Handle the applicants action
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
              // Handle the deletion logic here
              try {
             //   await _jobProvider.delete(job.id!); // Assuming you have a delete method
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
    // Handle complete action here
    // e.g., update job status to completed
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
