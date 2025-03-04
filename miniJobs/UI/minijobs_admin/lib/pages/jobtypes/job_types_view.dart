import 'dart:async';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:minijobs_admin/pages/main/constants.dart';
import 'package:provider/provider.dart';
import 'package:another_flushbar/flushbar.dart';
import '../../models/job_type.dart';
import '../../providers/job_type_provider.dart';
import '../../widgets/badges.dart';
import 'job_type_form.dart';

class JobTypesView extends StatefulWidget {
  const JobTypesView({super.key});

  @override
  _JobTypesViewState createState() => _JobTypesViewState();
}

class _JobTypesViewState extends State<JobTypesView> {
  late JobTypeProvider jobTypeProvider;
  List<JobType> data = [];
  bool isLoading = true;
  bool _showForm = false;
  JobType? jobTypeToEdit;

  Map<String, dynamic> filter = {
    'limit': 10,
    'offset': 0,
    'sortBy': 'name',
    'sortOrder': 'asc',
    'searchText': '',
  };

  Timer? _debounce;
  late ScrollController _verticalScrollController;
  late ScrollController _horizontalScrollController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    jobTypeProvider = context.read<JobTypeProvider>();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    final result = await jobTypeProvider.searchPublic(filter);

    setState(() {
      data = result.result!;
      isLoading = false;
    });
  }

  void _debouncedSearch(String keyword) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        filter['searchText'] = keyword;
        filter['offset'] = 0;
      });
      fetchData();
    });
  }

  void _sort(String sortBy, bool ascending) {
    setState(() {
      filter['sortBy'] = sortBy;
      filter['sortOrder'] = ascending ? 'asc' : 'desc';
      filter['offset'] = 0;
    });
    fetchData();
  }

  void _changePage(int newPage) {
    setState(() {
      filter['offset'] = newPage * filter['limit'];
    });
    fetchData();
  }

  void showFlushbarWithRootNavigator(Flushbar flushbar, BuildContext context) {
    Navigator.of(context, rootNavigator: true).push(
      FlushbarRoute(
        flushbar: flushbar,
      ),
    );
  }

  void openJobTypeForm(JobType? jobType) {
    setState(() {
      _showForm = true;
      jobTypeToEdit = jobType;
    });
  }

  void _closeForm({bool success = false}) {
    setState(() {
      _showForm = false;
      jobTypeToEdit = null;
    });
    if (success) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        fetchData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Države'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Pretraži',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  controller: TextEditingController(
                    text: filter['searchText'],
                  ),
                  onChanged: _debouncedSearch,
                ),
              ),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : HorizontalDataTable(
                  leftHandSideColumnWidth: 150,
                  rightHandSideColumnWidth: 450,
                  isFixedHeader: true,
                  headerWidgets: _buildHeaders(),
                  leftSideItemBuilder: (context, index) => _buildLeftColumn(context, data[index]),
                  rightSideItemBuilder: (context, index) => _buildRightColumn(context, data[index]),
                  itemCount: data.length,
                  rowSeparatorWidget: Divider(color: Colors.grey[300], height: 1.0),
                  onScrollControllerReady: (vertical, horizontal) {
                    _verticalScrollController = vertical;
                    _horizontalScrollController = horizontal;
                  },
                  leftHandSideColBackgroundColor: secondaryColor,
                  rightHandSideColBackgroundColor: secondaryColor,
                  itemExtent: 56,
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
                      onPressed: (filter['offset'] + filter['limit']) < data.length
                          ? () => _changePage((filter['offset'] / filter['limit']).floor() + 1)
                          : null,
                      child: const Text('Sljedeća'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_showForm)
            GestureDetector(
              onTap: () => _closeForm(),
              child: Container(
                color: Colors.black54,
                child: Center(
                  child: GestureDetector(
                    onTap: () {},
                    child: JobTypeForm(
                      jobType: jobTypeToEdit,
                      onClose: _closeForm,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildHeaders() {
    return [
      _buildHeaderItem('Akcije', 150),
      _buildHeaderItem('Naziv', 250, sortable: true, sortField: 'name'),
      _buildHeaderItem('Status', 100, sortable: true, sortField: 'isDeleted'),
      Container(
        width: 100,
        height: 56,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 8),
        child: ElevatedButton.icon(
          onPressed: () {
            openJobTypeForm(null); // Open form for adding
          },
          icon: const Icon(Icons.add, size: 16),
          label: const Text('Dodaj'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            minimumSize: const Size(0, 32),
            textStyle: const TextStyle(fontSize: 12),
          ),
        ),
      ),
    ];
  }

  Widget _buildHeaderItem(String label, double width, {bool sortable = false, String? sortField}) {
    return GestureDetector(
      onTap: sortable
          ? () => _sort(sortField!, filter['sortBy'] != sortField || filter['sortOrder'] == 'desc')
          : null,
      child: Container(
        width: width,
        height: 56,
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            if (sortable)
              Icon(
                filter['sortBy'] == sortField
                    ? (filter['sortOrder'] == 'asc' ? Icons.arrow_upward : Icons.arrow_downward)
                    : Icons.unfold_more,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftColumn(BuildContext context, JobType jobType) {
    return Container(
      width: 150,
      height: 52,
      alignment: Alignment.center,
      child: Row(
        children: [
          Tooltip(
            message: 'Uredi državu',
            child: IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                openJobTypeForm(jobType); // Open form for editing
              },
            ),
          ),
          Tooltip(
            message: jobType.isDeleted! ? 'Aktiviraj' : 'Deaktiviraj',
            child: IconButton(
              icon: Icon(
                jobType.isDeleted! ? Icons.refresh : Icons.delete,
                color: jobType.isDeleted! ? Colors.green : Colors.red,
              ),
              onPressed: () async {
                if (jobType.isDeleted!) {
                  await jobTypeProvider.activate(jobType.id!);
                } else {
                  await jobTypeProvider.delete(jobType.id!);
                }
                fetchData();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightColumn(BuildContext context, JobType jobType) {
    return Row(
      children: [
        _buildCell(Text(jobType.name ?? '-'), 250),
        _buildCell(
          RatingBadge(isActive: jobType.isDeleted!), // Inverted for display logic
          150,
        ),
      ],
    );
  }

  Widget _buildCell(Widget content, double width) {
    return Container(
      width: width,
      height: 52,
      alignment: Alignment.centerLeft,
      child: content,
    );
  }
}