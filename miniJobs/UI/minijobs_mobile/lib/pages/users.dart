// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:minijobs_mobile/models/search_result.dart';
import 'package:minijobs_mobile/models/user.dart';
import 'package:minijobs_mobile/pages/user.details.dart';
import 'package:minijobs_mobile/providers/user_provider.dart';
import 'package:minijobs_mobile/widgets/badges.dart';
import 'package:minijobs_mobile/widgets/master_screen.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late UserProvider userProvider;
  SearchResult<User>? result;
  String searchTerm = '';

  @override
  void initState()  {
    super.initState();
    loadData();
  }

  void loadData() async {
    userProvider = context.read<UserProvider>();
    // var data = await userProvider.get();
    // setState(() {
    //   result = data;
    // });
  }

  void search() async {
    // var data = await userProvider.get(searchTerm: searchTerm);
    // setState(() {
    //   result = data;
    // });
  }
  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Korisnici",
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            UserDetailsPage(), // Replace UserDetailsPage with your actual page
                      ),
                    );
                  },
                  child: Text("Dodaj korisnika"),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchTerm = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Pretraži po pojmu",
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: search,
                    child: Text("Pretraži"),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('Ime')),
                        DataColumn(label: Text('Prezime')),
                        DataColumn(label: Text('Email')),
                        DataColumn(label: Text('Broj telefona')),
                        DataColumn(label: Text('Status')),
                      ],
                      rows: result != null && result!.result != null
                          ? result!.result!
                          .map((User e) => DataRow(
                        cells: [
                          DataCell(Text(e.firstName ?? '')),
                          DataCell(Text(e.lastName ?? '')),
                          DataCell(
                            Row(
                              children: [
                                Text(e.email ?? ''),
                                SizedBox(width: 4),
                                Icon(
                                  e.accountConfirmed ?? false
                                      ? Icons.check
                                      : Icons.close,
                                  color: e.accountConfirmed ?? false
                                      ? Colors.greenAccent[700]
                                      : Colors.redAccent[700],
                                )
                              ],
                            ),
                          ),
                          DataCell(Text(e.phoneNumber ?? '')),
                          DataCell(UserBadge(
                              status: e.deleted!
                                  ? 'Obrisan'
                                  : 'Aktivan')),
                        ],
                      ))
                          .toList()
                          : [],
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
