import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user/user.dart';
import '../providers/user_provider.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late UserProvider _userProvider;
  List<User> users = [];
  bool isLoading = true;

  // Pagination and filtering parameters
  Map<String, dynamic> filter = {
    'limit': 10,
    'offset': 0,
    'sortBy': 'fullName', // Default sorting column
    'sortOrder': 'asc',  // Default sorting order
    'searchText': '',    // Default search text
  };

  // Debouncing
  Timer? _debounce;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userProvider = context.read<UserProvider>();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    setState(() {
      isLoading = true;
    });

    // Fetch users with the filter object
    final result = await _userProvider.search( filter);

    setState(() {
      users = result.result!;
      isLoading = false;
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
      filter['offset'] = 0; // Reset pagination on new sort
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
      appBar: AppBar(title: const Text('Users')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search by name, email, phone, or role',
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
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Enable horizontal scrolling
              child: SizedBox(
                width: MediaQuery.of(context).size.width, // Make table occupy full width
                child: PaginatedDataTable(
                  header: const Text(
                    'User List',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  rowsPerPage: filter['limit'],
                  availableRowsPerPage: const [10, 20, 50],
                  onRowsPerPageChanged: (rows) {
                    setState(() {
                      filter['limit'] = rows!;
                      filter['offset'] = 0; // Reset pagination
                    });
                    fetchUsers();
                  },
                  onPageChanged: _changePage,
                  sortColumnIndex: _getColumnIndex(filter['sortBy']),
                  sortAscending: filter['sortOrder'] == 'asc',
                  columns: [
                    DataColumn(
                      label: const Text(
                        'Full Name',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onSort: (columnIndex, ascending) {
                        _sort('fullName', ascending);
                      },
                    ),
                    DataColumn(
                      label: const Text(
                        'Email',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onSort: (columnIndex, ascending) {
                        _sort('email', ascending);
                      },
                    ),
                    const DataColumn(
                      label: Text(
                        'Phone Number',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const DataColumn(
                      label: Text(
                        'Email Confirmed',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: const Text(
                        'Role',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onSort: (columnIndex, ascending) {
                        _sort('role', ascending);
                      },
                    ),
                    const DataColumn(
                      label: Text(
                        'Actions',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  source: UsersDataSource(users, context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _getColumnIndex(String? sortBy) {
    switch (sortBy) {
      case 'fullName':
        return 0;
      case 'email':
        return 1;
      case 'role':
        return 4;
      default:
        return -1;
    }
  }
}

class UsersDataSource extends DataTableSource {
  final List<User> users;
  final BuildContext context;

  UsersDataSource(this.users, this.context);

  @override
  DataRow getRow(int index) {
    if (index >= users.length) return null as DataRow;

    final user = users[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(user.fullName ?? '-')),
        DataCell(Text(user.email ?? '-')),
        DataCell(Text(user.phoneNumber ?? '-')),
        DataCell(
          Row(
            children: [
              Icon(
                user.accountConfirmed == true
                    ? Icons.check_circle
                    : Icons.cancel,
                color:
                user.accountConfirmed == true ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 4),
              Text(user.accountConfirmed == true ? 'Yes' : 'No'),
            ],
          ),
        ),
        DataCell(Text(user.role ?? '-')),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                tooltip: 'Edit User',
                onPressed: () {
                  // Navigate to edit user page
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                tooltip: 'Delete User',
                onPressed: () {
                  _showDeleteConfirmation(context, user);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => users.length;

  @override
  int get selectedRowCount => 0;

  void _showDeleteConfirmation(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete ${user.fullName}?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Delete'),
            onPressed: () {
              // Call delete API
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
