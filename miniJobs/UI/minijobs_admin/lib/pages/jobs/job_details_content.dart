import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/job/job.dart';
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
          Text(job.name ?? 'Nema naziva',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: primaryColor)),
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
                    )


                  ),
                ),
                TextSpan(
                  text: ' - ${job.city?.name ?? ''}',
                  style: const TextStyle(color: Colors.blue, fontSize: 16),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white24, height: defaultPadding),

          _buildDetailSection('Opis posla:', job.description),
          _buildDetailSection('Tip posla:', job.jobType?.name),
          _buildDetailSection('Potrebno radnika:', job.requiredEmployees?.toString()),
          _buildDetailSection('Plaća:', _getPaymentDetails(job)),
          _buildDetailSection('Datum završetka:', _getJobEndDate(job)),

          if (job.schedules != null && job.schedules!.isNotEmpty) _buildScheduleSection(job),
          if (job.additionalPaymentOptions != null && job.additionalPaymentOptions!.isNotEmpty)
            _buildAdditionalPaymentOptions(job),

          const SizedBox(height: defaultPadding),
          JobActions(job: job),
        ],
      ),
    );
  }

  Widget _buildDetailSection(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text('$title ', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: primaryColor)),
          Expanded(
            child: Text(value ?? 'Nepoznato', style: const TextStyle(fontSize: 15, color: Colors.white70)),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleSection(Job job) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: defaultPadding),
        const Text('Raspored posla:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: primaryColor)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: job.schedules!
              .where((schedule) => schedule.answer != null)
              .map((schedule) => Chip(label: Text(schedule.answer!), backgroundColor: primaryColor.withOpacity(0.1)))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildAdditionalPaymentOptions(Job job) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: defaultPadding),
        const Text('Dodatno plaća:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: primaryColor)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: job.additionalPaymentOptions!
              .where((option) => option.answer != null)
              .map((option) => Chip(label: Text(option.answer!), backgroundColor: Colors.green.withOpacity(0.1)))
              .toList(),
        ),
      ],
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
