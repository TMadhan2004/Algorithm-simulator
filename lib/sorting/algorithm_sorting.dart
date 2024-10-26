// algorithm_sorting.dart

import 'package:flutter/material.dart';
import 'algorithm_descriptions.dart'; // Import the descriptions map

class AlgorithmSortingPage extends StatelessWidget {
  final String algorithm;

  AlgorithmSortingPage({
    required this.algorithm,
  });

  @override
  Widget build(BuildContext context) {
    String description = algorithmDescriptions[algorithm] ?? 'No description available';

    return Scaffold(
      appBar: AppBar(
        title: Text('$algorithm Algorithm Description'),
      ),
      body: SingleChildScrollView( // Wrap with SingleChildScrollView
        padding: const EdgeInsets.all(16.0),
        child: Text(
          description,
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }
}