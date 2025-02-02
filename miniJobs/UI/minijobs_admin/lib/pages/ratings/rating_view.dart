import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minijobs_admin/models/rating.dart';
import 'package:minijobs_admin/providers/rating_provider.dart';
import 'package:provider/provider.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import '../../widgets/badges.dart';
import '../main/constants.dart';

class RatingsView extends StatefulWidget {
  const RatingsView({super.key});

  @override
  _RatingsViewState createState() => _RatingsViewState();
}

class _RatingsViewState extends State<RatingsView> {
  late RatingProvider ratingProvider;
  List<Rating> data = [];
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
    ratingProvider = context.read<RatingProvider>();
    search();
  }

  Future<void> search() async {
    setState(() {
      isLoading = true;
    });

    final result = await ratingProvider.search(filter);

    setState(() {
      data = result.result ?? [];
      isLoading = false;
    });
  }

  Future<void> delete(int id) async {
    await ratingProvider.delete(id);
   search();
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

  void _showDeleteConfirmation(BuildContext context, Rating rating) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Obriši'),
        content: const Text('Da li ste sigurni da želite obrisati ovu ocjenu?'),
        actions: [
          TextButton(
            child: const Text('Odustani'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Obriši'),
            onPressed: () {
              delete(rating.id!);
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
        title: const Text('Pregled ocjena'),
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
              leftHandSideColumnWidth: 50,
              rightHandSideColumnWidth: 1400,
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
                  child: const Text('Previous'),
                ),
                Text('Page ${(filter['offset'] / filter['limit']).floor() + 1}'),
                ElevatedButton(
                  onPressed: data.length == filter['limit']
                      ? () => _changePage((filter['offset'] / filter['limit']).floor() + 1)
                      : null,
                  child: const Text('Next'),
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
      _getTitleItemWidget('Akcije', 50),
      _getTitleItemWidget('Ocjenio', 150),
      _getTitleItemWidget('Ocjenjeni', 150),
      _getTitleItemWidget('Ocjena', 100),
      _getTitleItemWidget('Komentar', 400),
      _getTitleItemWidget('Posao', 250),
      _getTitleItemWidget('Kreirano', 150),
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
      child:   _buildActionsCell(context, data[index], 150),
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    final rating = data[index];
    return Row(
      children: [
        _buildTableCell(rating.createdByFullName , 150),
        _buildTableCell(rating.ratedUserFullName, 150),
        _buildTableCell(rating.value.toString(), 100),
        _buildTableCell(rating.comment , 400),
        _buildTableCell(rating.jobName ?? '-', 250),
        _buildTableCell(DateFormat('dd.MM.yyyy HH:mm').format(rating.created), 150),
        _buildTableCell(
          RatingBadge(isActive: rating.isActive),
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
  Widget _buildActionsCell(BuildContext context, Rating rating, double width) {
    return Container(
      width: width,
      height: 52,
      alignment: Alignment.center,
      child: Tooltip(
        message: 'Obriši',
        preferBelow: false, // Ensures the tooltip appears above
        child: IconButton(
          icon: const Icon(Icons.block, color: Colors.red),
          onPressed: () => _showDeleteConfirmation(context, rating),
          tooltip: '', // Ensures Flutter doesn't show the default label behavior
        ),
      ),
    );
  }
}