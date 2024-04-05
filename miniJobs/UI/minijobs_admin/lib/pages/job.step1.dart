import 'package:flutter/material.dart';

class JobStep1Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
       Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 200,
           child: Image.asset(
              'assets/images/basic.png',
              fit: BoxFit.cover,
             // height: 300,
              //width: 200,
            ),
            //  child: Image.asset("assets/images/Basic.png",
            //               height: 150, width: 150),
            ),
       ),

            Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Dodajte posao',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  
                ],
              ),
            ),
        
          ],
        ),
        
      //  JobForm(),
      ),
    );
  }
}

class JobForm extends StatefulWidget {
  @override
  _JobFormState createState() => _JobFormState();
}

class _JobFormState extends State<JobForm> {
  String _jobName = '';
  String _selectedCity='';
  String _address = '';

  final List<String> _cities = ['City 1', 'City 2', 'City 3']; // Replace with your actual city list

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Naziv posla'),
            onChanged: (value) {
              setState(() {
                _jobName = value;
              });
            },
          ),
          SizedBox(height: 20),
          // DropdownButtonFormField(
          //   decoration: InputDecoration(labelText: 'Izaberite grad'),
          //   value: _selectedCity,
          //   items: _cities.map((city) {
          //     return DropdownMenuItem(
          //       value: city,
          //       child: Text(city),
          //     );
          //   }).toList(),
          //   onChanged: (value) {
          //     setState(() {
          //       _selectedCity = value!;
          //     });
          //   },
          // ),
          SizedBox(height: 20),
          TextFormField(
            decoration: InputDecoration(labelText: 'Adresa'),
            onChanged: (value) {
              setState(() {
                _address = value;
              });
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Handle form submission
              print('Job Name: $_jobName');
              print('Selected City: $_selectedCity');
              print('Address: $_address');
            },
            child: Text('Dalje'),
          ),
        ],
      ),
    );
  }
}