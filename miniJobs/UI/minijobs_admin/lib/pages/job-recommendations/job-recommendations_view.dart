import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import '../../models/job_recommendation/job_recommendation_dto.dart';
import '../../providers/job_recommendation_provider.dart';
import '../applicants/applicant_details.page.dart';
import '../main/constants.dart';

class JobRecommendationsView extends StatefulWidget {
  const JobRecommendationsView({super.key});

  @override
  _JobRecommendationsViewState createState() => _JobRecommendationsViewState();
}

class _JobRecommendationsViewState extends State<JobRecommendationsView> {
  late JobRecommendationProvider jobRecommendationProvider;
  List< JobRecommendationDto> data = [];
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
    jobRecommendationProvider = context.read< JobRecommendationProvider>();
    search();
  }

  Future<void> search() async {
    setState(() {
      isLoading = true;
    });

    final result = await jobRecommendationProvider.search(filter);

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
        title: const Text('Pregled preporuka'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Pretraži po ocjeni ili komentaru',
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
              leftHandSideColumnWidth: 100,
              rightHandSideColumnWidth: 1200,
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
      _getTitleItemWidget('Akcije', 100),
      _getTitleItemWidget('Aplikant', 200),
      _getTitleItemWidget('Gradovi', 500),
      _getTitleItemWidget('Tipovi poslova', 500)
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
      child: _buildActionsCell(context, data[index], 100),
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    final x = data[index];
    return Row(
      children: [
        _buildTableCell(data[index].applicantFullName , 200),
        _buildTableCell(x.cities?.join(', ') ?? '', 500),
        _buildTableCell(x.jobTypes?.join(', ') ?? '', 500),
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
  Widget _buildActionsCell(BuildContext context, JobRecommendationDto data, double width) {
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

        ],
      ),
    );
  }
}