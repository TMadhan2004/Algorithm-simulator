import 'package:flutter/material.dart';
import 'dart:math';
import 'dijkstra_info_page.dart';

class DijkstraPage extends StatefulWidget {
  final List<List<int>> edges;
  final int source;
  final int destination;

  DijkstraPage({required this.edges, required this.source, required this.destination});

  @override
  _DijkstraPageState createState() => _DijkstraPageState();
}

class _DijkstraPageState extends State<DijkstraPage> with SingleTickerProviderStateMixin {
  late List<int> _distances;
  late List<int> _previous;
  late List<int> _path;
  late AnimationController _controller;
  bool _pathFound = false;
  bool _isRunning = false;
  int _currentEdgeIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 3000),
      vsync: this,
    )..addListener(() {
      setState(() {});
    });
    _runDijkstra();
  }

  void _runDijkstra() {
    int numVertices = widget.edges.fold(0, (maxVertex, edge) => max(maxVertex, max(edge[0], edge[1]))) + 1;
    _distances = List.filled(numVertices, double.maxFinite.toInt());
    _previous = List.filled(numVertices, -1);
    _path = [];

    Set<int> unvisited = Set<int>.from(List.generate(numVertices, (index) => index));
    _distances[widget.source] = 0;

    Future.doWhile(() async {
      if (unvisited.isNotEmpty) {
        int current = _getClosestVertex(unvisited);
        unvisited.remove(current);

        if (_distances[current] == double.maxFinite.toInt()) return false;

        for (var edge in widget.edges) {
          if (edge[0] == current || edge[1] == current) {
            int neighbor = edge[0] == current ? edge[1] : edge[0];
            int weight = edge[2];

            int newDist = _distances[current] + weight;
            if (newDist < _distances[neighbor]) {
              setState(() {
                _distances[neighbor] = newDist;
                _previous[neighbor] = current;
              });
            }
          }
        }

        await Future.delayed(Duration(milliseconds: 500));
        return true;
      } else {
        _buildPath();
        return false;
      }
    });
  }

  int _getClosestVertex(Set<int> unvisited) {
    int minDist = double.maxFinite.toInt();
    int closestVertex = -1;

    for (int vertex in unvisited) {
      if (_distances[vertex] < minDist) {
        minDist = _distances[vertex];
        closestVertex = vertex;
      }
    }

    return closestVertex;
  }

  void _buildPath() {
    int current = widget.destination;

    while (current != -1) {
      _path.insert(0, current);
      current = _previous[current];
    }

    setState(() {
      _animatePath();
    });
  }

  void _animatePath() async {
    _isRunning = true;
    for (int i = 0; i < _path.length - 1; i++) {
      setState(() {
        _currentEdgeIndex = i;
      });
      await Future.delayed(Duration(seconds: 1));
    }
    _isRunning = false;

    // After the path animation completes, display the path and total distance
    setState(() {
      _pathFound = true;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dijkstra\'s Algorithm Animation'),
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DijkstraInfoPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: CustomPaint(
                painter: GraphPainter(widget.edges, _path, _currentEdgeIndex),
                child: Container(),
              ),
            ),
            SizedBox(height: 20),
            Text('Shortest path from ${widget.source} to ${widget.destination}:'),
            SizedBox(height: 20),
            Text(
              _pathFound ? _path.join(' -> ') : '',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              _pathFound
                  ? 'Total distance: ${_distances[widget.destination] != double.maxFinite.toInt() ? _distances[widget.destination] : 'Infinity'}'
                  : '',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
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
      int vertex1 = path[i];
      int vertex2 = path[i + 1];
      Offset p1 = vertexPositions[vertex1]!;
      Offset p2 = vertexPositions[vertex2]!;

      canvas.drawLine(p1, p2, pathPaint);
    }

    // Draw vertices
    for (var vertex in vertexPositions.keys) {
      Offset position = vertexPositions[vertex]!;
      canvas.drawCircle(position, 20, vertexPaint);

      // Label vertices
      TextSpan span = TextSpan(style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), text: '$vertex');
      TextPainter tp = TextPainter(text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, position - Offset(tp.width / 2, tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Repaint on every frame to animate the edges
  }
}
