
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:minijobs_mobile/models/job/job.dart';
import 'package:minijobs_mobile/providers/job_provider.dart';
import 'package:provider/provider.dart';

class JobPreview extends StatelessWidget {
  const JobPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final jobProvider = Provider.of<JobProvider>(context);
    final Job job = jobProvider.getCurrentJob()!;
    final userName= '${GetStorage().read('givenname')} ${GetStorage().read('surname')}';
    final DateTime currentDate = DateTime.now();
final DateTime applicationsEndDate = currentDate.add(Duration(days: job.applicationsDuration!));
final String formattedDate = DateFormat('dd.MM.yyyy.').format(applicationsEndDate);
// return Padding(
//   padding: const EdgeInsets.all(16.0), // Adjust the padding value as needed
//   child: Container(
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(10),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black12,
//           blurRadius: 10,
//           offset: Offset(0, 5),
//         ),
//       ],
//     ),
//     padding: EdgeInsets.all(16),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           job.name!,
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 18,
//             color: Colors.black87,
//           ),
//         ),
//         SizedBox(height: 12),
//         Text(
//           '${userName!} - ${job.city!.name}',
//           style: TextStyle(fontSize: 14, color: Colors.black54),
//         ),
//         Divider(color: Colors.grey, height: 20),
//         Text(
//           'Opis posla:',
//           style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500,  color: Colors.black87),
//         ),
//         SizedBox(height: 8),
//         Text(
//           job.description!,
//           style: TextStyle(fontSize: 14,  color: Colors.black87),
//         ),
//         SizedBox(height: 12),
//         Row(
//           children: [
//             Text(
//               'Tip posla:',
//               style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500,  color: Colors.black87),
//             ),
//             SizedBox(width: 4),
//             Text(
//               job.jobType!.name!,
//               style: TextStyle(fontSize: 14, color: Colors.black87),
//             ),
//           ],
//         ),
//         SizedBox(height: 10),
//         Row(children: [
//            Text(
//               'Potrebno radnika:',
//               style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500,  color: Colors.black87),
//             ),
//             SizedBox(width: 4),
//             Text(
//               job.requiredEmployees!.toString(),
//               style: TextStyle(fontSize: 14, color: Colors.black87),
//             ),
//         ],),
//         SizedBox(height: 10),
//         Row(
//           children: [
//             Text(
//               'Plaćanje:',
//               style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500,  color: Colors.black87),
//             ),
//             SizedBox(width: 4),
//             Text(job.paymentQuestion!.answer!,style: TextStyle(fontSize: 14, color: Colors.black87)),
//              if(job.wage!=null && job.wage!>0)
//             Text(
//               '10 KM',
//               style: TextStyle(fontSize: 14, color: Colors.black87),
//             ),
//           ],
//         ),
//         SizedBox(height: 12),
//         Text(
//           'Raspored posla:',
//           style: TextStyle(
//             fontSize: 15,
//             fontWeight: FontWeight.w500,
//             color: Colors.black87,
//           ),
//         ),
//         SizedBox(height: 8),
//         Wrap(
//           spacing: 8.0,
//           runSpacing: 4.0,
//           children: job.schedules!.map((schedule) {
//             return Text(
//               schedule.answer!,
//               style: TextStyle(fontSize: 14, color: Colors.black87),
//             );
//           }).toList(),
//         ),
//          if (job.additionalPaymentOptions != null && job.additionalPaymentOptions!.isNotEmpty) ...[
//         SizedBox(height: 12),
//         Text(
//           'Dodatno plaća:',
//           style: TextStyle(
//             fontSize: 15,
//             fontWeight: FontWeight.w500,
//             color: Colors.black87,
//           ),
//         ),
//         SizedBox(height: 8),
//         Wrap(
//           spacing: 8.0,
//           runSpacing: 4.0,
//           children:job.additionalPaymentOptions!.map((option) {
//             return Text(
//               option.answer!,
//               style: TextStyle(fontSize: 14, color: Colors.black87),
//             );
//           }).toList(),
//         ),
//         SizedBox(height: 12),
//          Container(
//               padding: EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.blue[50],
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: Colors.blue),
//               ),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Alikacije traju do:',
//                     style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.blue[800],
//                     ),
//                   ),
//                   SizedBox(width: 4),
//                   Text((
//                     formatedDate),
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.blue[800],
//                     ),
//                   ),
//                 ],
//               ) 
//               )
//       ],
//       ]
//     ),
//   ),
// );

return  SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                job.name!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.deepPurple[800],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '$userName - ${job.city!.name}',
                style: TextStyle(fontSize: 16, color: Colors.deepPurple[300]),
              ),
              Divider(color: Colors.grey[400], height: 20),
              Text(
                'Opis posla:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.deepPurple[700]),
              ),
              const SizedBox(height: 8),
              Text(
                job.description!,
                style: TextStyle(fontSize: 15, color: Colors.grey[700]),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    'Tip posla:',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.deepPurple[700]),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    job.jobType!.name!,
                    style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Potrebno radnika:',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.deepPurple[700]),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    job.requiredEmployees!.toString(),
                    style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Plaćanje:',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.deepPurple[700]),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    job.paymentQuestion!.answer!,
                    style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                  ),
                  if (job.wage != null && job.wage! > 0)
                    Text(
                      '${job.wage!} KM',
                      style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Raspored posla:',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.deepPurple[700],
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: job.schedules!.map((schedule) {
                  return Text(
                    schedule.answer!,
                    style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                  );
                }).toList(),
              ),
              if (job.additionalPaymentOptions != null && job.additionalPaymentOptions!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  'Dodatno plaća:',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.deepPurple[700],
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: job.additionalPaymentOptions!.map((option) {
                    return Text(
                      option.answer!,
                      style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Aplikacije traju do:',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue[800],
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue[800],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
    );
  }
}
