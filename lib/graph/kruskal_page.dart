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
  Set<int> _includedVertices = {}; // For storing vertices in MST
  Set<String> _processedEdges = {}; // For tracking unique edges as "min,max" strings
  List<int> _parent = [];
  int _currentEdgeIndex = 0;
  bool _isRunning = false;
  bool _hasRun = false;
  String _statusMessage = '';
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _initializeEdges();
    _initializeAnimation();
  }

  void _initializeEdges() {
    Set<String> seenEdges = {}; // Track unique edges as "min,max" strings

    for (var edge in widget.adjacencyList) {
      int v1 = edge[0];
      int v2 = edge[1];
      int weight = edge[2];
      String edgeKey = '${min(v1, v2)},${max(v1, v2)}';

      if (!seenEdges.contains(edgeKey)) {
        _edges.add(Edge(v1, v2, weight));
        seenEdges.add(edgeKey);
      }
    }

    _edges.sort((a, b) => a.weight.compareTo(b.weight));
    _parent = List.generate(widget.adjacencyList.length, (index) => index);
  }

  void _initializeAnimation() {
    _controller = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _processNextEdge();
        }
      });
  }

  void _processNextEdge() {
    if (_currentEdgeIndex < _edges.length) {
      int v1 = _edges[_currentEdgeIndex].vertex1;
      int v2 = _edges[_currentEdgeIndex].vertex2;

      String edgeKey = '${min(v1, v2)},${max(v1, v2)}';

      // Check if the edge has already been processed
      if (_processedEdges.contains(edgeKey)) {
        _currentEdgeIndex++; // Skip this duplicate edge
        _processNextEdge();
        return;
      }

      if (_find(v1) != _find(v2)) {
        setState(() {
          _mst.add(_edges[_currentEdgeIndex]);
          _includedVertices.addAll({v1, v2});
          _processedEdges.add(edgeKey); // Mark edge as processed
          _union(v1, v2);
          _statusMessage = 'Added edge ($v1, $v2) to MST.';
        });
      } else {
        setState(() {
          _cycleEdges.add(_edges[_currentEdgeIndex]);
          _processedEdges.add(edgeKey); // Mark edge as processed
          _statusMessage = 'Skipped edge ($v1, $v2) to avoid a cycle.';
        });
      }

      _currentEdgeIndex++;

      if (_currentEdgeIndex < _edges.length) {
        _controller.forward(from: 0);
      } else {
        setState(() {
          _isRunning = false;
          _hasRun = true;
          _statusMessage = 'Kruskal\'s algorithm completed. MST found!';
        });
      }
    }
  }

  int _find(int vertex) {
    if (_parent[vertex] != vertex) {
      _parent[vertex] = _find(_parent[vertex]);
    }
    return _parent[vertex];
  }

  void _union(int v1, int v2) {
    int root1 = _find(v1);
    int root2 = _find(v2);
    if (root1 != root2) {
      _parent[root1] = root2;
    }
  }

  void _startKruskal() {
    setState(() {
      _isRunning = true;
      _currentEdgeIndex = 0;
      _controller.forward();
    });
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

  void _restartKruskal() {
    setState(() {
      _edges.clear();
      _mst.clear();
      _cycleEdges.clear();
      _includedVertices.clear();
      _processedEdges.clear();
      _currentEdgeIndex = 0;
      _isRunning = false;
      _hasRun = false;
      _statusMessage = '';
      _initializeEdges();
      _controller.reset();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kruskal\'s Algorithm Visualization'),
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
                painter: GraphPainter(
                  edges: _edges,
                  includedVertices: _includedVertices,
                  mst: _mst,
                  cycleEdges: _cycleEdges,
                  animationValue: _animation.value,
                  currentEdgeIndex: _currentEdgeIndex,
                ),
                child: Container(),
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.purple),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                _statusMessage,
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: (!_isRunning && !_hasRun) ? _startKruskal : null,
              child: Text(!_hasRun
                  ? 'Start Kruskal\'s Algorithm'
                  : 'Algorithm Completed'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _hasRun
          ? Padding(
        padding: const EdgeInsets.only(left: 30.0, bottom: 0.0),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: FloatingActionButton(
            onPressed: _restartKruskal,
            backgroundColor: Colors.purple,
            child: Icon(Icons.restart_alt, color: Colors.white),
          ),
        ),
      )
          : null,
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

  GraphPainter({
    required this.edges,
    required this.includedVertices,
    required this.mst,
    required this.cycleEdges,
    required this.animationValue,
    required this.currentEdgeIndex,
  });

  @override
  @override
  void paint(Canvas canvas, Size size) {
    Paint edgePaint = Paint()..color = Colors.black..strokeWidth = 2;
    Paint mstPaint = Paint()..color = Colors.green.withOpacity(0.6)..strokeWidth = 4;
    Paint cyclePaint = Paint()..color = Colors.red.withOpacity(0.6)..strokeWidth = 4;
    Paint vertexPaint = Paint()..color = Colors.blue;
    Paint currentEdgePaint = Paint()..color = Colors.orange..strokeWidth = 3;

    Map<int, Offset> vertexPositions = {};
    int vertexCount = edges.fold(0, (maxV, edge) => max(maxV, max(edge.vertex1, edge.vertex2))) + 1;
    double angleStep = 2 * pi / vertexCount;
    double radius = min(size.width, size.height) / 3;

    // Calculate positions for each vertex
    for (int i = 0; i < vertexCount; i++) {
      double angle = i * angleStep;
      vertexPositions[i] = Offset(
        size.width / 2 + radius * cos(angle),
        size.height / 2 + radius * sin(angle),
      );
    }

    // Draw all edges in black initially
    for (Edge edge in edges) {
      Offset p1 = vertexPositions[edge.vertex1]!;
      Offset p2 = vertexPositions[edge.vertex2]!;
      canvas.drawLine(p1, p2, edgePaint);

      // Draw weight label slightly above each edge
      TextSpan span = TextSpan(style: TextStyle(color: Colors.black), text: '${edge.weight}');
      TextPainter tp = TextPainter(text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
      tp.layout();

      // Offset the midpoint slightly above the line
      Offset midpoint = (p1 + p2) / 2;
      Offset labelPosition = midpoint + Offset(0, -tp.height / 2 - 15); // Move up by 5 pixels

      tp.paint(canvas, labelPosition);
    }


    // Overlay MST edges in green
    for (Edge edge in mst) {
      Offset p1 = vertexPositions[edge.vertex1]!;
      Offset p2 = vertexPositions[edge.vertex2]!;
      canvas.drawLine(p1, p2, mstPaint);
    }

    // Overlay cycle edges in red
    for (Edge edge in cycleEdges) {
      Offset p1 = vertexPositions[edge.vertex1]!;
      Offset p2 = vertexPositions[edge.vertex2]!;
      canvas.drawLine(p1, p2, cyclePaint);
    }

    // Draw the animated edge currently being processed in orange
    if (currentEdgeIndex < edges.length) {
      Edge currentEdge = edges[currentEdgeIndex];
      Offset p1 = vertexPositions[currentEdge.vertex1]!;
      Offset p2 = vertexPositions[currentEdge.vertex2]!;
      Offset animatedP2 = Offset.lerp(p1, p2, animationValue)!;
      canvas.drawLine(p1, animatedP2, currentEdgePaint);
    }

    // Draw vertices and labels
    for (var vertex in vertexPositions.keys) {
      Offset position = vertexPositions[vertex]!;
      canvas.drawCircle(position, 20, vertexPaint);
      TextSpan span = TextSpan(
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), text: '$vertex');
      TextPainter tp = TextPainter(
          text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, position - Offset(tp.width / 2, tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
