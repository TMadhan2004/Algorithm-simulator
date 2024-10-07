import 'package:flutter/material.dart';

class BellmanFordInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bellman-Ford Algorithm Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bellman-Ford Algorithm:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'The Bellman-Ford algorithm is used to find the shortest paths from a single source vertex to all other vertices in a graph. '
                    'It can handle graphs with negative weight edges, unlike Dijkstra’s algorithm. '
                    'However, it does not work if there is a negative-weight cycle in the graph (i.e., a cycle where the total weight is negative). '
                    'If such a cycle exists, the algorithm can detect it. '
                    'Bellman-Ford is slower than Dijkstra’s algorithm, but its ability to detect negative weight cycles makes it more versatile.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Steps to Find the Shortest Path Using Bellman-Ford:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                '1. Initialize distances from the source to all vertices as infinity, except for the source itself, which is initialized to 0.\n'
                    '2. Relax all edges V-1 times (V is the number of vertices).\n'
                    '   - For each edge (u, v) with weight w, if the current distance to u plus w is less than the distance to v, update the distance to v.\n'
                    '3. After V-1 relaxations, check for any edge where an update is still possible. If such an update is possible, it indicates a negative-weight cycle in the graph.\n'
                    '4. If no negative-weight cycle is found, retrieve the shortest path from the source to the destination by backtracking through the predecessors array.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Time Complexity:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'The time complexity of the Bellman-Ford algorithm is O(V * E), where V is the number of vertices and E is the number of edges.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
