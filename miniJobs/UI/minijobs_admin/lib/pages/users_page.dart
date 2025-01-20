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
  int rowsPerPage = 10; // Number of rows per page in the table
  int totalRows = 0; // Total number of users
  int currentPage = 0; // Current page index

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userProvider = context.read<UserProvider>();
    fetchUsers();
  }

  Future<void> fetchUsers({int offset = 0, int limit = 10}) async {
    setState(() {
      isLoading = true;
    });

    // Fetch users with pagination
    final result = await _userProvider.search();

    setState(() {
      users = result.result!; // Replace with actual result parsing
      totalRows = result.count; // Replace with the total user count from API
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: PaginatedDataTable(
          header: const Text(
            'User List',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          rowsPerPage: rowsPerPage,
          availableRowsPerPage: const [10],
          onPageChanged: (newPage) {
            currentPage = newPage ~/ rowsPerPage;
            fetchUsers(offset: currentPage * rowsPerPage, limit: rowsPerPage);
          },
          columns: const [
            DataColumn(
              label: Text(
                'Full Name',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'Email',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'Phone Number',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'Email Confirmed',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'Role',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'Actions',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
          source: UsersDataSource(users, context),
        ),
      ),
    );
  }
}

class UsersDataSource extends DataTableSource {
  final List<User> users;
  final BuildContext context;

  UsersDataSource(this.users, this.context);

  @override
  DataRow getRow(int index) {
  //  if (index >= users.length) return null;

    final user = users[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(user.fullName ?? 'N/A')),
        DataCell(Text(user.email ?? 'N/A')),
        DataCell(Text(user.phoneNumber ?? 'N/A')),
        DataCell(
          Row(
            children: [
              Icon(
                user.accountConfirmed == true ? Icons.check_circle : Icons.cancel,
                color: user.accountConfirmed == true ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 4),
              Text(user.accountConfirmed == true ? 'Yes' : 'No'),
            ],
          ),
        ),
        DataCell(Text(user.role ?? 'N/A')),
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
