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

  Future<void> _runComparisons() async {
    for (String algorithm in widget.selectedAlgorithms) {
      List<int> result = await _sortWithAlgorithm(algorithm);
      setState(() {
        _sortResults[algorithm] = result;
      });
    }
    _findOptimalAlgorithm();
    _findMaxSwaps();
  }

  void _findOptimalAlgorithm() {
    int minSwaps = double.maxFinite.toInt();
    String optimalAlgorithm = '';

    _sortResults.forEach((algorithm, swaps) {
      int totalSwaps = swaps.reduce((a, b) => a + b);
      if (totalSwaps < minSwaps) {
        minSwaps = totalSwaps;
        optimalAlgorithm = algorithm;
      }
    });

    setState(() {
      _minSwaps = minSwaps;
      _optimalAlgorithm = optimalAlgorithm;
    });
  }

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
      case 'Heap Sort':
        return await _heapSort(input);
      case 'Radix Sort':
        return await _radixSort(input);
      case 'Merge Sort':
        return await _mergeSort(input);
      case 'Quick Sort':
        return await _quickSort(input);
      default:
        throw Exception('Unknown sorting algorithm: $algorithm');
    }
  }

  Future<List<int>> _bubbleSort(List<int> input) async {
    List<int> swapCounts = [];

    // Initialize swap counts for each input
    for (int i = 0; i < input.length; i++) {
      swapCounts.add(0);
    }

    for (int i = 0; i < input.length - 1; i++) {
      int swaps = 0; // Count swaps for this pass
      for (int j = 0; j < input.length - i - 1; j++) {
        if (input[j] > input[j + 1]) {
          // Swap elements
          int temp = input[j];
          input[j] = input[j + 1];
          input[j + 1] = temp;
          swaps++;
          swapCounts[j +
              1]++;
        }
      }
    }
    return swapCounts;
  }

  Future<List<int>> _selectionSort(List<int> input) async {
    List<int> swapCounts = List.filled(
        input.length, 0);

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

        swapCounts[i]++;
        swapCounts[minIndex]++;
      }
    }
    return swapCounts;
  }

  Future<List<int>> _insertionSort(List<int> input) async {
    List<int> swapCounts = List.filled(
        input.length, 0);
    for (int i = 1; i < input.length; i++) {
      int key = input[i];
      int j = i - 1;
      while (j >= 0 && input[j] > key) {
        input[j + 1] = input[j];
        swapCounts[j + 1]++;
        j--;
      }
      input[j + 1] = key;
    }
    return swapCounts;
  }

  Future<List<int>> _mergeSort(List<int> input) async {
    List<int> swapCounts = List.filled(
        input.length, 0);

    void merge(List<int> arr, int l, int m, int r) {
      int n1 = m - l + 1;
      int n2 = r - m;
      List<int> L = List.filled(n1, 0);
      List<int> R = List.filled(n2, 0);

      for (int i = 0; i < n1; i++)
        L[i] = arr[l + i];
      for (int j = 0; j < n2; j++)
        R[j] = arr[m + 1 + j];

      int i = 0,
          j = 0,
          k = l;
      while (i < n1 && j < n2) {
        if (L[i] <= R[j]) {
          arr[k] = L[i];
          i++;
        } else {
          arr[k] = R[j];
          j++;
          swapCounts[k]++;
        }
        k++;
      }
      while (i < n1) {
        arr[k] = L[i];
        i++;
        k++;
      }
      while (j < n2) {
        arr[k] = R[j];
        j++;
        k++;
      }
    }

    void sort(List<int> arr, int l, int r) {
      if (l < r) {
        int m = l + (r - l) ~/ 2;
        sort(arr, l, m);
        sort(arr, m + 1, r);
        merge(arr, l, m, r);
      }
    }

    sort(input, 0, input.length - 1);
    return swapCounts;
  }

  Future<List<int>> _shellSort(List<int> input) async {
    List<int> swapCounts = List.filled(
        input.length, 0);
    int n = input.length;
    for (int gap = n ~/ 2; gap > 0; gap ~/= 2) {
      for (int i = gap; i < n; i++) {
        int temp = input[i];
        int j;
        for (j = i; j >= gap && input[j - gap] > temp; j -= gap) {
          input[j] = input[j - gap];
          swapCounts[j]++;
        }
        input[j] = temp;
        if (j != i) {
          swapCounts[j]++;
        }
      }
    }
    return swapCounts;
  }

  Future<List<int>> _heapSort(List<int> input) async {
    List<int> swapCounts = List.filled(
        input.length, 0);
    int n = input.length;

    void heapify(int n, int i) {
      int largest = i;
      int left = 2 * i + 1;
      int right = 2 * i + 2;

      if (left < n && input[left] > input[largest]) {
        largest = left;
      }
      if (right < n && input[right] > input[largest]) {
        largest = right;
      }
      if (largest != i) {
        // Swap elements
        int temp = input[i];
        input[i] = input[largest];
        input[largest] = temp;
        swapCounts[i]++;
        swapCounts[largest]++;
        heapify(n, largest);
      }
    }

    for (int i = n ~/ 2 - 1; i >= 0; i--) {
      heapify(n, i);
    }
    for (int i = n - 1; i >= 0; i--) {
      int temp = input[0];
      input[0] = input[i];
      input[i] = temp;
      swapCounts[0]++;
      swapCounts[i]++;
      heapify(i, 0);
    }
    return swapCounts;
  }

  Future<List<int>> _quickSort(List<int> input) async {
    List<int> swapCounts = List.filled(
        input.length, 0);

    int _partition(List<int> arr, int low, int high) {
      int pivot = arr[high];
      int i = (low - 1);
      for (int j = low; j < high; j++) {
        if (arr[j] < pivot) {
          i++;
          int temp = arr[i];
          arr[i] = arr[j];
          arr[j] = temp;
          swapCounts[i]++;
          swapCounts[j]++;
        }
      }
      int temp = arr[i + 1];
      arr[i + 1] = arr[high];
      arr[high] = temp;
      swapCounts[i + 1]++;
      swapCounts[high]++;
      return i + 1;
    }

    void quickSort(List<int> arr, int low, int high) {
      if (low < high) {
        int pi = _partition(arr, low, high);
        quickSort(arr, low, pi - 1);
        quickSort(arr, pi + 1, high);
      }
    }
    quickSort(input, 0, input.length - 1);
    return swapCounts;
  }

  Future<List<int>> _radixSort(List<int> input) async {
    List<int> swapCounts = [];
    if (input.isEmpty) return swapCounts;

    int max = input.reduce((a, b) => a > b ? a : b);

    for (int exp = 1; max ~/ exp > 0; exp *= 10) {
      List<int> output = List.filled(input.length, 0);
      int countSize = 10;
      List<int> count = List.filled(countSize, 0);

      for (int i = 0; i < input.length; i++) {
        int digit = (input[i] ~/ exp) % 10;
        count[digit]++;
      }

      for (int i = 1; i < countSize; i++) {
        count[i] += count[i - 1];
      }

      int operations = 0;

      for (int i = input.length - 1; i >= 0; i--) {
        int digit = (input[i] ~/ exp) % 10;
        output[count[digit] - 1] = input[i];
        count[digit]--;
        operations++;
      }

      swapCounts.add(operations);

      for (int i = 0; i < input.length; i++) {
        input[i] = output[i];
      }
    }

    return swapCounts;
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
                'Optimal Algorithm: $_optimalAlgorithm\nMinimum Swaps: $_minSwaps',
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
                  maximum: widget.numbers.length.toDouble(),
                  interval: (widget.numbers.length > 0 ? (widget.numbers.length / 5).ceilToDouble() : 1),
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
