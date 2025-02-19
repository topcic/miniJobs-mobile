import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:minijobs_admin/models/job/job.dart';
import 'package:minijobs_admin/pages/employer/job/job_modal.dart';
import 'package:minijobs_admin/providers/job_provider.dart';
import 'package:provider/provider.dart';

import '../../../models/job/job_card_dto.dart';
import '../../jobs/job_details.dart';

class JobCard extends StatefulWidget {
  final JobCardDTO job;
  final bool isInSavedJobs;
  const JobCard({super.key, required this.job, this.isInSavedJobs = false});

  @override
  State<JobCard> createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> {
  late JobProvider jobProvider;
  late JobCardDTO job;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    jobProvider = context.read<JobProvider>();
    job = widget.job;
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
                fontSize: 18, // Normal font size
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
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
                  job.cityName!,
                  style: const TextStyle(
                    fontSize: 14, // Normal font size
                    color: Colors.grey,
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
                  style: const TextStyle(
                    fontSize: 14, // Normal font size
                    color: Colors.green,
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
                      return JobDetailsPage(
                        jobId: job.id);
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
