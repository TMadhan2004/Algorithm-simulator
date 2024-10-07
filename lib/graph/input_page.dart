import 'package:flutter/material.dart';
import 'kruskal_page.dart';
import 'prim_page.dart';
import 'algorithm_info_page.dart';

class KruskalInputPage extends StatefulWidget {
  final String algorithm;
  KruskalInputPage({required this.algorithm});

  @override
  _KruskalInputPageState createState() => _KruskalInputPageState();
}

class _KruskalInputPageState extends State<KruskalInputPage> {
  List<List<int>> adjacencyList = [];
  final _formKey = GlobalKey<FormState>();
  final TextEditingController vertex1Controller = TextEditingController();
  final TextEditingController vertex2Controller = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  void _addEdge() {
    if (_formKey.currentState!.validate()) {
      List<int> edge = [
        int.parse(vertex1Controller.text.trim()),
        int.parse(vertex2Controller.text.trim()),
        int.parse(weightController.text.trim())
      ];
      setState(() {
        adjacencyList.add(edge);
      });
      vertex1Controller.clear();
      vertex2Controller.clear();
      weightController.clear();
    }
  }

  @override
  void dispose() {
    vertex1Controller.dispose();
    vertex2Controller.dispose();
    weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Graph as Adjacency List (${widget.algorithm})'),
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AlgorithmInfoPage(algorithm: widget.algorithm),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: vertex1Controller,
                decoration: InputDecoration(labelText: 'Enter Vertex 1'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Vertex 1';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),  // Added space between the input fields
              TextFormField(
                controller: vertex2Controller,
                decoration: InputDecoration(labelText: 'Enter Vertex 2'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Vertex 2';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),  // Added space between the input fields
              TextFormField(
                controller: weightController,
                decoration: InputDecoration(labelText: 'Enter Weight'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the weight';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),  // Added space after weight input field
              ElevatedButton(
                onPressed: _addEdge,
                child: Text('Add Edge'),
              ),
              SizedBox(height: 16),  // Added space before the list of edges
              Expanded(
                child: ListView.builder(
                  itemCount: adjacencyList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('Edge: ${adjacencyList[index][0]} - ${adjacencyList[index][1]}'),
                      subtitle: Text('Weight: ${adjacencyList[index][2]}'),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (adjacencyList.isNotEmpty) {
                    if (widget.algorithm == 'Kruskal') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => KruskalPage(adjacencyList: adjacencyList),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PrimPage(adjacencyList: adjacencyList),
                        ),
                      );
                    }
                  }
                },
                child: Text('Run ${widget.algorithm} Algorithm'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
