import 'package:flutter/material.dart';

class DijkstraInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dijkstra\'s Algorithm Info')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dijkstra\'s Algorithm',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Description:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Dijkstra\'s algorithm is a graph search algorithm that solves the single-source shortest path problem for a graph with non-negative edge weights. It finds the shortest path from a starting node to all other nodes in the graph.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Steps:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '1. Initialize the distances from the source node to all other nodes as infinity, except for the source node itself, which is set to zero.\n'
                    '2. Create a set of unvisited nodes.\n'
                    '3. For the current node, consider all its unvisited neighbors and calculate their tentative distances.\n'
                    '4. Update the neighbor nodes if the calculated distance is less than the previously known distance.\n'
                    '5. Once all neighbors are considered, mark the current node as visited.\n'
                    '6. Repeat until all nodes are visited or the shortest path to the destination is found.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Complexity:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'The time complexity of Dijkstra\'s algorithm is O(E + V log V), where E is the number of edges and V is the number of vertices in the graph.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
