import 'dart:async';
import 'package:flutter/material.dart';
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
  // Pagination and filtering parameters
  Map<String, dynamic> filter = {
    'limit': 10,
    'offset': 0,
    'sortBy': 'firstName', // Default sorting column
    'sortOrder': 'asc',  // Default sorting order
    'searchText': '',    // Default search text
  };

  // Debouncing
  Timer? _debounce;

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

    // Fetch users with the filter object
    final result = await employerProvider.searchPublic( filter);

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
      appBar: AppBar(title: const Text('Poslodavci')),
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
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Enable horizontal scrolling
              child: SizedBox(
                width: MediaQuery.of(context).size.width, // Make table occupy full width
                child: PaginatedDataTable(
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
                    const DataColumn(
                      label: Text(
                        'Akcije',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: const Text(
                        'Naziv',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: const Text(
                        'Grad',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
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
                    DataColumn(
                      label: const Text(
                        'Broj telefona',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: const Text(
                        'Status',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  source: DataSource(data, context, blockUser, activateUser),
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
      case 'firstName': // Sort by firstName or lastName combined
      case 'lastName':
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
class DataSource extends DataTableSource {
  final List<Employer> employers;
  final BuildContext context;
  final Function(int) blockUser;
  final Function(int) activateUser;

  DataSource(this.employers, this.context, this.blockUser, this.activateUser);

  @override
  DataRow getRow(int index) {
    if (index >= employers.length) return null as DataRow;

    final user = employers[index];
    final fullName = user.name?.isNotEmpty == true
        ? user.name
        : '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim();

    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                tooltip: 'Detalji',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EmployerDetailsPage(employer: employers[index]),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(
                  user.deleted! ? Icons.refresh : Icons.block,
                  color: user.deleted! ? Colors.green : Colors.red,
                ),
                tooltip: user.deleted! ? 'Aktiviraj' : 'Blokiraj',
                onPressed: () {
                  if (user.deleted!) {
                    _showActivateConfirmation(context, user);
                  } else {
                    _showDeleteConfirmation(context, user);
                  }
                },
              ),
            ],
          ),
        ),
        DataCell(Text(fullName! )),
        DataCell(Text(user.city!.name!)),
        DataCell(
          Row(
            children: [
              Text(user.email ?? '-'),
              const SizedBox(width: 2),
              Icon(
                user.accountConfirmed == true ? Icons.check_circle : Icons.cancel,
                color: user.accountConfirmed == true ? Colors.green : Colors.red,
              ),
            ],
          ),
        ),
        DataCell(Text(user.phoneNumber ?? '-')),
        DataCell(UserStatusBadge(isBlocked: user.deleted!))
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => employers.length;

  @override
  int get selectedRowCount => 0;

  void _showDeleteConfirmation(BuildContext context, Employer employer) {
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
              blockUser(employer.id!); // Call blockUser
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
              activateUser(employer.id!); // Call activateUser
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
