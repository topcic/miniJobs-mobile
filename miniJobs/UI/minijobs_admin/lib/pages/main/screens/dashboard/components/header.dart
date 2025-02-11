import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:minijobs_admin/providers/authentication_provider.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../responsve.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
          Spacer(flex: 2),
        ProfileCard()
      ],
    );
  }
}

class ProfileCard extends StatefulWidget {
  const ProfileCard({super.key});

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  void _handleLogout(BuildContext context) {
    // Call logout function from authentication provider
    context.read<AuthenticationProvider>().logout(context);
  }

  @override
  Widget build(BuildContext context) {
    final String userName = GetStorage().read('givenname') ?? "Korisnik";

    return PopupMenuButton<int>(
      onSelected: (value) {
        if (value == 1) {
          _handleLogout(context);
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem<int>(
          value: 1,
          child: Row(
            children: [
              Icon(Icons.exit_to_app, color: Colors.red),
              SizedBox(width: 8),
              Text("Odjavi se"),
            ],
          ),
        ),
      ],
      child: Container(
        margin: const EdgeInsets.only(left: defaultPadding),
        padding: const EdgeInsets.symmetric(
          horizontal: defaultPadding,
          vertical: defaultPadding / 2,
        ),
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            Image.asset(
              "assets/images/user-icon.png",
              height: 38,
            ),
            if (!Responsive.isMobile(context))
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                child: Text(userName),
              ),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }
}
