import 'dart:async';
import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:minijobs_admin/models/employer/employer.dart';
import 'package:minijobs_admin/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../../providers/employer_provider.dart';
import '../../widgets/badges.dart';
import 'employer_details_page.dart';

class EmployersView extends StatefulWidget {
  const EmployersView({super.key});

  @override
  _EmployersViewState createState() => _EmployersViewState();
}

class _EmployersViewState extends State<EmployersView> {
  late EmployerProvider employerProvider;
  late UserProvider userProvider;
  List<Employer> data = [];
  bool isLoading = true;

  Map<String, dynamic> filter = {
    'limit': 10,
    'offset': 0,
    'sortBy': 'firstName',
    'sortOrder': 'asc',
    'searchText': '',
  };

  Timer? _debounce;
  late ScrollController _verticalScrollController;
  late ScrollController _horizontalScrollController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    employerProvider = context.read<EmployerProvider>();
    userProvider = context.read<UserProvider>();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    setState(() {
      isLoading = true;
    });

    final result = await employerProvider.searchPublic(filter);

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
        filter['offset'] = 0;
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
      appBar: AppBar(title: const Text('Poslodavci')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
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
            child: HorizontalDataTable(
              leftHandSideColumnWidth: 150,
              rightHandSideColumnWidth: 1200,
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
              leftHandSideColBackgroundColor: Colors.white,
              rightHandSideColBackgroundColor: Colors.white,
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
                  child: const Text('Previous'),
                ),
                Text('Page ${(filter['offset'] / filter['limit']).floor() + 1}'),
                ElevatedButton(
                  onPressed: (filter['offset'] + filter['limit']) < data.length
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

  List<Widget> _buildHeaders() {
    return [
      _buildHeaderItem('Akcije', 150),
      _buildHeaderItem('Naziv', 200),
      _buildHeaderItem('Grad', 200),
      _buildHeaderItem('Email', 300, sortable: true, sortField: 'email'),
      _buildHeaderItem('Broj Telefona', 250),
      _buildHeaderItem('Status', 150, sortable: true, sortField: 'deleted'),
    ];
  }

  Widget _buildHeaderItem(String label, double width,
      {bool sortable = false, String? sortField}) {
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

  Widget _buildLeftColumn(BuildContext context, Employer employer) {
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
                        EmployerDetailsPage(employer: employer),
                  ),
                ),
          ),
          IconButton(
            icon: Icon(
              employer.deleted! ? Icons.refresh : Icons.block,
              color: employer.deleted! ? Colors.green : Colors.red,
            ),
            onPressed: () {
              if (employer.deleted!) {
                _showActivateConfirmation(context, employer);
              } else {
                _showBlockConfirmation(context, employer);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRightColumn(BuildContext context, Employer employer) {
    final fullName = employer.name?.isNotEmpty == true
        ? employer.name
        : '${employer.firstName ?? ''} ${employer.lastName ?? ''}'.trim();
    return Row(
      children: [
        _buildCell(Text('$fullName'), 200),
        _buildCell(Text(employer.city?.name ?? ''), 200),
        _buildCell(Text(employer.email ?? '-'), 300),
        _buildCell(Text(employer.phoneNumber ?? '-'), 250),
        _buildCell(UserStatusBadge(isBlocked: employer.deleted!), 150),
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

  void _showBlockConfirmation(BuildContext context, Employer employer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Blokiraj'),
        content: Text(
            'Da li ste sigurni da želite blokirati ${employer.firstName} ${employer.lastName}?'),
        actions: [
          TextButton(
            child: const Text('Odustani'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Blokiraj'),
            onPressed: () {
              blockUser(employer.id!);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _showActivateConfirmation(BuildContext context, Employer employer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Aktiviraj'),
        content: Text(
            'Da li ste sigurni da želite aktivirati ${employer.firstName} ${employer.lastName}?'),
        actions: [
          TextButton(
            child: const Text('Odustani'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Aktiviraj'),
            onPressed: () {
              activateUser(employer.id!);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
