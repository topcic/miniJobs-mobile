// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:minijobs_admin/models/search_result.dart';
import 'package:minijobs_admin/models/user.dart';
import 'package:minijobs_admin/providers/user_provider.dart';
import 'package:minijobs_admin/widgets/master_screen.dart';
import 'package:provider/provider.dart';

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  late UserProvider userProvider;
  SearchResult<User>? result;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    userProvider = context.read<UserProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Korisnici",
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              var data = await userProvider.get();
              setState(() {
                result = data;
                print(data);
              });
            },
            child: Text("flutter run -d windows"),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Ime')),
                  DataColumn(label: Text('Prezime')),
                  DataColumn(label: Text('Korisničko ime')),
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('Broj telefona')),
                ],
                rows:result != null && result!.result != null
    ? result!.result!.map((User e) => DataRow(
          cells: [
            DataCell(Text(e.firstName ?? '')),
            DataCell(Text(e.lastName ?? '')),
            DataCell(Text(e.userName ?? '')),
            DataCell(Text(e.email ?? '')),
            DataCell(Text(e.phoneNumber ?? '')),
          ],
        )).toList()
    : [],
                // rows: List<DataRow>.generate(
                //   result!.result!.length,
                //   (index) => DataRow(
                //     cells: [
                //       DataCell(Text(result!.result![index].firstName ?? '')),
                //       DataCell(Text(result!.result![index].lastName ?? '')),
                //       DataCell(Text(result!.result![index].userName ?? '')),
                //       DataCell(Text(result!.result![index].email ?? '')),
                //       DataCell(Text(result!.result![index].phoneNumber ?? '')),
                //     ],
                //   ),
                // ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
