import 'package:flutter/material.dart';
import 'package:minijobs_mobile/models/job/job.dart';
import 'package:minijobs_mobile/pages/employeer/job/job_details.dart';
import 'package:minijobs_mobile/providers/job_provider.dart';
import 'package:intl/intl.dart';
import 'package:minijobs_mobile/widgets/badges.dart';

class JobList extends StatefulWidget {
  @override
  _JobListState createState() => _JobListState();
}

class _JobListState extends State<JobList> {
  late JobProvider _jobProvider;
  List<Job> jobs = [];

  @override
  void initState() {
    super.initState();
    _jobProvider = JobProvider();
    getJobs();
  }

  Future<void> getJobs() async {
    jobs = await _jobProvider.getAll();
    print('Fetched jobs: $jobs');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job List'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              DataColumn(label: Center(child: Text('Opcije'))),
              DataColumn(label: Center(child: Text('Naziv'))),
              DataColumn(label: Center(child: Text('Kreiran'))),
              DataColumn(label: Center(child: Text('Aplikacije traju do'))),
              DataColumn(label: Center(child: Text('Broj aplikacija'))),
              DataColumn(label: Center(child: Text('Status'))),
            ],
            rows: jobs.map((job) => DataRow(cells: [
              DataCell(
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, size: 18),
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'details',
                      child: Row(children: [
                        Icon(Icons.reorder, size: 18),
                        SizedBox(width: 8),
                        Text('Detalji')
                      ]),
                    ),
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(children: [
                        Icon(
                          Icons.close,
                          color: Colors.redAccent[700],
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Text('Obriši')
                      ]),
                    ),
                    PopupMenuItem<String>(
                      value: 'complete',
                      child: Row(children: [
                        Icon(Icons.check, color: Colors.greenAccent[700], size: 18),
                        SizedBox(width: 8),
                        Text('Završi')
                      ]),
                    ),
                  ],
                  onSelected: (String value) {
                    // Handle option selection here
                      // Handle option selection here
    if (value == 'details') {
      Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => JobDetails(jobId:job.id!)),
  );
    } else if (value == 'delete') {
      // Handle delete option
    } else if (value == 'complete') {
      // Handle complete option
    }
                  },
                ),
              ),
              DataCell(Center(child: Text(job.name ?? ''))),
              DataCell(Center(
                  child: Text(job.created != null
                      ? DateFormat('dd.MM.yyyy.').format(job.created!)
                      : ''))),
              DataCell(Center(
                  child: Text(job.applicationsEndTo != null
                      ? DateFormat('dd.MM.yyyy.').format(job.applicationsEndTo!)
                      : ''))),
              DataCell(Center(child: Text(job.numberOfApplications!.toString()))),
              DataCell(Center(child: JobBadge(status: job.status!))), // Using JobBadge with status
            ])).toList(),
          ),
        ),
      ),
    );
  }
}
