import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:minijobs_mobile/models/job/job_card_dto.dart';
import 'package:minijobs_mobile/pages/employer/job/job_modal.dart';
import 'package:minijobs_mobile/providers/job_provider.dart';
import 'package:provider/provider.dart';

import '../../../services/notification.service.dart';

class JobCard extends StatefulWidget {
  final JobCardDTO job;
  final bool isInSavedJobs;
  final bool isRecommended;
  const JobCard({
    super.key,
    required this.job,
    this.isInSavedJobs = false,
    this.isRecommended = false,
  });

  @override
  State<JobCard> createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> {
  final notificationService = NotificationService();
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
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 310, // 👈 Fixed height
      child: Card(
        margin: const EdgeInsets.all(10.0),
        color: widget.isRecommended ? Colors.blue[50] : Colors.white,
        elevation: widget.isRecommended ? 4.0 : 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: widget.isRecommended
              ? const BorderSide(color: Colors.blueAccent, width: 1.0)
              : BorderSide.none,
        ),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.isRecommended)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    margin: const EdgeInsets.only(bottom: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: const Text(
                      'Preporučeno',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                Text(
                  job.name ?? 'Unnamed Job',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
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
                      job.cityName ?? 'Unknown City',
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
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return JobModal(
                          jobId: job.id,
                          role: GetStorage().read('role'),
                          isInSavedJobs: widget.isInSavedJobs,
                        );
                      },
                    );
                  },
                  child: const Text('Pogledaj', style: TextStyle(fontSize: 14)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}