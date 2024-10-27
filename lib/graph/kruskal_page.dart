import 'package:flutter/material.dart';
import 'dart:math';
import 'kruskal_info_page.dart';
import 'kruskal_code_page.dart';

class KruskalPage extends StatefulWidget {
  final List<List<int>> adjacencyList;

  KruskalPage({required this.adjacencyList});

  @override
  _KruskalPageState createState() => _KruskalPageState();
}

class _KruskalPageState extends State<KruskalPage> with SingleTickerProviderStateMixin {
  List<Edge> _edges = [];
  List<Edge> _mst = [];
  List<Edge> _cycleEdges = [];
  Set<int> _includedVertices = {};
  List<int> _parent = [];
  int _step = 0;
  bool _isRunning = false;
  bool _hasRun = false;
  late AnimationController _controller;
  late Animation<double> _animation;
  int _currentEdgeIndex = 0;

  @override
  void initState() {
    super.initState();
    _processInput();
    _edges.sort((a, b) => a.weight.compareTo(b.weight));
    _parent = List.generate(widget.adjacencyList.length, (index) => index);
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed && _currentEdgeIndex < _edges.length) {
          _controller.reset();
          int v1 = _edges[_currentEdgeIndex].vertex1;
          int v2 = _edges[_currentEdgeIndex].vertex2;
          if (_find(v1) != _find(v2)) {
            setState(() {
              _mst.add(_edges[_currentEdgeIndex]);
              _includedVertices.add(v1);
              _includedVertices.add(v2);
              _union(v1, v2);
            });
          } else {
            setState(() {
              _cycleEdges.add(_edges[_currentEdgeIndex]);
            });
          }
          _currentEdgeIndex++;
          if (_currentEdgeIndex < _edges.length) {
            _controller.forward();
          } else {
            setState(() {
              _isRunning = false;
              _hasRun = true;
            });
          }
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
    return _parent[v] = _find(_parent[v]);
  }

  void _union(int v1, int v2) {
    _parent[_find(v1)] = _find(v2);
  }

  void _startKruskal() {
    if (_isRunning || _hasRun) return;
    setState(() {
      _isRunning = true;
    });
    _controller.forward();
  }

  void _navigateToInfoPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => KruskalInfoPage()),
    );
  }

  void _navigateToCodePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => KruskalCodePage()),
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
        title: Text('Kruskal\'s Visualization'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: CustomPaint(
                painter: GraphPainter(_edges, _includedVertices, _mst, _cycleEdges, _animation.value, _currentEdgeIndex),
                child: Container(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: (!_isRunning && !_hasRun) ? _startKruskal : null,
              child: Text(!_hasRun ? 'Start Kruskal\'s Algorithm' : 'Algorithm Completed'),
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
  final List<Edge> cycleEdges;
  final double animationValue;
  final int currentEdgeIndex;

  GraphPainter(this.edges, this.includedVertices, this.mst, this.cycleEdges, this.animationValue, this.currentEdgeIndex);

  @override
  void paint(Canvas canvas, Size size) {
    Paint edgePaint = Paint()..color = Colors.black..strokeWidth = 2;
    Paint mstPaint = Paint()..color = Colors.green..strokeWidth = 4;
    Paint cyclePaint = Paint()..color = Colors.red..strokeWidth = 4;
    Paint vertexPaint = Paint()..color = Colors.blue;

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

    for (Edge edge in edges) {
      Offset p1 = vertexPositions[edge.vertex1]!;
      Offset p2 = vertexPositions[edge.vertex2]!;
      canvas.drawLine(p1, p2, edgePaint);
      TextSpan span = TextSpan(style: TextStyle(color: Colors.black), text: '${edge.weight}');
      TextPainter tp = TextPainter(
          text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
      tp.layout();
      Offset midpoint = (p1 + p2) / 2;
      tp.paint(canvas, midpoint);
    }

    for (int i = 0; i < currentEdgeIndex && i < mst.length; i++) {
      Edge edge = mst[i];
      Offset p1 = vertexPositions[edge.vertex1]!;
      Offset p2 = vertexPositions[edge.vertex2]!;
      canvas.drawLine(p1, p2, mstPaint);
    }

    if (currentEdgeIndex < cycleEdges.length) {
      Edge cycleEdge = cycleEdges[currentEdgeIndex];
      Offset p1 = vertexPositions[cycleEdge.vertex1]!;
      Offset p2 = vertexPositions[cycleEdge.vertex2]!;
      Offset animatedP2 = Offset.lerp(p1, p2, animationValue)!;
      canvas.drawLine(p1, animatedP2, cyclePaint);
    }

    for (var vertex in vertexPositions.keys) {
      Offset position = vertexPositions[vertex]!;
      canvas.drawCircle(position, 20, vertexPaint);
      TextSpan span = TextSpan(
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), text: '$vertex');
      TextPainter tp = TextPainter(
          text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, position.translate(-tp.width / 2, -tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
