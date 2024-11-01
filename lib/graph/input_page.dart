import 'package:flutter/material.dart';
import 'kruskal_page.dart';
import 'prim_page.dart';
import 'kruskal_info_page.dart';
import 'prim_info_page.dart';
import 'kruskal_code_page.dart'; // Import the Kruskal code page
import 'prim_code_page.dart'; // Import the Prim code page
import 'package:video_player/video_player.dart';

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
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Show disclaimer on page load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showDisclaimerDialog();
    });
  }

  void _showDisclaimerDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Disclaimer'),
          content: Text(
            "You can enter a maximum of 10 vertices, numbered from 0 to 9. Please provide the corresponding edge weights. This graph is undirected, so enter each edge only once, from one vertex to another.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _addEdge() {
    if (_formKey.currentState!.validate()) {
      int vertex1 = int.parse(vertex1Controller.text.trim());
      int vertex2 = int.parse(vertex2Controller.text.trim());
      int weight = int.parse(weightController.text.trim());

      // Check for self-loop
      if (vertex1 == vertex2) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Self-loops are not allowed!')),
        );
        return;
      }

      // Check if the vertices are within the valid range
      if (vertex1 < 0 || vertex1 > 9 || vertex2 < 0 || vertex2 > 9) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Enter vertices from 0 to 9')),
        );
        return;
      }

      // Check if the edge already exists (to avoid duplicates)
      bool edgeExists = adjacencyList.any((edge) =>
      (edge[0] == vertex1 && edge[1] == vertex2) ||
          (edge[0] == vertex2 && edge[1] == vertex1));

      if (!edgeExists) {
        // Add edges for both directions to represent undirected graph
        setState(() {
          adjacencyList.add([vertex1, vertex2, weight]);
          adjacencyList.add([vertex2, vertex1, weight]); // Undirected
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Edge already exists!')),
        );
      }

      vertex1Controller.clear();
      vertex2Controller.clear();
      weightController.clear();
    }
  }


  void _runAlgorithm() {
    if (adjacencyList.isNotEmpty) {
      _showLoadingDialog(() {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              if (widget.algorithm == 'Kruskal') {
                return KruskalPage(adjacencyList: adjacencyList);
              } else {
                return PrimsPage(adjacencyList: adjacencyList);
              }
            },
          ),
        ).then((_) {
          setState(() {
            isLoading = false; // Reset loading state when coming back
          });
        });
      });
    }
  }

  void _showLoadingDialog(VoidCallback onComplete) {
    if (!isLoading) {
      setState(() {
        isLoading = true; // Set loading state
      });
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return LoadingDialog(onComplete: () {
            Navigator.of(context).pop(); // Close dialog
            onComplete(); // Call the navigation function
          });
        },
      ).then((_) {
        setState(() {
          isLoading = false; // Reset loading state after dialog is dismissed
        });
      });
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
        title: Text('${widget.algorithm}\'s Input'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline), // Info icon
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    if (widget.algorithm == 'Kruskal') {
                      return KruskalInfoPage(); // Navigate to Kruskal info page
                    } else {
                      return PrimInfoPage(); // Navigate to Prim info page
                    }
                  },
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.code), // Code icon
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    if (widget.algorithm == 'Kruskal') {
                      return KruskalCodePage(); // Navigate to Kruskal code page
                    } else {
                      return PrimsCodePage(); // Navigate to Prim code page
                    }
                  },
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
                decoration: InputDecoration(
                  labelText: 'Enter Vertex 1',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Vertex 1';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: vertex2Controller,
                decoration: InputDecoration(
                  labelText: 'Enter Vertex 2',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Vertex 2';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: weightController,
                decoration: InputDecoration(
                  labelText: 'Enter Weight',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the weight';
                  }
                  return null;
                },
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
              Expanded(
                child: ListView.builder(
                  itemCount: adjacencyList.length ~/ 2, // Only show unique edges
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('Edge: ${adjacencyList[index * 2][0]} - ${adjacencyList[index * 2][1]}'),
                      subtitle: Text('Weight: ${adjacencyList[index * 2][2]}'),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: _runAlgorithm,
                child: Text('Run ${widget.algorithm} Algorithm'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Loading dialog implementation
class LoadingDialog extends StatefulWidget {
  final Function onComplete;

  const LoadingDialog({Key? key, required this.onComplete}) : super(key: key);

  @override
  _LoadingDialogState createState() => _LoadingDialogState();
}

class _LoadingDialogState extends State<LoadingDialog> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/loading.mov')
      ..initialize().then((_) {
        setState(() {
          _controller.setLooping(false); // Play once
          _controller.play(); // Start video playback
        });

        // After 3 seconds, complete the loading and navigate
        Future.delayed(Duration(seconds: 3), () {
          widget.onComplete(); // Call the navigation function
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.0),
      ),
      backgroundColor: Colors.white,
      child: Container(
        width: 200,
        height: 200,
        child: Center(
          child: _controller.value.isInitialized
              ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
              : CircularProgressIndicator(), // Show a loader while the video initializes
        ),
      ),
    );
  }
}
