import 'dart:async';
import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:minijobs_admin/models/applicant/applicant.dart';
import 'package:minijobs_admin/pages/main/constants.dart';
import 'package:minijobs_admin/providers/applicant_provider.dart';
import 'package:minijobs_admin/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../../widgets/badges.dart';
import 'applicant_details.page.dart';

class ApplicantsView extends StatefulWidget {
  const ApplicantsView({super.key});

  @override
  _ApplicantsViewState createState() => _ApplicantsViewState();
}

class _ApplicantsViewState extends State<ApplicantsView> {
  late ApplicantProvider _applicantProvider;
  late UserProvider userProvider;
  List<Applicant> data = [];
  bool isLoading = true;

  // Pagination and filtering parameters
  Map<String, dynamic> filter = {
    'limit': 10,
    'offset': 0,
    'sortBy': 'firstName',
    'sortOrder': 'asc',
    'searchText': '',
  };

  // Debouncing
  Timer? _debounce;

  late ScrollController _verticalScrollController;
  late ScrollController _horizontalScrollController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _applicantProvider = context.read<ApplicantProvider>();
    userProvider = context.read<UserProvider>();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    setState(() {
      isLoading = true;
    });

    final result = await _applicantProvider.searchPublic(filter);

    setState(() {
      data = result.result!;
      isLoading = false;
    });
  }

  Future<void> blockUser(int userId) async {
    await userProvider.delete(userId);
    final userIndex = data.indexWhere((user) => user.id == userId);
    setState(() {
      data[userIndex].deleted = true;
    });
  }

  Future<void> activateUser(int userId) async {
    await userProvider.activate(userId);
    final userIndex = data.indexWhere((user) => user.id == userId);
    setState(() {
      data[userIndex].deleted = false;
    });
  }

  void _debouncedSearch(String keyword) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        filter['searchText'] = keyword;
        filter['offset'] = 0; // Reset pagination when searching
      });
      fetchUsers();
    });
  }

  void _sort(String sortBy, bool ascending) {
    setState(() {
      filter['sortBy'] = sortBy;
      filter['sortOrder'] = ascending ? 'asc' : 'desc';
      filter['offset'] = 0;
    });
    fetchUsers();
  }

  void _changePage(int newPage) {
    setState(() {
      filter['offset'] = newPage * filter['limit'];
    });
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aplikanti')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Pretraži',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(
                text: filter['searchText'], // Retain search input value
              ),
              onChanged: _debouncedSearch,
            ),
          ),
          Expanded(
            child: HorizontalDataTable(
              leftHandSideColumnWidth: 150,
              rightHandSideColumnWidth: 800,
              isFixedHeader: true,
              headerWidgets: _buildHeaders(),
              leftSideItemBuilder: (context, index) =>
                  _buildLeftColumn(context, data[index]),
              rightSideItemBuilder: (context, index) =>
                  _buildRightColumn(context, data[index]),
              itemCount: data.length,
              rowSeparatorWidget: Divider(color: Colors.grey[300], height: 1.0),
              onScrollControllerReady: (vertical, horizontal) {
                _verticalScrollController = vertical;
                _horizontalScrollController = horizontal;
              },
              leftHandSideColBackgroundColor:secondaryColor,
              rightHandSideColBackgroundColor: secondaryColor,
              itemExtent: 56,
            ),
          ),
          // Pagination Controls
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: filter['offset'] > 0
                      ? () =>
                      _changePage(
                          (filter['offset'] / filter['limit']).floor() - 1)
                      : null,
                  child: const Text('Previous'),
                ),
                Text(
                    'Page ${(filter['offset'] / filter['limit']).floor() + 1}'),
                ElevatedButton(
                  onPressed: (filter['offset'] + filter['limit']) < data.length
                      ? () =>
                      _changePage(
                          (filter['offset'] / filter['limit']).floor() + 1)
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

  List<Widget> _buildHeaders() {
    return [
      _buildHeaderItem('Akcije', 150),
      _buildHeaderItem('Ime i Prezime', 200, sortable: true, sortField: 'firstName'),
      _buildHeaderItem('Email', 300, sortable: true, sortField: 'email'),
      _buildHeaderItem('Broj Telefona', 150,),
      _buildHeaderItem('Status', 150, sortable: true, sortField: 'deleted'),
    ];
  }

  Widget _buildHeaderItem(String label, double width,
      {bool sortable = false, String? sortField}) {
    return GestureDetector(
      onTap: sortable
          ? () =>
          _sort(sortField!, filter['sortBy'] != sortField || filter['sortOrder'] == 'desc')
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


  Widget _buildLeftColumn(BuildContext context, Applicant applicant) {
    return Container(
      width: 150,
      height: 52,
      alignment: Alignment.center,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue),
            onPressed: () =>
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ApplicantDetailsPage(id: applicant.id!),
                  ),
                ),
          ),
          IconButton(
            icon: Icon(
              applicant.deleted! ? Icons.refresh : Icons.block,
              color: applicant.deleted! ? Colors.green : Colors.red,
            ),
            onPressed: () {
              if (applicant.deleted!) {
                activateUser(applicant.id!);
              } else {
                blockUser(applicant.id!);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRightColumn(BuildContext context, Applicant applicant) {
    return Row(
      children: [
        _buildCell(
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text('${applicant.firstName} ${applicant.lastName}'),
          ),
          200,
        ),
        _buildCell(Text(applicant.email ?? '-'), 300),
        _buildCell(Text(applicant.phoneNumber ?? '-'), 150),
        _buildCell(UserStatusBadge(isBlocked: applicant.deleted!), 150),
        // Pass the badge widget
      ],
    );
  }

  Widget _buildCell(Widget content, double width) {
    return Container(
      width: width,
      height: 52,
      alignment: Alignment.centerLeft,
      child: content, // Directly use the widget here
    );
  }
}