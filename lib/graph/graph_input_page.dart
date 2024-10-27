import 'package:flutter/material.dart';
import 'bellmanford_page.dart';
import 'dijkstra_page.dart';
import 'dijkstra_info_page.dart';
import 'bellmanford_info_page.dart';
import 'dijkstra_code_page.dart'; // Import Dijkstra code page
import 'bellmanford_code_page.dart'; // Import Bellman-Ford code page

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

  @override
  void initState() {
    super.initState();
    // Show disclaimer popup when the page is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showDisclaimerDialog();
    });
  }

  void _showDisclaimerDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Disclaimer'),
        content: Text(
          'Only 10 vertices are allowed, numbered from 0 to 9. '
              'Additionally, only directed graphs are supported. '
              'Please ensure you follow these restrictions while adding edges.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _addEdge() {
    final vertex1 = int.tryParse(_vertex1Controller.text);
    final vertex2 = int.tryParse(_vertex2Controller.text);
    final weight = int.tryParse(_weightController.text);

    // Validate vertices and weight
    if (vertex1 == null || vertex2 == null || weight == null) {
      _showErrorMessage('Please enter valid integer values for the vertices and weight.');
      return;
    }
    if (vertex1 < 0 || vertex1 > 9 || vertex2 < 0 || vertex2 > 9) {
      _showErrorMessage('Vertex values must be between 0 and 9.');
      return;
    }
    if (vertex1 == vertex2) {
      _showErrorMessage('Self-loops are not allowed.');
      return;
    }
    if (_edges.any((edge) => edge[0] == vertex1 && edge[1] == vertex2) ||
        _edges.any((edge) => edge[0] == vertex2 && edge[1] == vertex1)) {
      _showErrorMessage('Duplicate or reverse edges are not allowed.');
      return;
    }

    // Add the edge
    setState(() {
      _edges.add([vertex1, vertex2, weight]);
    });
    _vertex1Controller.clear();
    _vertex2Controller.clear();
    _weightController.clear();
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message)
      ),
    );
  }

  void _navigateToAlgorithmPage() {
    final source = int.tryParse(_sourceController.text);
    final destination = int.tryParse(_destinationController.text);

    if (source == null || destination == null || source < 0 || source > 9 || destination < 0 || destination > 9) {
      _showErrorMessage('Source and destination vertices must be between 0 and 9.');
      return;
    }

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

  void _navigateToInfoPage() {
    if (widget.algorithm == 'Bellman-Ford') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BellmanFordInfoPage()),
      );
    } else if (widget.algorithm == 'Dijkstra') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DijkstraInfoPage()),
      );
    }
  }

  void _navigateToCodePage() {
    if (widget.algorithm == 'Bellman-Ford') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BellmanFordCodePage()),
      );
    } else if (widget.algorithm == 'Dijkstra') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DijkstraCodePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.algorithm} Input'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: _navigateToInfoPage,
          ),
          IconButton(
            icon: Icon(Icons.code),
            onPressed: _navigateToCodePage,
          ),
        ],
      ),
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
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _vertex2Controller,
                decoration: InputDecoration(
                  labelText: 'Vertex 2',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _weightController,
                decoration: InputDecoration(
                  labelText: 'Weight',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addEdge,
                child: Text('Add Edge'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _sourceController,
                decoration: InputDecoration(
                  labelText: 'Source Vertex',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _destinationController,
                decoration: InputDecoration(
                  labelText: 'Destination Vertex',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _navigateToAlgorithmPage,
                child: Text('Run ${widget.algorithm} Algorithm'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white
                ),
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
