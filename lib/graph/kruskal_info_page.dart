import 'package:flutter/material.dart';

class KruskalInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kruskal\'s Algorithm Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kruskal\'s Algorithm',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Kruskal\'s algorithm is a greedy algorithm for finding the Minimum Spanning Tree (MST) of a connected, '
                    'undirected graph. It works by sorting all the edges of the graph in increasing order of their weight, and '
                    'then adding edges to the MST, one at a time, while ensuring no cycles are formed.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Steps:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                '1. Sort all edges in increasing order of their weight.\n'
                    '2. Pick the smallest edge. Check if it forms a cycle with the spanning tree formed so far. If not, add '
                    'it to the MST.\n'
                    '3. Repeat until there are (V - 1) edges in the MST.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Union-Find Algorithm:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'To efficiently check for cycles, Kruskal\'s algorithm uses the Union-Find data structure. This allows us '
                    'to quickly find which set a particular element belongs to and union two sets if they are different.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
