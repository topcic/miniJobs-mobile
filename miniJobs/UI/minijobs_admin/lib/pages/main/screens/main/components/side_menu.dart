import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/logo.png"),
          ),
          DrawerListTile(
            title: "Dashboard",
            icon: FontAwesomeIcons.tachometerAlt,
            press: () {},
          ),
          DrawerListTile(
            title: "Poslodavci",
            icon: FontAwesomeIcons.building,
            press: () {},
          ),
          DrawerListTile(
            title: "Aplikanti",
            icon: FontAwesomeIcons.user,
            press: () {},
          ),
          DrawerListTile(
            title: "Poslovi",
            icon: FontAwesomeIcons.briefcase,
            press: () {},
          ),
          DrawerListTile(
            title: "Aplikacije",
            icon: FontAwesomeIcons.fileAlt,
            press: () {},
          ),
          DrawerListTile(
            title: "Preporuke",
            icon: FontAwesomeIcons.star,
            press: () {},
          ),
          DrawerListTile(
            title: "Ocjene",
            icon: FontAwesomeIcons.thumbsUp,
            press: () {},
          ),
          DrawerListTile(
            title: "Izvještaji",
            icon: FontAwesomeIcons.chartBar,
            press: () {},
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.title,
    required this.icon,
    required this.press,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: FaIcon(
        icon,
        color: Colors.white54,
        size: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
}
