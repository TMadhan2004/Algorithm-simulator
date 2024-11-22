import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ComparisonPage extends StatefulWidget {
  final List<String> selectedAlgorithms;
  final List<int> numbers;
  final int target;
  final double speed;

  ComparisonPage({
    required this.selectedAlgorithms,
    required this.numbers,
    required this.target,
    this.speed = 500,
  });

  @override
  _ComparisonPageState createState() => _ComparisonPageState();
}

class _ComparisonPageState extends State<ComparisonPage> {
  late Map<String, List<int>> _searchResults;

  @override
  void initState() {
    super.initState();
    _searchResults = {};
    _runComparisons();
  }

  Future<void> _runComparisons() async {
    for (String algorithm in widget.selectedAlgorithms) {
      List<int> result = await _searchWithAlgorithm(algorithm);
      setState(() {
        _searchResults[algorithm] = result;
      });
    }
  }

  Future<List<int>> _searchWithAlgorithm(String algorithm) async {
    List<int> input = List.from(widget.numbers);
    List<int> steps =
        List.filled(input.length, 0); // Track the number of comparisons

    switch (algorithm) {
      case 'Linear Search':
        await _linearSearch(input, widget.target, steps);
        break;
      case 'Binary Search':
        await _binarySearch(input, widget.target, steps, 0, input.length - 1);
        break;
      case 'Hashing':
        await _hashingSearch(input, widget.target, steps);
        break;
    }

    return steps;
  }

  Future<void> _linearSearch(List<int> arr, int target, List<int> steps) async {
    for (int i = 0; i < arr.length; i++) {
      steps[i]++; // Increment the comparison count
      await Future.delayed(Duration(milliseconds: widget.speed.toInt()));
      if (arr[i] == target) {
        break; // Target found, exit the loop
      }
    }
  }

  Future<void> _binarySearch(
      List<int> arr, int target, List<int> steps, int left, int right) async {
    // Sort the array if not already sorted
    List<int> sortedArr = List.from(arr)..sort();
    left = 0;
    right = sortedArr.length - 1;

    while (left <= right) {
      int mid = left + (right - left) ~/ 2;
      steps[mid]++; // Increment comparison count
      await Future.delayed(Duration(milliseconds: widget.speed.toInt()));

      if (sortedArr[mid] == target) {
        break; // Target found, exit the loop
      } else if (sortedArr[mid] < target) {
        left = mid + 1;
      } else {
        right = mid - 1;
      }
    }
  }

  Future<void> _hashingSearch(
      List<int> arr, int target, List<int> steps) async {
    // Create a hash table (map) from the array
    Map<int, int> hashTable = {for (var i = 0; i < arr.length; i++) arr[i]: i};

    // Increment the count once for the hash table check
    steps[0] = 1;
    await Future.delayed(Duration(milliseconds: widget.speed.toInt()));
  }

  @override
  Widget build(BuildContext context) {
    // Determine the best algorithm based on the minimum comparisons
    String bestAlgorithm = '';
    int minComparisons = 999999; // Initialize to a very large value

    if (_searchResults.isNotEmpty) {
      _searchResults.forEach((algorithm, steps) {
        int totalComparisons = steps.reduce((a, b) => a + b);
        if (totalComparisons < minComparisons) {
          minComparisons = totalComparisons;
          bestAlgorithm = algorithm;
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Search Algorithm Comparison'),
        backgroundColor: Colors.purple, // Purple AppBar
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: _searchResults.isEmpty
            ? SizedBox() // Remove loading spinner
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Best Algorithm: $bestAlgorithm with $minComparisons comparisons',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple[900], // Dark purple text
                      ),
                    ),
                  ),
                  Expanded(
                    child: SfCartesianChart(
                      title: ChartTitle(
                        text: 'Comparison of Search Algorithms',
                        textStyle: TextStyle(
                          color: Colors.purple[900], // Dark purple text
                        ),
                      ),
                      legend: Legend(
                        isVisible: true,
                        textStyle: TextStyle(
                          color:
                              Colors.purple[900], // Dark purple text for legend
                        ),
                      ),
                      primaryXAxis: CategoryAxis(
                        labelStyle: TextStyle(
                          color: Colors.purple[900], // Dark purple axis labels
                        ),
                      ),
                      primaryYAxis: NumericAxis(
                        title: AxisTitle(
                          text: 'Number of Comparisons',
                          textStyle: TextStyle(
                            color: Colors.purple[900], // Dark purple title
                          ),
                        ),
                        labelStyle: TextStyle(
                          color: Colors.purple[900], // Dark purple axis labels
                        ),
                      ),
                      series: _searchResults.entries.map((entry) {
                        Color lineColor;
                        switch (entry.key) {
                          case 'Linear Search':
                            lineColor =
                                Colors.purple; // Purple for Linear Search
                            break;
                          case 'Binary Search':
                            lineColor =
                                Colors.yellow; // Yellow for Binary Search
                            break;
                          case 'Hashing':
                            lineColor = Colors.red; // Red for Hashing
                            break;
                          default:
                            lineColor = Colors
                                .purple[700]!; // Default purple for others
                        }
                        return LineSeries<_ChartData, int>(
                          dataSource: List.generate(
                            entry.value.length,
                            (index) => _ChartData(
                                widget.numbers[index], entry.value[index]),
                          ),
                          xValueMapper: (_ChartData data, _) => data.x,
                          yValueMapper: (_ChartData data, _) => data.y,
                          name: entry.key,
                          color: lineColor,
                          markerSettings: MarkerSettings(
                            isVisible: true,
                            color: Colors.white,
                            borderColor: lineColor,
                            shape: DataMarkerType.circle,
                          ),
                          dataLabelSettings: DataLabelSettings(
                            isVisible: true,
                            textStyle: TextStyle(
                              color: lineColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _ChartData {
  final int x;
  final int y;

  _ChartData(this.x, this.y);
}
