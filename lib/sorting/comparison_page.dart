import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ComparisonPage extends StatefulWidget {
  final List<String> selectedAlgorithms;
  final List<int> numbers;
  final double speed;

  ComparisonPage({
    required this.selectedAlgorithms,
    required this.numbers,
    this.speed = 3000,
  });

  @override
  _ComparisonPageState createState() => _ComparisonPageState();
}

class _ComparisonPageState extends State<ComparisonPage> {
  late Map<String, List<int>> _sortResults;
  String _optimalAlgorithm = '';
  int _minSwaps = 0;
  int _maxSwaps = 0;

  @override
  void initState() {
    super.initState();
    _sortResults = {};
    _runComparisons();
  }

  //

  Future<void> _runComparisons() async {
    for (String algorithm in widget.selectedAlgorithms) {
      List<int> swapCounts = await _sortWithAlgorithm(algorithm);
      int totalSwaps = swapCounts.reduce((a, b) => a + b);

      setState(() {
        _sortResults[algorithm] = swapCounts;
        _totalSwapsPerAlgorithm[algorithm] = totalSwaps;
      });
    }
    _findOptimalAlgorithm();
    _findMaxSwaps();
  }

  void _findOptimalAlgorithm() {
    int minTotalSwaps = double.maxFinite.toInt();
    List<String> optimalAlgorithms = [];

    _totalSwapsPerAlgorithm.forEach((algorithm, totalSwaps) {
      if (totalSwaps < minTotalSwaps) {
        minTotalSwaps = totalSwaps;
        optimalAlgorithms = [algorithm]; // Reset the list with the new optimal algorithm
      } else if (totalSwaps == minTotalSwaps) {
        optimalAlgorithms.add(algorithm); // Add algorithm with the same minimum swaps
      }
    });

    setState(() {
      _minSwaps = minTotalSwaps;
      _optimalAlgorithm = optimalAlgorithms.join(", "); // Join names with a comma
    });
  }

  Map<String, int> _totalSwapsPerAlgorithm = {};


  void _findMaxSwaps() {
    int maxSwaps = 0;

    _sortResults.forEach((algorithm, swaps) {
      int totalSwaps = swaps.reduce((a, b) => a + b);
      if (totalSwaps > maxSwaps) {
        maxSwaps = totalSwaps;
      }
    });

    setState(() {
      _maxSwaps = maxSwaps;
    });
  }

  Future<List<int>> _sortWithAlgorithm(String algorithm) async {
    List<int> input = List.from(widget.numbers);

    switch (algorithm) {
      case 'Bubble Sort':
        return await _bubbleSort(input);
      case 'Selection Sort':
        return await _selectionSort(input);
      case 'Insertion Sort':
        return await _insertionSort(input);
      case 'Shell Sort':
        return await _shellSort(input);
      default:
        throw Exception('Unknown sorting algorithm: $algorithm');
    }
  }

  Future<List<int>> _bubbleSort(List<int> input) async {
    int n = input.length;
    List<int> swapCounts = List.filled(n, 0);
    List<int> initialPositions = List.generate(n, (index) => index);
    int totalSwapCount = 0;

    for (int i = 0; i < n - 1; i++) {
      bool swapped = false;
      for (int j = 0; j < n - i - 1; j++) {
        if (input[j] > input[j + 1]) {
          int tempValue = input[j];
          input[j] = input[j + 1];
          input[j + 1] = tempValue;

          int tempPos = initialPositions[j];
          initialPositions[j] = initialPositions[j + 1];
          initialPositions[j + 1] = tempPos;

          swapCounts[initialPositions[j]]++;
          swapCounts[initialPositions[j + 1]]++;

          totalSwapCount++;
          swapped = true;
        }
      }

      if (!swapped) {
        break;
      }
    }

    print("Total swaps: $totalSwapCount");
    return swapCounts;
  }

  Future<List<int>> _selectionSort(List<int> input) async {
    List<int> swapCounts = List.filled(input.length, 0);
    List<int> originalIndices = List.generate(input.length, (index) => index);

    for (int i = 0; i < input.length - 1; i++) {
      int minIndex = i;
      for (int j = i + 1; j < input.length; j++) {
        if (input[j] < input[minIndex]) {
          minIndex = j;
        }
      }

      if (minIndex != i) {
        int temp = input[i];
        input[i] = input[minIndex];
        input[minIndex] = temp;

        int originalIndexTemp = originalIndices[i];
        originalIndices[i] = originalIndices[minIndex];
        originalIndices[minIndex] = originalIndexTemp;

        swapCounts[originalIndices[i]]++;
        swapCounts[originalIndices[minIndex]]++;
      }
    }

    return swapCounts;
  }

  Future<List<int>> _insertionSort(List<int> input) async {
    List<int> swapCounts = List.filled(input.length, 0);
    List<int> originalPositions = List.generate(input.length, (index) => index);

    for (int i = 1; i < input.length; i++) {
      int key = input[i];
      int keyOriginalIndex = originalPositions[i];
      int j = i - 1;

      while (j >= 0 && input[j] > key) {
        input[j + 1] = input[j];
        originalPositions[j + 1] = originalPositions[j];

        swapCounts[originalPositions[j]]++;
        swapCounts[keyOriginalIndex]++;

        j--;
      }

      input[j + 1] = key;
      originalPositions[j + 1] = keyOriginalIndex;
    }

    return swapCounts;
  }

  Future<List<int>> _shellSort(List<int> input) async {
    List<int> swapCounts = List.filled(input.length, 0);
    int n = input.length;

    List<int> originalPositions = List.generate(n, (index) => index);

    for (int gap = n ~/ 2; gap > 0; gap ~/= 2) {
      for (int i = gap; i < n; i++) {
        int temp = input[i];
        int tempOriginalIndex = originalPositions[i];
        int j = i;

        while (j >= gap && input[j - gap] > temp) {
          input[j] = input[j - gap];
          originalPositions[j] = originalPositions[j - gap];

          swapCounts[originalPositions[j]]++;
          swapCounts[tempOriginalIndex]++;

          j -= gap;
        }

        input[j] = temp;
        originalPositions[j] = tempOriginalIndex;
      }
    }

    return swapCounts;
  }

  double _getMaxSwaps() {
    if (_sortResults.isEmpty) return 1.0;

    int maxSwaps = 0;
    for (var entry in _sortResults.values) {
      for (var swapCount in entry) {
        if (swapCount > maxSwaps) {
          maxSwaps = swapCount;
        }
      }
    }
    return maxSwaps.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Algorithm Comparison'),
      ),
      body: Center(
        child: _sortResults.isEmpty
            ? CircularProgressIndicator()
            : Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Optimal Algorithm: $_optimalAlgorithm\n',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: SfCartesianChart(
                title: ChartTitle(text: 'Comparison of Sorting Algorithms'),
                legend: Legend(isVisible: true),
                primaryXAxis: CategoryAxis(
                  title: AxisTitle(text: 'Input Values'),
                  interval: 1,
                  maximumLabels: widget.numbers.length,
                ),
                primaryYAxis: NumericAxis(
                  title: AxisTitle(text: 'Number of Swaps'),
                  maximum: _getMaxSwaps(),
                  interval: (widget.numbers.length > 0
                      ? (widget.numbers.length / 5).ceilToDouble()
                      : 1),
                ),
                series: _sortResults.entries.map((entry) {
                  return LineSeries<_ChartData, String>(
                    dataSource: List.generate(
                      widget.numbers.length,
                          (index) {
                        int operationsCount = index < entry.value.length ? entry.value[index] : 0;
                        return _ChartData(widget.numbers[index].toString(), operationsCount);
                      },
                    ),
                    xValueMapper: (_ChartData data, _) => data.x,
                    yValueMapper: (_ChartData data, _) => data.y,
                    name: entry.key,
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
  _ChartData(this.x, this.y);
  final String x;
  final int y;
}
