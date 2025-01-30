import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../enumerations/job_statuses.dart';
import '../../models/job/job.dart';
import '../../providers/job_provider.dart';
import 'job_applications_view.dart';

class JobDetailsPage extends StatefulWidget {
  final Job job;

  const JobDetailsPage({Key? key, required this.job}) : super(key: key);

  @override
  _JobDetailsPageState createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage> {
  late JobProvider jobProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    jobProvider = context.read<JobProvider>();
  }

  Future<void> deleteJob(int jobId) async {
    await jobProvider.deleteByAdmin(jobId);
    setState(() {
      widget.job.deletedByAdmin = true;
    });
  }

  Future<void> activateJob(int jobId) async {
    await jobProvider.activateByAdmin(jobId);
    setState(() {
      widget.job.deletedByAdmin = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalji posla')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              widget.job.name ?? 'Nema naziva', // Providing fallback for null job name
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.redAccent),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "${widget.job.employerFullName ?? 'Nepoznato'} - ${widget.job.city?.name ?? 'Nepoznato'}, ${widget.job.streetAddressAndNumber ?? 'Nepoznato'}",
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Opis posla:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.job.description ?? 'Nema opisa', // Providing fallback for null description
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 10),
            Text(
              'Tip posla: ${widget.job.jobType?.name ?? 'Nepoznato'}', // Null check for job type
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.money, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "${widget.job.wage != null && widget.job.wage! > 0 ? widget.job.wage : ''} ${widget.job.paymentQuestion?.answer ?? 'Nepoznato'}", // Null check for paymentQuestion
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Raspored posla:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.job.schedules?.map((option) => option.answer).join(', ') ?? 'Nema rasporeda', // Null check for schedules
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 10),
            if (widget.job.additionalPaymentOptions != null &&
                widget.job.additionalPaymentOptions!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dodatno plaća:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.job.additionalPaymentOptions!
                        .map((option) => option.answer)
                        .join(', '),
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.supervisor_account),
                const SizedBox(width: 8),
                Text("${widget.job.requiredEmployees ?? 'Nepoznato'} radnik/a"), // Null check for requiredEmployees
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.date_range),
                const SizedBox(width: 8),
                Text(
                  widget.job.created != null
                      ? DateFormat('dd.MM.yyyy.').format(
                    widget.job.created!.add(Duration(days: widget.job.applicationsDuration ?? 0)), // Null check for applicationsDuration
                  )
                      : 'Nepoznato datum', // Fallback if created date is null
                ),
              ],
            ),
            const SizedBox(height: 20),
            JobActions(job: widget.job, deleteJob: deleteJob, activateJob: activateJob),
          ],
        ),
      ),
    );
  }
}

class JobActions extends StatelessWidget {
  final Job job;
  final Future<void> Function(int) deleteJob;
  final Future<void> Function(int) activateJob;

  const JobActions({Key? key, required this.job, required this.deleteJob, required this.activateJob}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (job.deletedByAdmin)
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh, color: Colors.green),
            label: const Text('Aktiviraj'),
            onPressed: () => _showActivateConfirmation(context, job),
          )
        else
          ElevatedButton.icon(
            icon: const Icon(Icons.block, color: Colors.red),
            label: const Text('Obriši'),
            onPressed: () => _showDeleteConfirmation(context, job),
          ),
        const SizedBox(width: 10),
        if (job.status == JobStatus.Aktivan ||
            job.status == JobStatus.AplikacijeZavrsene ||
            job.status == JobStatus.Zavrsen)
          ElevatedButton.icon(
            icon: const Icon(Icons.group, color: Colors.purple),
            label: const Text('Aplikanti'),
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
    );
  }

  void _showDeleteConfirmation(BuildContext context, Job job) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Obriši'),
        content: const Text('Da li ste sigurni da želite obrisati ovaj posao?'),
        actions: [
          TextButton(
            child: const Text('Odustani'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Obriši'),
            onPressed: () {
              deleteJob(job.id!);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _showActivateConfirmation(BuildContext context, Job job) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Aktiviraj'),
        content: const Text('Da li ste sigurni da želite aktivirati ovaj posao?'),
        actions: [
          TextButton(
            child: const Text('Odustani'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Aktiviraj'),
            onPressed: () {
              activateJob(job.id!);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
