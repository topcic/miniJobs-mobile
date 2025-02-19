import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:intl/intl.dart';
import 'package:minijobs_admin/pages/applicants/applicant_details.page.dart';
import 'package:provider/provider.dart';
import '../../models/job/job_application.dart';
import '../../providers/job_application_provider.dart';
import '../../widgets/badges.dart';
import '../main/constants.dart';
import 'job_details.dart';

class JobApplicationsView extends StatefulWidget {
  final int jobId;
  const JobApplicationsView({super.key, required this.jobId});

  @override
  _JobApplicationsViewState createState() => _JobApplicationsViewState();
}

class _JobApplicationsViewState extends State<JobApplicationsView> {
  late JobApplicationProvider jobApplicationProvider;
  List<JobApplication> data = [];
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    jobApplicationProvider = context.read<JobApplicationProvider>();
    fetchApplications();
  }

  Future<void> fetchApplications() async {
    setState(() {
      isLoading = true;
    });
    data = await jobApplicationProvider.getApplicationsWithDetails(widget.jobId);
    setState(() {
      isLoading = false;
    });
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return DateFormat('dd.MM.yyyy HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prijave za posao'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : data.isEmpty
          ? const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Posao nema aplikacija.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: HorizontalDataTable(
          leftHandSideColumnWidth: 120,
          rightHandSideColumnWidth: 900,
          isFixedHeader: true,
          headerWidgets: _getTitleWidgets(),
          leftSideItemBuilder: _generateFirstColumnRow,
          rightSideItemBuilder: _generateRightHandSideColumnRow,
          itemCount: data.length,
          rowSeparatorWidget: const Divider(color: Colors.black54, height: 1.0),
          leftHandSideColBackgroundColor: secondaryColor,
          rightHandSideColBackgroundColor: secondaryColor,
        ),
      ),
    );
  }

  List<Widget> _getTitleWidgets() {
    return [
      _getTitleItemWidget('Akcije', 120),
      _getTitleItemWidget('Ime i prezime', 120),
      _getTitleItemWidget('Status', 150),
      _getTitleItemWidget('Kreirano', 200),
      _getTitleItemWidget('Ocjena', 100),
      _getTitleItemWidget('Komentar', 200),
    ];
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      width: width,
      height: 56,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white, // Set text color to white
        ),
      ),
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Container(
      width: 100,
      height: 52,
      alignment: Alignment.center,
      child: _buildActionsCell(context, data[index], 150),
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    final application = data[index];
    return Row(
      children: [
        _buildTableCell(data[index].createdByName, 120),
        _buildTableCell(JobApplicationBadge(status: application.status!), 150),
        _buildTableCell(_formatDate(application.created), 200),
        _buildTableCell(application.rating?.value ?? '-', 100),
        _buildTableCell(application.rating?.comment ?? '-', 200),
      ],
    );
  }

  Widget _buildTableCell(dynamic content, double width) {
    return Container(
      width: width,
      height: 52,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: content is Widget
          ? content
          : Text(
        content.toString(),
        style: const TextStyle(color: Colors.white), // Set text color to white
      ),
    );
  }

  Widget _buildActionsCell(BuildContext context, JobApplication data, double width) {
    return Container(
      width: width,
      height: 52,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Existing 'Detalji aplikanta' button
          Tooltip(
            message: 'Detalji aplikanta',
            preferBelow: false,
            child: IconButton(
              icon: const Icon(Icons.info_outline, color: Colors.blue),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ApplicantDetailsPage(id: data.createdBy!),
                ),
              ),
              tooltip: '',
            ),
          ),
          const SizedBox(width: 8), // Space between buttons
          // New 'Detalji posla' button
          Tooltip(
            message: 'Detalji posla',
            preferBelow: false,
            child: IconButton(
              icon: const Icon(Icons.work_outline, color: Colors.blue),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JobDetailsPage(jobId: data.jobId!),
                ),
              ),
              tooltip: '',
            ),
          ),
        ],
      ),
    );
  }


}
