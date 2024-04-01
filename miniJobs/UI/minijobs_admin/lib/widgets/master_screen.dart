import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:minijobs_admin/pages/applicant_signup.page.dart';
import 'package:minijobs_admin/pages/company_employer_signup.page.dart';
import 'package:minijobs_admin/pages/users.dart';

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
            leading: FaIcon(FontAwesomeIcons.home),
            title: Text("Kontrolna ploča"),
            onTap:(){
              Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const UsersPage()));
            } ,
          ),
          ListTile(
             leading: FaIcon(FontAwesomeIcons.users),
            title: Text("Korisnici"),
            onTap:(){
              Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const UsersPage()));
            } ,
          ),
           ListTile(
             leading: FaIcon(FontAwesomeIcons.usersCog),
            title: Text("Aplikanti"),
            onTap:(){
              Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const UsersPage()));
            } ,
          ),
           ListTile(
             leading: FaIcon(FontAwesomeIcons.building),
            title: Text("Poslodavci"),
            onTap:(){
              Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const UsersPage()));
            } ,
          ),
           ListTile(
            leading: FaIcon(FontAwesomeIcons.suitcase),
            title: Text("Poslovi"),
            onTap:(){
              Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const UsersPage()));
            } ,
          ),
          ListTile(
            title: Text("Korisnici 2"),
            onTap:(){
              Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ApplicantSignupPage()));
            } ,
          ),
            ListTile(
            title: Text("Korisnici 4"),
            onTap:(){
              Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const CompanyEmployerSignupPage()));
            } ,
          )
        ],
      )),
      body: widget.child,
    );
  }
}
