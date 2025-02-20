import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import '../../models/saved_job.dart';
import '../../providers/saved_job_provider.dart';
import '../../widgets/badges.dart';
import '../applicants/applicant_details.page.dart';
import '../jobs/job_details.dart';
import '../main/constants.dart';

class SavedJobsView extends StatefulWidget {
  const SavedJobsView({super.key});

  @override
  _SavedJobsViewState createState() => _SavedJobsViewState();
}

class _SavedJobsViewState extends State<SavedJobsView> {
  late SavedJobProvider savedJobProvider;
  List< SavedJob> data = [];
  bool isLoading = true;
  late ScrollController _verticalScrollController;
  late ScrollController _horizontalScrollController;
  // Pagination and filtering parameters
  Map<String, dynamic> filter = {
    'limit': 10,
    'offset': 0,
    'sortBy': 'created',
    'sortOrder': 'asc',
    'searchText': '',
  };

  Timer? _debounce;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    savedJobProvider = context.read< SavedJobProvider>();
    search();
  }

  Future<void> search() async {
    setState(() {
      isLoading = true;
    });

    final result = await savedJobProvider.search(filter);

    setState(() {
      data = result.result ?? [];
      isLoading = false;
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

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
  void _changePage(int newPage) {
    setState(() {
      filter['offset'] = newPage * filter['limit'];
    });
    search();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pregled spremljenih poslova'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Pretraži...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (text) {
                if (_debounce?.isActive ?? false) _debounce!.cancel();
                _debounce = Timer(const Duration(milliseconds: 500), () {
                  setState(() {
                    filter['searchText'] = text;
                    filter['offset'] = 0;
                  });
                  search();
                });
              },
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: HorizontalDataTable(
              leftHandSideColumnWidth: 150,
              rightHandSideColumnWidth: 800,
              isFixedHeader: true,
              headerWidgets: _getTitleWidgets(),
              leftSideItemBuilder: _generateFirstColumnRow,
              rightSideItemBuilder: _generateRightHandSideColumnRow,
              itemCount: data.length,
              rowSeparatorWidget: const Divider(color: Colors.black54, height: 1.0),
              leftHandSideColBackgroundColor:secondaryColor,
              rightHandSideColBackgroundColor: secondaryColor,
              onScrollControllerReady: (vertical, horizontal) {
                _verticalScrollController = vertical;
                _horizontalScrollController = horizontal;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: filter['offset'] > 0
                      ? () => _changePage((filter['offset'] / filter['limit']).floor() - 1)
                      : null,
                  child: const Text('Prethodna'),
                ),
                Text('Stranica ${(filter['offset'] / filter['limit']).floor() + 1}'),
                ElevatedButton(
                  onPressed: data.length == filter['limit']
                      ? () => _changePage((filter['offset'] / filter['limit']).floor() + 1)
                      : null,
                  child: const Text('Sljedeća'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _getTitleWidgets() {
    return [
      _getTitleItemWidget('Akcije', 150),
      _getTitleItemWidget('Aplikant', 200),
      _getTitleItemWidget('Posao', 200),
      _getTitleItemWidget('Spašen', 200),
      _getTitleItemWidget('Status', 200)
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
      child: _buildActionsCell(context, data[index], 150),
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    final x = data[index];
    return Row(
      children: [
        _buildTableCell(data[index].applicantFullName , 200),
        _buildTableCell(x.jobName, 200),
        _buildTableCell(DateFormat('dd.MM.yyyy HH:mm').format(x.created!), 200),
        _buildTableCell(
          SavedJobBadge(IsDeleted: x.isDeleted!),
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
  Widget _buildActionsCell(BuildContext context, SavedJob data, double width) {
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