import 'package:flutter/material.dart';
import 'dart:math';
import 'bellmanford_info_page.dart';
import 'bellmanford_code_page.dart'; // Import the Bellman-Ford code page

class BellmanFordPage extends StatefulWidget {
  final List<List<int>> edges;
  final int source;
  final int destination;

  BellmanFordPage({required this.edges, required this.source, required this.destination});

  @override
  _BellmanFordPageState createState() => _BellmanFordPageState();
}

class _BellmanFordPageState extends State<BellmanFordPage> with SingleTickerProviderStateMixin {
  late List<int> _distances;
  late List<int> _previous;
  late List<int> _path;
  bool _pathFound = false;
  bool _isRunning = false;
  int _currentEdgeIndex = 0;
  int _currentIteration = 0;
  int _totalIterations = 0;
  bool _negativeCycleDetected = false;

  @override
  void initState() {
    super.initState();
    _runBellmanFord();
  }

  void _runBellmanFord() async {
    int numVertices = widget.edges.fold(0, (maxVertex, edge) => max(maxVertex, max(edge[0], edge[1]))) + 1;
    _distances = List.filled(numVertices, double.maxFinite.toInt());
    _previous = List.filled(numVertices, -1);
    _path = [];
    _distances[widget.source] = 0;

    _totalIterations = numVertices - 1;

    // Relax edges repeatedly with animation for each iteration
    for (int i = 0; i < _totalIterations; i++) {
      setState(() {
        _currentIteration = i + 1;
      });
      for (var edge in widget.edges) {
        int u = edge[0];
        int v = edge[1];
        int weight = edge[2];
        if (_distances[u] != double.maxFinite.toInt() && _distances[u] + weight < _distances[v]) {
          setState(() {
            _distances[v] = _distances[u] + weight;
            _previous[v] = u;
          });
        }
      }
      await Future.delayed(Duration(seconds: 4)); // Delay to show each iteration
    }

    // Check for negative weight cycles after all iterations
    for (var edge in widget.edges) {
      int u = edge[0];
      int v = edge[1];
      int weight = edge[2];
      if (_distances[u] != double.maxFinite.toInt() && _distances[u] + weight < _distances[v]) {
        setState(() {
          _pathFound = false;
          _negativeCycleDetected = true; // Negative cycle detected
        });
        return;
      }
    }

    // If no negative cycle was detected, build the path
    setState(() {
      _pathFound = true;
      _buildPath();
    });
  }

  void _animatePath() async {
    _isRunning = true;
    for (int i = 0; i < _path.length - 1; i++) {
      setState(() {
        _currentEdgeIndex = i;
      });
      await Future.delayed(Duration(seconds: 2)); // Set delay to 2 seconds
    }
    _isRunning = false;
  }

  void _buildPath() {
    int current = widget.destination;
    while (current != -1) {
      _path.insert(0, current);
      current = _previous[current];
    }
    _animatePath();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bellman-Ford Animation'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BellmanFordInfoPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.code),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BellmanFordCodePage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Iteration $_currentIteration of $_totalIterations',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              flex: 2,
              child: CustomPaint(
                painter: GraphPainter(widget.edges, _path, _currentEdgeIndex),
                child: Container(),
              ),
            ),
            SizedBox(height: 20),
            _buildTable(),
            SizedBox(height: 20),
            Text('Shortest path from ${widget.source} to ${widget.destination}:'),
            SizedBox(height: 20),
            Text(
              _pathFound && !_negativeCycleDetected ? _path.join(' -> ') : '',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              _negativeCycleDetected
                  ? 'Negative weight cycle detected'
                  : _pathFound
                  ? 'Total distance: ${_distances[widget.destination] != double.maxFinite.toInt() ? _distances[widget.destination] : 'Infinity'}'
                  : '',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTable() {
    return Column(
      children: [
        Table(
          border: TableBorder.all(),
          children: [
            TableRow(
              decoration: BoxDecoration(color: Colors.grey.shade300),
              children: [
                TableCell(child: Padding(padding: EdgeInsets.all(8.0), child: Text('Node'))),
                TableCell(child: Padding(padding: EdgeInsets.all(8.0), child: Text('Shortest Distance'))),
                TableCell(child: Padding(padding: EdgeInsets.all(8.0), child: Text('Previous Node'))),
              ],
            ),
            for (int i = 0; i < _distances.length; i++)
              TableRow(
                children: [
                  TableCell(child: Padding(padding: EdgeInsets.all(8.0), child: Text('$i'))),
                  TableCell(child: Padding(padding: EdgeInsets.all(8.0), child: Text('${_distances[i] == double.maxFinite.toInt() ? 'INF' : _distances[i]}'))),
                  TableCell(child: Padding(padding: EdgeInsets.all(8.0), child: Text('${_previous[i] == -1 ? 'None' : _previous[i]}'))),
                ],
              ),
          ],
        ),
      ],
    );
  }
}

class GraphPainter extends CustomPainter {
  final List<List<int>> edges;
  final List<int> path;
  final int currentEdgeIndex;

  GraphPainter(this.edges, this.path, this.currentEdgeIndex);

  @override
  void paint(Canvas canvas, Size size) {
    Paint edgePaint = Paint()..color = Colors.black..strokeWidth = 2;
    Paint pathPaint = Paint()..color = Colors.green..strokeWidth = 4;
    Paint vertexPaint = Paint()..color = Colors.blue;
    Paint vertexTextPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Define positions for the vertices dynamically
    Map<int, Offset> vertexPositions = {};
    int vertexCount = edges.fold(0, (currentMax, edge) => max(currentMax, max(edge[0], edge[1]))) + 1;
    double angleStep = 2 * pi / vertexCount;
    double radius = min(size.width, size.height) / 3;

    for (int i = 0; i < vertexCount; i++) {
      double angle = i * angleStep;
      vertexPositions[i] = Offset(
        size.width / 2 + radius * cos(angle),
        size.height / 2 + radius * sin(angle),
      );
    }

    // Draw edges (original graph)
    for (var edge in edges) {
      Offset p1 = vertexPositions[edge[0]]!;
      Offset p2 = vertexPositions[edge[1]]!;

      // Draw the edge
      canvas.drawLine(p1, p2, edgePaint);

      // Label the weight
      TextSpan span = TextSpan(style: TextStyle(color: Colors.black), text: '${edge[2]}');
      TextPainter tp = TextPainter(text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
      tp.layout();
      Offset midpoint = (p1 + p2) / 2;
      tp.paint(canvas, midpoint);
    }

    // Draw path edges (in green) up to the current edge index
    for (int i = 0; i <= currentEdgeIndex && i < path.length - 1; i++) {
      Offset p1 = vertexPositions[path[i]]!;
      Offset p2 = vertexPositions[path[i + 1]]!;
      canvas.drawLine(p1, p2, pathPaint);
    }

    // Draw vertices
    vertexPositions.forEach((index, position) {
      canvas.drawCircle(position, 16, vertexPaint);
      TextSpan span = TextSpan(style: TextStyle(color: Colors.white), text: '$index');
      TextPainter tp = TextPainter(text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, position - Offset(tp.width / 2, tp.height / 2));
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
