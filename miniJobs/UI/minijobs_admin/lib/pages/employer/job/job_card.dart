import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:minijobs_admin/models/job/job.dart';
import 'package:minijobs_admin/pages/employer/job/job_modal.dart';
import 'package:minijobs_admin/providers/job_provider.dart';
import 'package:provider/provider.dart';

class JobCard extends StatefulWidget {
  final Job job;
  final bool isInSavedJobs;
  const JobCard({super.key, required this.job,this.isInSavedJobs = false});

  @override
  State<JobCard> createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> {
  late JobProvider jobProvider;
  late Job job;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    jobProvider = context.read<JobProvider>();
    job = widget.job;
  }

  Future<void> getJob(int id) async {
    job = await jobProvider.get(id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Card(
      margin: const EdgeInsets.all(10.0),
      color: Colors.blue[50],
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              job.name!,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[900],
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              children: [
                const Icon(Icons.location_on, size: 16),
                Text(
                  job.city!.name!,
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              children: [
                const Icon(Icons.money_sharp, size: 16, color: Colors.green),
                Text(
                  job.wage != null && job.wage! > 0
                      ? '${job.wage} KM'
                      : 'po dogovoru',
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                    color: Colors.green[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                if (job.id != null) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return JobModal(
                        jobId: job.id!,
                        role: GetStorage().read('role'),
                          isInSavedJobs: widget.isInSavedJobs
                      );
                    },
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Detalji posla nisu dostupni')),
                  );
                }
              },
              child: const Text('Pogledaj', style: TextStyle(fontSize: 14)),
            ),
          ],
        ),
      ),
    );
  }
}
