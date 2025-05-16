
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:minijobs_mobile/enumerations/job_statuses.dart';
import 'package:minijobs_mobile/enumerations/role.dart';
import 'package:minijobs_mobile/models/job/job.dart';
import 'package:minijobs_mobile/models/job/job_application.dart';
import 'package:minijobs_mobile/providers/applicant_provider.dart';
import 'package:minijobs_mobile/providers/job_provider.dart';
import 'package:provider/provider.dart';

import '../../../providers/job_application_provider.dart';
import '../employer_profile_page.dart';

class JobModal extends StatefulWidget {
  final int jobId;
  final String role;
  final bool isInSavedJobs;
  final bool isInAppliedJobs;
  const JobModal({super.key, required this.jobId, required this.role,this.isInSavedJobs = false,this.isInAppliedJobs = false});

  @override
  State<JobModal> createState() => _JobModalState();
}

class _JobModalState extends State<JobModal> {
  late JobProvider jobProvider;
  late ApplicantProvider applicantProvider;
  late JobApplicationProvider jobApplicationProvider;
  late Future<Job?> jobFuture; // Future to hold job fetch
  late Future<JobApplication?> jobApplicationFuture; // Future to hold job fetch
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    jobProvider = context.read<JobProvider>();
    applicantProvider = context.read<ApplicantProvider>();
    jobApplicationProvider = context.read<JobApplicationProvider>();

    jobFuture = getJob(widget.jobId);
  }

  Future<Job> getJob(int jobId) async {
    return await jobProvider.get(jobId);
  }

  bool canUserApply(Job job) {
    return job.status != JobStatus.Zavrsen &&
        !job.isApplied &&
        widget.role != 'Employer' &&
        job.created!
            .add(Duration(days: job.applicationsDuration!))
            .isAfter(DateTime.now());
  }

  bool canUserSaveJob(Job job) {
    return job.status != JobStatus.Zavrsen &&
        widget.role !='Employer' &&
        !(job.isSaved ?? false);
  }
  bool canUserDeleteApplication(Job job) {
    return job.status != JobStatus.Zavrsen &&
        job.isApplied &&
        widget.role != Role.Employer &&
        job.created!
            .add(Duration(days: job.applicationsDuration!))
            .isAfter(DateTime.now());
  }
  Future<void> saveJob(int jobId) async {
    setState(() {
      jobFuture = applicantProvider.saveJob(jobId);
    });

    jobFuture.then((job) {
      if (job != null) {
        if (widget.isInSavedJobs) {
          applicantProvider.getSavedJobs();
        }
      }
    });
  }

  Future<void> unsaveJob(int jobId) async {
    setState(() {
      jobFuture = applicantProvider.unsaveJob(jobId);
    });

    jobFuture.then((job) {
      if (job != null) {
        if (widget.isInSavedJobs) {
          applicantProvider.getSavedJobs();
        }
      }
    });
  }
  Future<void> applyToJob(int jobId) async {
    setState(() {
      jobApplicationFuture = jobApplicationProvider.apply(jobId);
    });

    jobApplicationFuture.then((jobApplication) {
      if (jobApplication != null) {
        if (widget.isInAppliedJobs) {
          applicantProvider.getAppliedJobs();
        }
        setState(() {
          jobFuture = jobFuture.then((job) {
            if (job != null) {
              // Update the job's isApplied field
              job.isApplied = true;
            }
            return job;
          });
        });

      }
    });
  }

  Future<void> deleteJobApplication(int jobId) async {
    setState(() {
      jobApplicationFuture = jobApplicationProvider.delete(jobId);
    });

    jobApplicationFuture.then((jobApplication) {
      if (jobApplication != null) {
        if (widget.isInAppliedJobs) {
          applicantProvider.getAppliedJobs();
        }
        setState(() {
          jobFuture = jobFuture.then((job) {
            if (job != null) {
              // Update the job's isApplied field
              job.isApplied = false;
            }
            return job;
          });
        });
      }
    });
  }




  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Job?>(
      future: jobFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show loading indicator while waiting for data
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Show error message if the fetch fails
          return const Center(child: Text('Failed to load job details'));
        } else if (!snapshot.hasData) {
          // Show empty state if no job data is available
          return const Center(child: Text('No job data available'));
        }

        // Job data successfully fetched
        final job = snapshot.data!;

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
                      if (canUserSaveJob(job))
                        IconButton(
                          onPressed: () async {
                            await saveJob(job.id!);
                          },
                          icon: const Icon(Icons.bookmark_outline),
                        ),
                      if (job.isSaved ?? false)
                        IconButton(
                          onPressed: () async {
                            await unsaveJob(job.id!);
                          },
                          icon: const Icon(Icons.bookmark),
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
                          "${job.employerFullName} - ${job.city!.name}, ${job.streetAddressAndNumber} }",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      if (GetStorage().read('role') == 'Applicant') // Show info icon only for applicants
                        IconButton(
                          icon: const Icon(Icons.info_outline),
                          onPressed: () {
                            // Navigate to EmployerDetailsPage with employerId (assuming job has employerId)
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => EmployerProfilePage(
                                  userId: job.createdBy!, // Replace with actual employer ID field from your Job model
                                ),
                              ),
                            );
                          },
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
                    job.schedules?.map((option) => option.answer).join(', ') ??
                        '',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  if (job.additionalPaymentOptions != null &&
                      job.additionalPaymentOptions!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                      Text(DateFormat('dd.MM.yyyy.').format(job.created!
                          .add(Duration(days: job.applicationsDuration!)))),
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
                  if (canUserApply(job))
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            await applyToJob(job.id!);
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text('Apliciraj'),
                          ),
                        ),
                      ],
                    ),
                  if (canUserDeleteApplication(job))
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            await deleteJobApplication(job.id!);
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text('Poništi aplikaciju',
                              style: TextStyle(
                                color: Colors.red, // Set text color to red
                              ),),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
