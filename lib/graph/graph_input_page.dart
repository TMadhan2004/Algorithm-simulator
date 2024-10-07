import 'package:flutter/material.dart';
import 'bellmanford_page.dart';
import 'dijkstra_page.dart';

class GraphInputPage extends StatefulWidget {
  final String algorithm;

  GraphInputPage({required this.algorithm});

  @override
  _GraphInputPageState createState() => _GraphInputPageState();
}

class _GraphInputPageState extends State<GraphInputPage> {
  List<List<int>> _edges = [];
  final _sourceController = TextEditingController();
  final _destinationController = TextEditingController();
  final _vertex1Controller = TextEditingController();
  final _vertex2Controller = TextEditingController();
  final _weightController = TextEditingController();

  void _addEdge() {
    final vertex1 = int.tryParse(_vertex1Controller.text);
    final vertex2 = int.tryParse(_vertex2Controller.text);
    final weight = int.tryParse(_weightController.text);

    if (vertex1 != null && vertex2 != null && weight != null) {
      setState(() {
        _edges.add([vertex1, vertex2, weight]);
      });
      _vertex1Controller.clear();
      _vertex2Controller.clear();
      _weightController.clear();
    }
  }

  void _navigateToAlgorithmPage() {
    final source = int.tryParse(_sourceController.text);
    final destination = int.tryParse(_destinationController.text);

    if (source != null && destination != null) {
      if (widget.algorithm == 'Bellman-Ford') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BellmanFordPage(
              edges: _edges,
              source: source,
              destination: destination,
            ),
          ),
        );
      } else if (widget.algorithm == 'Dijkstra') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DijkstraPage(
              edges: _edges,
              source: source,
              destination: destination,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.algorithm} Input')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _vertex1Controller,
                decoration: InputDecoration(
                  labelText: 'Vertex 1',
                  contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _vertex2Controller,
                decoration: InputDecoration(
                  labelText: 'Vertex 2',
                  contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _weightController,
                decoration: InputDecoration(
                  labelText: 'Weight',
                  contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addEdge,
                child: Text('Add Edge'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _sourceController,
                decoration: InputDecoration(
                  labelText: 'Source Vertex',
                  contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _destinationController,
                decoration: InputDecoration(
                  labelText: 'Destination Vertex',
                  contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _navigateToAlgorithmPage,
                child: Text('Run ${widget.algorithm} Algorithm'),
              ),
              SizedBox(height: 20),
              Text('Edges:'),
              SizedBox(height: 10),
              Container(
                height: 150,
                child: ListView.builder(
                  itemCount: _edges.length,
                  itemBuilder: (context, index) {
                    final edge = _edges[index];
                    return ListTile(
                      title: Text('(${edge[0]}, ${edge[1]}) -> Weight: ${edge[2]}'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}
