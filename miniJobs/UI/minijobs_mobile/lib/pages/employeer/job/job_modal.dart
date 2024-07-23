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
  Job job=new Job();
  String role='';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    jobProvider= context.read<JobProvider>();
    job=widget.job!;
    role=widget.role!;
    setState(() {
      
    });
  }
bool get canUserApply {
    return !(job.status != JobStatus.Zavrsen ||
        job.isApplied! ||
        role == Role.Employer ||
        job.created!.add(Duration(days: job.applicationsDuration!)).isBefore(
            DateTime.now())); // Default case if none of the conditions match
  }

  bool get canUserSaveJob {
    return !(job.status != JobStatus.Zavrsen ||
        role == Role.Employer ||
        job.created!.add(Duration(days: job.applicationsDuration!)).isBefore(
            DateTime.now())); // Default case if none of the conditions match
  }
 saveJob(bool save) async{
await jobProvider.save(job.id!, save);
 }
 applyToJob(bool apply) async{
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
                      onPressed: () async{
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
              Row(
                children: [
                  const Icon(Icons.location_on),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Text(
                      "${job.employerFullName} - ${job.city!.name}, ${job.streetAddressAndNumber}"),
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
              ),
              const SizedBox(height: 10),
              Text(
                'Tip posla: ${job.jobType!.name}',
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.money),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    "${job.wage != null && job.wage! > 0 ? job.wage : ''} ${job.paymentQuestion!.answer}",
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
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (job.additionalPaymentOptions != null &&
                      job.additionalPaymentOptions!.isNotEmpty)
                    Row(
                      children: [
                        const Text(
                          'Dodatno plaća:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                            width: 5), // Add spacing between the text widgets
                        Text(
                          job.additionalPaymentOptions!
                              .map((option) => option.answer)
                              .join(', '),
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.supervisor_account),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Text("${job.requiredEmployees} radnik/a"),
                ],
              ),
              const SizedBox(height: 10),
              if (true) // Modify this condition as needed
                Row(
                  children: [
                    const Icon(Icons.date_range),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Text(DateFormat('dd.MM.yyyy.').format(job.created!
                        .add(Duration(days: job.applicationsDuration!)))),
                  ],
                ),
              if (job.status ==
                  JobStatus.Zavrsen) // Modify this condition as needed
                const Text(
                  'Posao je završen',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(height: 20),
              if (canUserApply) // Modify this condition as needed
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async{
                         await applyToJob(true);
                        // Logic for when the button is pressed
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                20), // Add horizontal padding to the button
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

// class JobModal1 extends StatelessWidget {
//   final Job job;
//   final String role;

//   const JobModal1({super.key, required this.job, required this.role});

//   // Computed property to determine if the user can apply
//   bool get canUserApply {
//     return !(job.status != JobStatus.Zavrsen ||
//         job.isApplied! ||
//         role == Role.Employer ||
//         job.created!.add(Duration(days: job.applicationsDuration!)).isBefore(
//             DateTime.now())); // Default case if none of the conditions match
//   }

//   bool get canUserSaveJob {
//     return !(job.status != JobStatus.Zavrsen ||
//         role == Role.Employer ||
//         job.created!.add(Duration(days: job.applicationsDuration!)).isBefore(
//             DateTime.now())); // Default case if none of the conditions match
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   if (canUserSaveJob)
//                     IconButton(
//                       onPressed: () async{
//                          await jobProvider.save(job.id!, true);
//                       },
//                       icon: const Icon(Icons.bookmark_outline),
//                     ),
//                   IconButton(
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                     icon: const Icon(Icons.close),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 job.name!,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                 ),
//               ),
//               Row(
//                 children: [
//                   const Icon(Icons.location_on),
//                   const SizedBox(
//                     width: 10.0,
//                   ),
//                   Text(
//                       "${job.employerFullName} - ${job.city!.name}, ${job.streetAddressAndNumber}"),
//                 ],
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 'Opis posla:',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 job.description!,
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 'Tip posla: ${job.jobType!.name}',
//               ),
//               const SizedBox(height: 10),
//               Row(
//                 children: [
//                   const Icon(Icons.money),
//                   const SizedBox(
//                     width: 10.0,
//                   ),
//                   Text(
//                     "${job.wage != null && job.wage! > 0 ? job.wage : ''} ${job.paymentQuestion!.answer}",
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 'Raspored posla:',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 job.schedules?.map((option) => option.answer).join(', ') ?? '',
//               ),
//               const SizedBox(height: 10),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   if (job.additionalPaymentOptions != null &&
//                       job.additionalPaymentOptions!.isNotEmpty)
//                     Row(
//                       children: [
//                         const Text(
//                           'Dodatno plaća:',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(
//                             width: 5), // Add spacing between the text widgets
//                         Text(
//                           job.additionalPaymentOptions!
//                               .map((option) => option.answer)
//                               .join(', '),
//                         ),
//                       ],
//                     ),
//                 ],
//               ),
//               const SizedBox(height: 10),
//               Row(
//                 children: [
//                   const Icon(Icons.supervisor_account),
//                   const SizedBox(
//                     width: 10.0,
//                   ),
//                   Text("${job.requiredEmployees} radnik/a"),
//                 ],
//               ),
//               const SizedBox(height: 10),
//               if (true) // Modify this condition as needed
//                 Row(
//                   children: [
//                     const Icon(Icons.date_range),
//                     const SizedBox(
//                       width: 10.0,
//                     ),
//                     Text(DateFormat('dd.MM.yyyy.').format(job.created!
//                         .add(Duration(days: job.applicationsDuration!)))),
//                   ],
//                 ),
//               if (job.status ==
//                   JobStatus.Zavrsen) // Modify this condition as needed
//                 const Text(
//                   'Posao je završen',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               const SizedBox(height: 20),
//               if (canUserApply) // Modify this condition as needed
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     ElevatedButton(
//                       onPressed: () {
//                         // Logic for when the button is pressed
//                       },
//                       child: const Padding(
//                         padding: EdgeInsets.symmetric(
//                             horizontal:
//                                 20), // Add horizontal padding to the button
//                         child: Text('Apliciraj'),
//                       ),
//                     ),
//                   ],
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
