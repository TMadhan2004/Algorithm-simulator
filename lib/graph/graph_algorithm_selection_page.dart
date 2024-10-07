import 'package:flutter/material.dart';
import 'input_page.dart'; // Existing for Kruskal and Prim
import 'graph_input_page.dart'; // Combined input page for Dijkstra and Bellman-Ford

class GraphAlgorithmSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Graph Algorithm")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => KruskalInputPage(algorithm: 'Kruskal'),
                  ),
                );
              },
              child: Text('Kruskal\'s Algorithm'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => KruskalInputPage(algorithm: 'Prim'),
                  ),
                );
              },
              child: Text('Prim\'s Algorithm'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GraphInputPage(algorithm: 'Dijkstra'),
                  ),
                );
              },
              child: Text('Dijkstra\'s Algorithm'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GraphInputPage(algorithm: 'Bellman-Ford'),
                  ),
                );
              },
              child: Text('Bellman-Ford Algorithm'),
            ),
          ],
        ),
      ),
    );
  }
}
