import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:minijobs_mobile/pages/home_page.dart';
import 'package:minijobs_mobile/pages/users.dart';

// ignore: must_be_immutable
class MasterScreenWidget extends StatefulWidget {
  Widget? child;
  String title;
  MasterScreenWidget({required this.title, this.child, super.key});

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
          DrawerHeader(
            child: Image.asset(
              "assets/images/logo.png",
              height: 180,
              width: 180,
            ),
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.house),
            title: const Text("Kontrolna ploča"),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) =>  const HomePage()));
            },
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.users),
            title: const Text("Korisnici"),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const UsersPage()));
            },
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.usersGear),
            title: const Text("Aplikanti"),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const UsersPage()));
            },
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.building),
            title: const Text("Poslodavci"),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const UsersPage()));
            },
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.suitcase),
            title: const Text("Poslovi"),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const UsersPage()));
            },
          ),
          ListTile(
            title: const Text("Korisnici 4"),
            onTap: () {
              //ja kom
            //  Navigator.of(context).push(MaterialPageRoute(
               //   builder: (context) => const CompanyEmployerSignupPage()));
            },
          )
        ],
      )),
      body: widget.child,
    );
  }
}
