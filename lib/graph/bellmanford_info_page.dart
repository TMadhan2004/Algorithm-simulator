import 'package:flutter/material.dart';

class BellmanFordInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Description of Bellman-Ford Algorithm
    String description =
        'The Bellman-Ford algorithm is used to find the shortest paths from a single source vertex to all other vertices in a graph. '
        'It can handle graphs with negative weight edges, unlike Dijkstra’s algorithm. '
        'However, it does not work if there is a negative-weight cycle in the graph (i.e., a cycle where the total weight is negative). '
        'If such a cycle exists, the algorithm can detect it. '
        'Bellman-Ford is slower than Dijkstra’s algorithm, but its ability to detect negative weight cycles makes it more versatile.';

    // Steps for Bellman-Ford Algorithm
    List<String> steps = [
      'Initialize distances from the source to all vertices as infinity, except for the source itself, which is initialized to 0.',
      'Relax all edges V-1 times (V is the number of vertices). For each edge (u, v) with weight w, if the current distance to u plus w is less than the distance to v, update the distance to v.',
      'After V-1 relaxations, check for any edge where an update is still possible. If such an update is possible, it indicates a negative-weight cycle in the graph.',
      'If no negative-weight cycle is found, retrieve the shortest path from the source to the destination by backtracking through the predecessors array.',
    ];

    // Time complexities for Bellman-Ford Algorithm
    Map<String, String> timeComplexities = {
      'Best': 'O(V * E)',
      'Average': 'O(V * E)',
      'Worst': 'O(V * E)',
      'Description': 'Efficiency remains consistent across all cases.',
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('Bellman-Ford Algorithm Info'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Description
              Text(
                'Description:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple),
              ),
              SizedBox(height: 10),
              Text(
                description,
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              SizedBox(height: 20),
              // Steps
              Text(
                'Steps:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple),
              ),
              SizedBox(height: 10),
              ...steps.asMap().entries.map((entry) {
                int index = entry.key + 1; // Increment index for numbering
                String step = entry.value;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    '$index. $step',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                );
              }).toList(),
              SizedBox(height: 20),
              // Time Complexity
              Text(
                'Time Complexity:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple),
              ),
              SizedBox(height: 10),
              Table(
                border: TableBorder.all(color: Colors.purple),
                children: [
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Best',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Average',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Worst',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple)),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(timeComplexities['Best']!,
                          style: TextStyle(color: Colors.black)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(timeComplexities['Average']!,
                          style: TextStyle(color: Colors.black)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(timeComplexities['Worst']!,
                          style: TextStyle(color: Colors.black)),
                    ),
                  ]),
                ],
              ),
              SizedBox(height: 10),
              Text(
                timeComplexities['Description']!,
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
