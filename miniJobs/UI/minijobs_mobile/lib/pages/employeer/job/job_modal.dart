import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JobModal extends StatelessWidget {
  final String naziv;
  final String poslodavac;
  final String opstina;
  final String adresa;
  final String opis;
  final String posaoTip;
  final String cijena;
  final String nacinPlacanja;
  final String rasporedOdgovori;
  final String? dodatnoPlacanje;
  final String brojRadnika;
  final DateTime deadline;
  final String status;

  const JobModal({super.key, 
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
                    icon: const Icon(Icons.bookmark_outline),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                naziv,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.location_on),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Text("$poslodavac - $opstina, $adresa"),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Opis posla:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                opis,
              ),
              const SizedBox(height: 10),
              Text(
                'Tip posla: $posaoTip',
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.money),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Text("$cijena $nacinPlacanja"),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Raspored posla:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                rasporedOdgovori,
              ),
              const SizedBox(height: 10),
              if (true) // Modify this condition as needed
                const Text(
                  'Dodatno plaća:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.supervisor_account),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Text("$brojRadnika radnik/a"),
                ],
              ),
              const SizedBox(height: 10),
              if (true) // Modify this condition as needed
                Row(
                  children: [
                    const Icon(Icons.date_range),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Text(DateFormat('dd.MM.yyyy.').format(deadline)),
                  ],
                ),
              if (true) // Modify this condition as needed
                const Text(
                  'Posao je završen',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(height: 20),
              if (true) // Modify this condition as needed
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Logic for when the button is pressed
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
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
