import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minijobs_mobile/enumerations/job_statuses.dart';
import 'package:minijobs_mobile/enumerations/role.dart';
import 'package:minijobs_mobile/models/job/job.dart';
import 'package:minijobs_mobile/providers/job_provider.dart';
import 'package:provider/provider.dart';

class JobModal extends StatefulWidget {
  final Job job;
  final String role;

  const JobModal({super.key, required this.job, required this.role});

  @override
  State<JobModal> createState() => _JobModalState();
}

class _JobModalState extends State<JobModal> {
  late JobProvider jobProvider;
  Job job = Job();
  String role = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    jobProvider = context.read<JobProvider>();
    job = widget.job;
    role = widget.role;
    setState(() {});
  }

  bool get canUserApply {
    return !(job.status != JobStatus.Zavrsen ||
        job.isApplied! ||
        role == Role.Employer ||
        job.created!
            .add(Duration(days: job.applicationsDuration!))
            .isBefore(DateTime.now()));
  }

  bool get canUserSaveJob {
    return !(job.status != JobStatus.Zavrsen ||
        role == Role.Employer ||
        job.created!
            .add(Duration(days: job.applicationsDuration!))
            .isBefore(DateTime.now()));
  }

  Future<void> saveJob(bool save) async {
    await jobProvider.save(job.id!, save);
  }

  Future<void> applyToJob(bool apply) async {
    await jobProvider.apply(job.id!, apply);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (canUserSaveJob)
                    IconButton(
                      onPressed: () async {
                        await saveJob(true);
                      },
                      icon: const Icon(Icons.bookmark_outline),
                    ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                job.name!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "${job.employerFullName} - ${job.city!.name}, ${job.streetAddressAndNumber}",
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
                ),
              ),
              const SizedBox(height: 10),
              Text(
                job.description!,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 10),
              Text(
                'Tip posla: ${job.jobType!.name}',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.money),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "${job.wage != null && job.wage! > 0 ? job.wage : ''} ${job.paymentQuestion!.answer}",
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
                ),
              ),
              const SizedBox(height: 10),
              Text(
                job.schedules?.map((option) => option.answer).join(', ') ?? '',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (job.additionalPaymentOptions != null &&
                      job.additionalPaymentOptions!.isNotEmpty)...[
                    const Text(
                      'Dodatno plaća:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      job.additionalPaymentOptions!
                          .map((option) => option.answer)
                          .join(', '),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.supervisor_account),
                  const SizedBox(width: 10),
                  Text("${job.requiredEmployees} radnik/a"),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.date_range),
                  const SizedBox(width: 10),
                  Text(DateFormat('dd.MM.yyyy.').format(
                      job.created!.add(Duration(days: job.applicationsDuration!)))),
                ],
              ),
              if (job.status == JobStatus.Zavrsen)
                const Text(
                  'Posao je završen',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(height: 20),
              if (canUserApply)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await applyToJob(true);
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text('Apliciraj'),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
