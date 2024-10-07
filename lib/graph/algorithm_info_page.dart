import 'package:flutter/material.dart';

class AlgorithmInfoPage extends StatelessWidget {
  final String algorithm;

  AlgorithmInfoPage({required this.algorithm});

  @override
  Widget build(BuildContext context) {
    String description = '';
    if (algorithm == 'Kruskal') {
      description = 'Kruskal’s algorithm is a greedy algorithm...';
    } else if (algorithm == 'Prim') {
      description = 'Prim’s algorithm is a greedy algorithm...';
    }

    return Scaffold(
      appBar: AppBar(title: Text('$algorithm\'s Algorithm Information')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(description),
      ),
    );
  }
}
