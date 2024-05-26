import 'package:flutter/material.dart';

class PlaceholderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Placeholder'),
      ),
      body: Center(
        child: Text(
          'Navigation works!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}