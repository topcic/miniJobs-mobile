import 'dart:async';
import 'package:flutter/material.dart';
import 'package:minijobs_admin/models/job/job.dart';
import 'package:minijobs_admin/providers/job_provider.dart';
import 'package:provider/provider.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

import '../../widgets/badges.dart';

class JobsView extends StatefulWidget {
  const JobsView({super.key});

  @override
  _JobsViewState createState() => _JobsViewState();
}

class _JobsViewState extends State<JobsView> {
  late JobProvider jobProvider;
  List<Job> data = [];
  bool isLoading = true;

  // Pagination and filtering parameters
  Map<String, dynamic> filter = {
    'limit': 10,
    'offset': 0,
    'sortBy': 'name',
    'sortOrder': 'asc',
    'searchText': '',
  };

  Timer? _debounce;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    jobProvider = context.read<JobProvider>();
    search();
  }

  Future<void> search() async {
    setState(() {
      isLoading = true;
    });

    final result = await jobProvider.searchPublic(filter);

    setState(() {
      data = result.result ?? [];
      isLoading = false;
    });
  }

  Future<void> delete(int jobId) async {
    await jobProvider.deletedByAdmin(jobId);
    final jobIndex = data.indexWhere((job) => job.id == jobId);
    setState(() {
      data[jobIndex].deletedByAdmin = true;
    });
  }

  Future<void> activateJob(int jobId) async {
    await jobProvider.activateByAdmin(jobId);
    final jobIndex = data.indexWhere((job) => job.id == jobId);
    setState(() {
      data[jobIndex].deletedByAdmin = false;
    });
  }

  void _debouncedSearch(String keyword) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        filter['searchText'] = keyword;
        search();
      });
    });
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
              delete(job.id!);
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

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pregled poslova'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Pretraži po nazivu...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _debouncedSearch,
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : HorizontalDataTable(
        leftHandSideColumnWidth: 100,
        rightHandSideColumnWidth: 1200,
        isFixedHeader: true,
        headerWidgets: _getTitleWidgets(),
        leftSideItemBuilder: _generateFirstColumnRow,
        rightSideItemBuilder: _generateRightHandSideColumnRow,
        itemCount: data.length,
        rowSeparatorWidget: const Divider(color: Colors.black54, height: 1.0),
        leftHandSideColBackgroundColor: Colors.white,
        rightHandSideColBackgroundColor: Colors.white,
      ),
    );
  }

  List<Widget> _getTitleWidgets() {
    return [
      _getTitleItemWidget('Akcije', 100),
      _getTitleItemWidget('Naziv', 200),
      _getTitleItemWidget('Opis', 300),
      _getTitleItemWidget('Tip posla', 150),
      _getTitleItemWidget('Grad', 150),
      _getTitleItemWidget('Broj radnika', 100),
      _getTitleItemWidget('Status', 200),
    ];
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      width: width,
      height: 56,
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Container(
      width: 100,
      height: 52,
      alignment: Alignment.center,
      child:   _buildActionsCell(context, data[index], 100),
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    final job = data[index];
    return Row(
      children: [
        _buildTableCell(job.name ?? '-', 200),
        _buildTableCell(job.description ?? '-', 300),
        _buildTableCell(job.jobType?.name ?? '-', 150),
        _buildTableCell(job.city?.name ?? '-', 150),
        _buildTableCell(job.requiredEmployees?.toString() ?? '-', 100),
        _buildTableCell(
          JobBadge(status: job.status!),
          200,
        ),
      ],
    );
  }

  Widget _buildTableCell(dynamic content, double width) {
    return Container(
      width: width,
      height: 52,
      alignment: Alignment.center,
      child: content is Widget ? content : Text(content.toString()),
    );
  }

  Widget _buildActionsCell(BuildContext context, Job job, double width) {
    return Container(
      width: width,
      height: 52,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _showDeleteConfirmation(context, job),
          ),
          IconButton(
            icon: const Icon(Icons.check, color: Colors.green),
            onPressed: () => _showActivateConfirmation(context, job),
          ),
        ],
      ),
    );
  }
}
