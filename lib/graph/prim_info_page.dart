import 'package:flutter/material.dart';

class PrimInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Description of Prim's Algorithm
    String description =
        'Prim’s algorithm is a greedy algorithm that finds a minimum spanning tree for a weighted undirected graph. '
        'The algorithm builds the spanning tree one vertex at a time, from an arbitrary starting vertex, at each step '
        'adding the cheapest possible connection from the tree to another vertex.';

    // Steps for Prim's Algorithm
    List<String> steps = [
      'Initialize a minimum spanning tree with a single vertex, chosen arbitrarily.',
      'While there are vertices not in the tree, add the cheapest edge from the tree to a vertex outside the tree.',
      'Repeat until all vertices are included in the minimum spanning tree.',
    ];

    // Time complexities for Prim's Algorithm
    Map<String, String> timeComplexities = {
      'Best': 'O(E log V)',
      'Average': 'O(E log V)',
      'Worst': 'O(E log V)',
      'Description': 'Efficiency depends on the priority queue implementation.',
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('Prim\'s Algorithm Information'),
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
