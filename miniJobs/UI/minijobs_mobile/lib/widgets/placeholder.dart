import 'package:flutter/material.dart';

class PlaceholderWidget extends StatelessWidget {
  const PlaceholderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Placeholder'),
      ),
      body: const Center(
        child: Text(
          'Navigation works!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}