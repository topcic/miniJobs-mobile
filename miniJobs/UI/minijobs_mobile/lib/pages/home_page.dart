import 'package:flutter/material.dart';
import 'package:minijobs_mobile/pages/job_modal.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _locationController = TextEditingController();
  TextEditingController _searchController = TextEditingController();

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Prvi kontejner
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 130,
              color: Colors.blue, // Plava pozadina
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Mini Jobs - part - time oglasnik',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text("Pronađite posao na brz i jednostavan način!",
                  textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),)
                ],
              ),
            ),
          ),
          // Drugi kontejner
          Positioned(
            top: 100, // Visina prvog kontejnera
            left: 0,
            right: 0,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10.0), // Radijus zaobljenja obruba
              ),
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  SizedBox(width: 10.0),
                  Icon(Icons.location_on), // Ikona za lokaciju
                  SizedBox(width: 10.0),
                  Expanded(
                    child: TextFormField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        hintText: 'Gdje?',
                      ),
                    ),
                  ),
                  SizedBox(width: 20.0),
                  Icon(Icons.search), // Ikona za lokaciju
                  SizedBox(width: 10.0),
                  Expanded(
                    child: TextFormField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Šta?',
                      ),
                    ),
                  ),
                  SizedBox(width: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      String location = _locationController.text;
                      String searchTerm = _searchController.text;
                      // Implementirajte logiku pretraživanja ovdje
                      print('Location: $location, Search term: $searchTerm');
                    },
                    child: Text(
                      'Pretraži',
                      style: TextStyle(color: Colors.blue),
                    ),
                    style: ElevatedButton.styleFrom(),
                  ),
                  SizedBox(width: 10.0),
                ],
              ),
            ),
          ),
          // Widget za poslove
          Positioned(
            top: 160, // Visina prvog i drugog kontejnera
            left: 0,
            right: 0,
            bottom: 0,
            child:Container(child:  _buildJobs())  
            ),
        ],
      ),
    );
  }


  @override
  void dispose() {
    _locationController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
Widget _buildJobs() {
  return Expanded(
    child: _buildJobsGrid(), // Koristimo novi widget za prikaz poslova u dvije kartice u redu
  );
}


Widget _buildJobsGrid() {
  return GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2, // Broj kartica u redu
      crossAxisSpacing: 10.0, // Razmak između kartica u redu
      mainAxisSpacing: 10.0, // Razmak između redova kartica
    ),
    itemCount: 8, // Zamijenite ovu vrijednost s vašim brojem poslova
    itemBuilder: (BuildContext context, int index) {
     return Card(
  margin: EdgeInsets.all(10.0),
  color: Colors.blue[50],
  child: Container(
    alignment: Alignment.center,
    padding: EdgeInsets.all(10.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Job Title $index',
          textAlign: TextAlign.center, // Poravnanje teksta na sredinu
        ),
        SizedBox(height: 10), // Prostor između tekstova i ikona
        Row(
          mainAxisAlignment: MainAxisAlignment.center, // Poravnanje u sredini
          children: [
            Icon(Icons.location_on), // Ikona za lokaciju
            SizedBox(width: 10),
            Text("Mostar"),
          ],
        ),
        SizedBox(height: 10), // Prostor između ikona i cijene
        Row(
          mainAxisAlignment: MainAxisAlignment.center, // Poravnanje u sredini
          children: [
            Icon(Icons.money_sharp),
            SizedBox(width: 10),
            Text('${10 * index}'),
          ],
        ),
        SizedBox(height: 10), // Prostor između cijene i gumba
         ElevatedButton(
          onPressed: () {
            // Show dialog with job details
           showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomModal(
          // Pass job details to the modal constructor
          naziv: 'Potreban radnik za dostavu hrane',
          poslodavac: 'Napolitano',
          opstina: 'Mostar',
          adresa: 'Kazazića 8',
          opis: 'Dostavljač hrane je odgovoran za preuzimanje narudžbi iz restorana ili kuhinja te njihovu dostavu klijentima na njihovu adresu. To uključuje vožnju do različitih lokacija i osiguravanje visoke kvalitete usluge i sigurnosti tijekom dostave. Komunikacija s klijentima i pridržavanje sigurnosnih i higijenskih standarda također su ključni dio ovog posla.',
          posaoTip: 'Dostavljač',
          cijena: '50',
          nacinPlacanja: 'dnevnica',
          rasporedOdgovori: 'prva smjena, druga smjena, pon-petak',
          dodatnoPlacanje: 'topli obrok, prekovremeni sati',
          dodatnoPlacanjecopy: 'topli obrok, prekovremeni sati',
          brojRadnika: '2',
          deadline: '12,5,2024',
          status: 'Aktivan',
        );
      },
    );
          },
          child: Text('Pogledaj'),
        ),
      ],
    ),
  ),
);

    },
  );
}