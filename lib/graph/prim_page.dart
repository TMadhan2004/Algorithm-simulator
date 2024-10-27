import 'package:flutter/material.dart';
import 'dart:math';
import 'prim_info_page.dart';
import 'prim_code_page.dart';

class PrimPage extends StatefulWidget {
  final List<List<int>> adjacencyList;

  PrimPage({required this.adjacencyList});

  @override
  _PrimPageState createState() => _PrimPageState();
}

class _PrimPageState extends State<PrimPage> with SingleTickerProviderStateMixin {
  List<Edge> _edges = [];
  List<Edge> _mst = [];
  Set<int> _includedVertices = {0}; // Start with vertex 0
  List<int> _parent = [];
  int _step = 0;
  bool _isRunning = false;
  late AnimationController _controller;
  late Animation<double> _animation;
  String _statusText = 'Start Prim\'s Algorithm';

  @override
  void initState() {
    super.initState();
    _processInput();
    _edges.sort((a, b) => a.weight.compareTo(b.weight));
    _parent = List.generate(widget.adjacencyList.length, (index) => index);

    _controller = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  void _processInput() {
    for (var edge in widget.adjacencyList) {
      _edges.add(Edge(edge[0], edge[1], edge[2]));
    }
  }

  Future<void> _startPrim() async {
    if (_isRunning) return;
    setState(() {
      _isRunning = true;
      _statusText = 'Running...';
    });

    while (_step < _edges.length && _mst.length < widget.adjacencyList.length - 1) {
      Edge edge = _edges[_step];

      // Check if the edge connects an included vertex to an excluded vertex
      if ((_includedVertices.contains(edge.vertex1) && !_includedVertices.contains(edge.vertex2)) ||
          (_includedVertices.contains(edge.vertex2) && !_includedVertices.contains(edge.vertex1))) {

        setState(() {
          _mst.add(edge);
          _includedVertices.add(edge.vertex1);
          _includedVertices.add(edge.vertex2);
        });

        // Animate each edge addition
        _controller.reset();
        await _controller.forward();
        await Future.delayed(Duration(seconds: 2)); // Delay 2 seconds between each edge
      }

      _step++;
    }

    setState(() {
      _isRunning = false;
      _statusText = 'Algorithm Completed';
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
        title: Text('Prim\'s Visualization'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PrimInfoPage(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.code),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PrimsCodePage(),
                ),
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
                painter: GraphPainter(_edges, _includedVertices, _mst, _animation.value),
                child: Container(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isRunning ? null : _startPrim,
              child: Text(_statusText),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
              ),
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

  GraphPainter(this.edges, this.includedVertices, this.mst, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    Paint edgePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2;
    Paint mstPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 4;
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
      TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      Offset midpoint = (p1 + p2) / 2;
      tp.paint(canvas, midpoint);
    }

    // Draw MST edges (in green) with animation
    for (int i = 0; i < mst.length; i++) {
      Edge edge = mst[i];
      Offset p1 = vertexPositions[edge.vertex1]!;
      Offset p2 = vertexPositions[edge.vertex2]!;

      // Gradually draw edges during animation
      Offset animatedP2 = Offset.lerp(p1, p2, animationValue)!;
      canvas.drawLine(p1, animatedP2, mstPaint);
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
