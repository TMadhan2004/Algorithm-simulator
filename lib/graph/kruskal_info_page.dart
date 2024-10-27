import 'package:flutter/material.dart';

class KruskalInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Description of Kruskal's Algorithm
    String description =
        'Kruskal\'s algorithm is a greedy algorithm for finding the Minimum Spanning Tree (MST) of a connected, '
        'undirected graph. It works by sorting all the edges of the graph in increasing order of their weight, and '
        'then adding edges to the MST, one at a time, while ensuring no cycles are formed.';

    // Steps for Kruskal's Algorithm
    List<String> steps = [
      'Sort all edges in increasing order of their weight.',
      'Pick the smallest edge. Check if it forms a cycle with the spanning tree formed so far. If not, add it to the MST.',
      'Repeat until there are (V - 1) edges in the MST.',
    ];

    // Time complexities for Kruskal's Algorithm
    Map<String, String> timeComplexities = {
      'Best': 'O(E log E)',
      'Average': 'O(E log E)',
      'Worst': 'O(E log E)',
      'Description': 'Efficiency primarily depends on the sorting of edges.',
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('Kruskal\'s Algorithm Info'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Description
            Text(
              'Description:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            SizedBox(height: 5),
            Text(
              description,
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            SizedBox(height: 20),
            // Steps
            Text(
              'Steps:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            SizedBox(height: 10),
            ...steps.asMap().entries.map((entry) {
              int index = entry.key + 1; // Increment index for numbering
              String step = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  '$index. $step',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              );
            }).toList(),
            SizedBox(height: 20),
            // Time Complexity
            Text(
              'Time Complexity:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            SizedBox(height: 10),
            Table(
              border: TableBorder.all(color: Colors.purple),
              children: [
                TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Best',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Average',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Worst',
                        style: TextStyle(fontWeight: FontWeight.bold)),
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
    );
  }
}
