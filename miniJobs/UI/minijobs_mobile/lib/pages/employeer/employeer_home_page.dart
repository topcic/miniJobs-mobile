import 'package:flutter/material.dart';

class EmployerHomePage extends StatefulWidget {
  @override
  _EmployerHomePageState createState() => _EmployerHomePageState();
}

class _EmployerHomePageState extends State<EmployerHomePage> {
  TextEditingController _locationController = TextEditingController();
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mini Jobs - Poslodavac'),
      ),
      body: Stack(
        children: [
          // Header container
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 130,
              color: Colors.blue,
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Pronađite idealnog radnika za vaš posao!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Pretražujte i pronađite radnike brzo i jednostavno!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Search bar container
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10.0),
              ),
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  SizedBox(width: 10.0),
                  Icon(Icons.location_on),
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
                  Icon(Icons.search),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: TextFormField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Pretraži radnike',
                      ),
                    ),
                  ),
                  SizedBox(width: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      String location = _locationController.text;
                      String searchTerm = _searchController.text;
                      // Implement search logic here
                      print('Location: $location, Search term: $searchTerm');
                    },
                    child: Text(
                      'Pretraži',
                      style: TextStyle(color: Colors.blue),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                  ),
                  SizedBox(width: 10.0),
                ],
              ),
            ),
          ),
          // Worker profiles container
          Positioned(
            top: 160,
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildWorkers(),
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

  Widget _buildWorkers() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: 8, // Replace with actual number of workers
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
                  'Worker Name $index',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on),
                    SizedBox(width: 10),
                    Text("Mostar"),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.work),
                    SizedBox(width: 10),
                    Text('Job Title $index'),
                  ],
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Show worker details
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Worker Details'),
                          content: Text('Details for Worker $index'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Close'),
                            ),
                          ],
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
}
