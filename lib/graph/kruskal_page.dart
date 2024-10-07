import 'package:flutter/material.dart';
import 'dart:math';
import 'kruskal_info_page.dart';

class KruskalPage extends StatefulWidget {
  final List<List<int>> adjacencyList;

  KruskalPage({required this.adjacencyList});

  @override
  _KruskalPageState createState() => _KruskalPageState();
}

class _KruskalPageState extends State<KruskalPage> with SingleTickerProviderStateMixin {
  List<Edge> _edges = [];
  List<Edge> _mst = [];
  Set<int> _includedVertices = {};
  List<int> _parent = [];
  int _step = 0;
  bool _isRunning = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  int _currentEdgeIndex = 0; // Keep track of which edge is being animated

  @override
  void initState() {
    super.initState();
    _processInput();
    _edges.sort((a, b) => a.weight.compareTo(b.weight)); // Sort edges by weight
    _parent = List.generate(widget.adjacencyList.length, (index) => index); // Union-Find parent list

    // Animation controller for edge animation
    _controller = AnimationController(
      duration: Duration(milliseconds: 3000),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed && _currentEdgeIndex < _mst.length) {
          _currentEdgeIndex++; // Move to the next edge
          _controller.reset(); // Reset animation
          _controller.forward(); // Start animating the next edge
        }
      });
  }

  void _processInput() {
    for (var edge in widget.adjacencyList) {
      _edges.add(Edge(edge[0], edge[1], edge[2]));
    }
  }

  int _find(int v) {
    if (_parent[v] == v) return v;
    return _parent[v] = _find(_parent[v]); // Path compression
  }

  void _union(int v1, int v2) {
    _parent[_find(v1)] = _find(v2); // Union the two sets
  }

  void _startKruskal() {
    if (_isRunning) return; // Prevent restarting the algorithm
    _isRunning = true;

    Future.doWhile(() async {
      if (_step < _edges.length && _mst.length < widget.adjacencyList.length - 1) {
        Edge edge = _edges[_step];
        if (_find(edge.vertex1) != _find(edge.vertex2)) {
          setState(() {
            _mst.add(edge); // Add edge to MST
            _includedVertices.add(edge.vertex1);
            _includedVertices.add(edge.vertex2);
          });
          _union(edge.vertex1, edge.vertex2);
        }
        _step++;
        _controller.reset();
        await _controller.forward(); // Animate edge addition
        await Future.delayed(Duration(milliseconds: 500)); // Delay before next edge
        return true;
      } else {
        setState(() {
          _isRunning = false;
        });
        return false;
      }
    });
  }

  void _navigateToInfoPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => KruskalInfoPage()), // Change to appropriate route
    );
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
        title: Text('Kruskal\'s Algorithm Animation'),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: _navigateToInfoPage, // Navigate to info page
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
                painter: GraphPainter(_edges, _includedVertices, _mst, _animation.value, _currentEdgeIndex),
                child: Container(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isRunning ? null : _startKruskal,
              child: Text(_isRunning ? 'Running...' : 'Start Kruskal\'s Algorithm'),
            ),
          ],
        ),
      ),
    );
  }
}

class Edge {
  final int vertex1;
  final int vertex2;
  final int weight;

  Edge(this.vertex1, this.vertex2, this.weight);
}

class GraphPainter extends CustomPainter {
  final List<Edge> edges;
  final Set<int> includedVertices;
  final List<Edge> mst;
  final double animationValue;
  final int currentEdgeIndex;

  GraphPainter(this.edges, this.includedVertices, this.mst, this.animationValue, this.currentEdgeIndex);

  @override
  void paint(Canvas canvas, Size size) {
    Paint edgePaint = Paint()..color = Colors.black..strokeWidth = 2;
    Paint mstPaint = Paint()..color = Colors.green..strokeWidth = 4;
    Paint vertexPaint = Paint()..color = Colors.blue;
    Paint vertexTextPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Define positions for the vertices dynamically
    Map<int, Offset> vertexPositions = {};
    int vertexCount = edges.fold(0, (currentMax, edge) => max(currentMax, max(edge.vertex1, edge.vertex2))) + 1;
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
    for (Edge edge in edges) {
      Offset p1 = vertexPositions[edge.vertex1]!;
      Offset p2 = vertexPositions[edge.vertex2]!;

      // Draw the edge
      canvas.drawLine(p1, p2, edgePaint);

      // Label the weight
      TextSpan span = TextSpan(style: TextStyle(color: Colors.black), text: '${edge.weight}');
      TextPainter tp = TextPainter(text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
      tp.layout();
      Offset midpoint = (p1 + p2) / 2;
      tp.paint(canvas, midpoint);
    }

    // Draw MST edges (in green)
    for (int i = 0; i <= currentEdgeIndex && i < mst.length; i++) {
      Edge edge = mst[i];
      Offset p1 = vertexPositions[edge.vertex1]!;
      Offset p2 = vertexPositions[edge.vertex2]!;

      // Gradually draw edges during animation (for the current edge)
      if (i == currentEdgeIndex) {
        Offset animatedP2 = Offset.lerp(p1, p2, animationValue)!;
        canvas.drawLine(p1, animatedP2, mstPaint);
      } else {
        canvas.drawLine(p1, p2, mstPaint); // Already drawn edges
      }
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
