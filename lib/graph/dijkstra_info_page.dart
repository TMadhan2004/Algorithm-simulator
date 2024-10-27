import 'package:flutter/material.dart';

class DijkstraInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Description of Dijkstra's Algorithm
    String description =
        'Dijkstra\'s algorithm is a graph search algorithm that solves the single-source shortest path problem for a graph '
        'with non-negative edge weights. It finds the shortest path from a starting node to all other nodes in the graph.';

    // Steps for Dijkstra's Algorithm
    List<String> steps = [
      'Initialize the distances from the source node to all other nodes as infinity, except for the source node itself, which is set to zero.',
      'Create a set of unvisited nodes.',
      'For the current node, consider all its unvisited neighbors and calculate their tentative distances.',
      'Update the neighbor nodes if the calculated distance is less than the previously known distance.',
      'Once all neighbors are considered, mark the current node as visited.',
      'Repeat until all nodes are visited or the shortest path to the destination is found.',
    ];

    // Time complexities for Dijkstra's Algorithm
    Map<String, String> timeComplexities = {
      'Best': 'O(E + V log V)',
      'Average': 'O(E + V log V)',
      'Worst': 'O(E + V log V)',
      'Description': 'Efficiency depends on the priority queue implementation.',
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('Dijkstra\'s Algorithm Info'),
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
