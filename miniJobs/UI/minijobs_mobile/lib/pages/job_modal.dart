import 'package:flutter/material.dart';

class CustomModal extends StatelessWidget {
  final String naziv;
  final String poslodavac;
  final String opstina;
  final String adresa;
  final String opis;
  final String posaoTip;
  final String cijena;
  final String nacinPlacanja;
  final String rasporedOdgovori;
  final String dodatnoPlacanje;
  final String dodatnoPlacanjecopy;
  final String brojRadnika;
  final String deadline;
  final String status;

  CustomModal({
    required this.naziv,
    required this.poslodavac,
    required this.opstina,
    required this.adresa,
    required this.opis,
    required this.posaoTip,
    required this.cijena,
    required this.nacinPlacanja,
    required this.rasporedOdgovori,
    required this.dodatnoPlacanje,
    required this.dodatnoPlacanjecopy,
    required this.brojRadnika,
    required this.deadline,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.bookmark_outline),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                "$naziv",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.location_on),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text("$poslodavac - $opstina, $adresa"),
                ],
              ),
              SizedBox(height: 10),
              Text(
                'Opis posla:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "$opis",
              ),
              SizedBox(height: 10),
              Text(
                'Tip posla: $posaoTip',
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.money),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text("$cijena $nacinPlacanja"),
                ],
              ),
              SizedBox(height: 10),
              Text(
                'Raspored posla:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "$rasporedOdgovori",
              ),
              SizedBox(height: 10),
              if (true) // Modify this condition as needed
                Text(
                  'Dodatno plaća:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              SizedBox(height: 10),
              if (true) // Modify this condition as needed
                Text(
                  "$dodatnoPlacanjecopy",
                ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.supervisor_account),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text("$brojRadnika radnik/a"),
                ],
              ),
              SizedBox(height: 10),
              if (true) // Modify this condition as needed
                Row(
                  children: [
                    Icon(Icons.date_range),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text("$deadline"),
                  ],
                ),
              if (true) // Modify this condition as needed
                Text(
                  'Posao je završen',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              SizedBox(height: 20),
              if (true) // Modify this condition as needed
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Logic for when the button is pressed
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal:
                                20), // Add horizontal padding to the button
                        child: Text('Apliciraj'),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
