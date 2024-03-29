import 'package:flutter/material.dart';
import 'package:minijobs_admin/screens/users.dart';

// ignore: must_be_immutable
class MasterScreenWidget extends StatefulWidget {
  Widget? child;
  String title;
  MasterScreenWidget({required this.title, this.child, Key? key})
      : super(key: key);

  @override
  State<MasterScreenWidget> createState() => _MasterScreenWidgetState();
}

class _MasterScreenWidgetState extends State<MasterScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
          child: ListView(
        children: [
          ListTile(
            title: Text("Korisnici"),
            onTap:(){
              Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const Users()));
            } ,
          )
        ],
      )),
      body: widget.child,
    );
  }
}
