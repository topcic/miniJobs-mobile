import 'package:flutter/material.dart';

class JobList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Allowing horizontal scrolling
      child: SingleChildScrollView(
        child: DataTable(
          columns: [
            DataColumn(
              label: Text('Opcije'),
            ),
            DataColumn(
              label: Text('Naziv'),
            ),
            DataColumn(
              label: Text('Kreiran'),
            ),
            DataColumn(
              label: Text('Aplikacije traju do'),
            ),
            DataColumn(
              label: Text('Broj aplikacija'),
            ),
            DataColumn(
              label: Text('Status'),
            ),
          ],
          rows: [
            DataRow(cells: [
              DataCell(
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, size: 18),
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      child: Row(children: [
                        Icon(Icons.reorder, size: 18),
                        Text('Detalji')
                      ]),
                      onTap: () => {},
                    ),
                    PopupMenuItem<String>(
                      child: Row(children: [
                        Icon(
                          Icons.close,
                          color: Colors.redAccent[700],
                          size: 18,
                        ),
                        Text('Obriši')
                      ]),
                      onTap: () => {},
                    ),
                    PopupMenuItem<String>(
                      child: Row(children: [
                        Icon(Icons.check,
                            color: Colors.greenAccent[700], size: 18),
                        Text('Završi')
                      ]),
                      onTap: () => {},
                    ),
                    // Add more options as needed
                  ],
                  onSelected: (String value) {
                    // Handle option selection here
                    print('Selected: $value');
                  },
                ),
              ),
              DataCell(
                Center(child: Text('Naziv 1')),
              ),
              DataCell(
                Center(child: Text('18.1.2024')),
              ),
              DataCell(
                Center(child: Text('18.4.2024')),
              ),
              DataCell(
                Center(child: Text('4')),
              ),
              DataCell(
                Center(child: Text('Status 1')),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
