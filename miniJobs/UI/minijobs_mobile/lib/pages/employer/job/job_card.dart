import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:minijobs_mobile/models/job/job.dart';
import 'package:minijobs_mobile/pages/employer/job/job_modal.dart';
import 'package:minijobs_mobile/providers/job_provider.dart';
import 'package:provider/provider.dart';

class JobCard extends StatefulWidget {
  final Job job;
  const JobCard({super.key, required this.job});

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
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
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
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              children: [
                const Icon(Icons.money_sharp, size: 16),
                Text(
                  job.wage != null && job.wage! > 0
                      ? '${job.wage}'
                      : 'po dogovoru',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                if (job.id != null) {
                  await getJob(job.id!);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return JobModal(
                        job: job,
                        role: GetStorage().read('role'),
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
