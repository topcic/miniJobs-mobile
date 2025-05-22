import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:flutter_quill/flutter_quill.dart' as quill;


import '../../models/job/job.dart';
import '../../widgets/badges.dart';
import '../employers/employer_details_page.dart';
import '../main/constants.dart';
import 'job_details.dart';

class JobDetailsContent extends StatelessWidget {
  final Job job;

  const JobDetailsContent({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(defaultPadding),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            job.name ?? 'Nema naziva',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: defaultPadding),
          RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EmployerDetailsPage(id: job.createdBy!),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            job.employerFullName!,
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Tooltip(
                          message: 'Detalji poslodavca',
                          child: Icon(
                            Icons.info_outline,
                            color: Colors.blue.shade400,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                TextSpan(
                  text: ' - ${job.city?.name ?? ''}',
                  style: const TextStyle(color: Colors.blue, fontSize: 16),
                ),
                WidgetSpan(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10), // Mimics SizedBox(width: 10)
                    child: JobBadge(status: job.status!), // Add JobBadge
                  ),
                ),

              ],
            ),
          ),
          const Divider(color: Colors.white24, height: defaultPadding),
          _buildDetailRow(
            icon: Icons.description,
            label: 'Opis posla:',
            value: '',
            customChild: Container(
              padding: const EdgeInsets.all(8),
              child: SizedBox(
                child: IgnorePointer(
                  child: quill.QuillEditor(
                    controller: quill.QuillController(
                      document: job.description != null
                          ? quill.Document.fromJson(
                          jsonDecode(job.description!))
                          : quill.Document(),
                      selection: const TextSelection.collapsed(offset: 0),
                    ),
                    focusNode: FocusNode(),
                    scrollController: ScrollController(),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          _buildDetailRow(
            icon: Icons.work,
            label: 'Tip posla:',
            value: job.jobType?.name ?? 'Nepoznato',
          ),
          const SizedBox(height: defaultPadding),
          _buildDetailRow(
            icon: Icons.supervisor_account,
            label: 'Potrebno radnika:',
            value: job.requiredEmployees?.toString() ?? 'Nepoznato',
          ),
          const SizedBox(height: defaultPadding),
          _buildDetailRow(
            icon: Icons.money,
            label: 'Plaća:',
            value: _getPaymentDetails(job),
          ),
          const SizedBox(height: defaultPadding),
          _buildDetailRow(
            icon: Icons.event,
            label: 'Rok za prijavu:',
            value: _getJobEndDate(job)
          ),
          if (job.schedules != null && job.schedules!.isNotEmpty) ...[
            const SizedBox(height: defaultPadding),
            _buildDetailRow(
              icon: Icons.schedule,
              label: 'Raspored posla:',
              value: '',
              customChild: Wrap(
                spacing: 8,
                children: job.schedules!
                    .where((schedule) => schedule.answer != null)
                    .map((schedule) => Chip(
                  label: Text(schedule.answer!),
                  backgroundColor: primaryColor.withOpacity(0.1),
                ))
                    .toList(),
              ),
            ),
          ],
          if (job.additionalPaymentOptions != null && job.additionalPaymentOptions!.isNotEmpty) ...[
            const SizedBox(height: defaultPadding),
            _buildDetailRow(
              icon: Icons.add_circle,
              label: 'Dodatno plaća:',
              value: '',
              customChild: Wrap(
                spacing: 8,
                children: job.additionalPaymentOptions!
                    .where((option) => option.answer != null)
                    .map((option) => Chip(
                  label: Text(option.answer!),
                  backgroundColor: Colors.green.withOpacity(0.1),
                ))
                    .toList(),
              ),
            ),
          ],
          const SizedBox(height: defaultPadding),
          JobActions(job: job),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    Widget? customChild
  }) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color:  primaryColor,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: primaryColor,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: customChild ??
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.start,
                ),
          ),
        ],
      ),
    );
  }

  String _getPaymentDetails(Job job) {
    if (job.paymentQuestion == null) return 'Nepoznato';
    String paymentText = job.paymentQuestion!.answer!;
    if (job.wage != null && job.wage! > 0) {
      paymentText += ': ${job.wage!} KM';
    }
    return paymentText;
  }

  String _getJobEndDate(Job job) {
    if (job.created == null) return 'Nepoznato datum';
    final endDate = job.created!.add(Duration(days: job.applicationsDuration ?? 0));
    return DateFormat('dd.MM.yyyy.').format(endDate);
  }
}