import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart'; // Ensure to import this

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
  }

  Future<List<int>> _sortWithAlgorithm(String algorithm) async {
    List<int> input = List.from(widget.numbers);
    List<int> steps = List.filled(input.length, 0); // Track the number of swaps

    switch (algorithm) {
      case 'Bubble Sort':
        await _bubbleSort(input, steps);
        break;
      case 'Selection Sort':
        await _selectionSort(input, steps);
        break;
      case 'Insertion Sort':
        await _insertionSort(input, steps);
        break;
      case 'Shell Sort':
        await _shellSort(input, steps);
        break;
      case 'Heap Sort':
        await _heapSort(input, steps);
        break;
      case 'Radix Sort':
        await _radixSort(input, steps);
        break;
      case 'Merge Sort':
        await _mergeSort(input, steps, 0, input.length - 1);
        break;
      case 'Quick Sort':
        await _quickSort(input, steps, 0, input.length - 1);
        break;
    }

    return steps;
  }

  Future<void> _bubbleSort(List<int> arr, List<int> steps) async {
    for (int i = 0; i < arr.length - 1; i++) {
      for (int j = 0; j < arr.length - i - 1; j++) {
        if (arr[j] > arr[j + 1]) {
          int temp = arr[j];
          arr[j] = arr[j + 1];
          arr[j + 1] = temp;
          steps[j]++;
          await Future.delayed(Duration(milliseconds: widget.speed.toInt()));
        }
      }
    }
  }

  Future<void> _selectionSort(List<int> arr, List<int> steps) async {
    for (int i = 0; i < arr.length - 1; i++) {
      int minIdx = i;
      for (int j = i + 1; j < arr.length; j++) {
        if (arr[j] < arr[minIdx]) {
          minIdx = j;
        }
      }
      int temp = arr[minIdx];
      arr[minIdx] = arr[i];
      arr[i] = temp;
      steps[i]++;
      await Future.delayed(Duration(milliseconds: widget.speed.toInt()));
    }
  }

  Future<void> _insertionSort(List<int> arr, List<int> steps) async {
    for (int i = 1; i < arr.length; i++) {
      int key = arr[i];
      int j = i - 1;
      while (j >= 0 && arr[j] > key) {
        arr[j + 1] = arr[j];
        j--;
      }
      arr[j + 1] = key;
      steps[i]++;
      await Future.delayed(Duration(milliseconds: widget.speed.toInt()));
    }
  }

  Future<void> _shellSort(List<int> arr, List<int> steps) async {
    int n = arr.length;
    for (int gap = n ~/ 2; gap > 0; gap ~/= 2) {
      for (int i = gap; i < n; i++) {
        int temp = arr[i];
        int j;
        for (j = i; j >= gap && arr[j - gap] > temp; j -= gap) {
          arr[j] = arr[j - gap];
          steps[j]++;
          await Future.delayed(Duration(milliseconds: widget.speed.toInt()));
        }
        arr[j] = temp;
      }
    }
  }

  Future<void> _heapSort(List<int> arr, List<int> steps) async {
    int n = arr.length;

    for (int i = n ~/ 2 - 1; i >= 0; i--) {
      await _heapify(arr, n, i, steps);
    }

    for (int i = n - 1; i > 0; i--) {
      int temp = arr[0];
      arr[0] = arr[i];
      arr[i] = temp;
      steps[i]++;
      await Future.delayed(Duration(milliseconds: widget.speed.toInt()));

      await _heapify(arr, i, 0, steps);
    }
  }

  Future<void> _heapify(List<int> arr, int n, int i, List<int> steps) async {
    int largest = i;
    int left = 2 * i + 1;
    int right = 2 * i + 2;

    if (left < n && arr[left] > arr[largest]) largest = left;
    if (right < n && arr[right] > arr[largest]) largest = right;

    if (largest != i) {
      int swap = arr[i];
      arr[i] = arr[largest];
      arr[largest] = swap;
      steps[i]++;
      await Future.delayed(Duration(milliseconds: widget.speed.toInt()));
      await _heapify(arr, n, largest, steps);
    }
  }

  Future<void> _radixSort(List<int> arr, List<int> steps) async {
    int max = arr.reduce((a, b) => a > b ? a : b);
    for (int exp = 1; max ~/ exp > 0; exp *= 10) {
      await _countSort(arr, exp, steps);
    }
  }

  Future<void> _countSort(List<int> arr, int exp, List<int> steps) async {
    int n = arr.length;
    List<int> output = List.filled(n, 0);
    List<int> count = List.filled(10, 0);

    for (int i = 0; i < n; i++) {
      count[(arr[i] ~/ exp) % 10]++;
    }

    for (int i = 1; i < 10; i++) {
      count[i] += count[i - 1];
    }

    for (int i = n - 1; i >= 0; i--) {
      output[count[(arr[i] ~/ exp) % 10] - 1] = arr[i];
      steps[i]++;
      await Future.delayed(Duration(milliseconds: widget.speed.toInt()));
      count[(arr[i] ~/ exp) % 10]--;
    }

    for (int i = 0; i < n; i++) {
      arr[i] = output[i];
    }
  }

  Future<void> _mergeSort(List<int> arr, List<int> steps, int left, int right) async {
    if (left < right) {
      int middle = (left + right) ~/ 2;

      await _mergeSort(arr, steps, left, middle);
      await _mergeSort(arr, steps, middle + 1, right);

      await _merge(arr, steps, left, middle, right);
    }
  }

  Future<void> _merge(List<int> arr, List<int> steps, int left, int middle, int right) async {
    int n1 = middle - left + 1;
    int n2 = right - middle;

    List<int> leftArray = List.filled(n1, 0);
    List<int> rightArray = List.filled(n2, 0);

    for (int i = 0; i < n1; i++) {
      leftArray[i] = arr[left + i];
    }
    for (int j = 0; j < n2; j++) {
      rightArray[j] = arr[middle + 1 + j];
    }

    int i = 0, j = 0, k = left;
    while (i < n1 && j < n2) {
      if (leftArray[i] <= rightArray[j]) {
        arr[k] = leftArray[i];
        i++;
      } else {
        arr[k] = rightArray[j];
        j++;
      }
      steps[k]++;
      await Future.delayed(Duration(milliseconds: widget.speed.toInt()));
      k++;
    }

    while (i < n1) {
      arr[k] = leftArray[i];
      i++;
      k++;
    }

    while (j < n2) {
      arr[k] = rightArray[j];
      j++;
      k++;
    }
  }
  Future<void> _quickSort(List<int> arr, List<int> steps, int low, int high) async {
    if (low < high) {
      int pi = await _partition(arr, low, high, steps);
      await Future.wait([
        _quickSort(arr, steps, low, pi - 1),
        _quickSort(arr, steps, pi + 1, high),
      ]);
    }
  }

  Future<int> _partition(List<int> arr, int low, int high, List<int> steps) async {
    int pivot = arr[high];
    int i = low - 1;

    for (int j = low; j < high; j++) {
      if (arr[j] <= pivot) {
        i++;
        int temp = arr[i];
        arr[i] = arr[j];
        arr[j] = temp;
        steps[j]++;
        await Future.delayed(Duration(milliseconds: widget.speed.toInt()));
      }
    }

    int temp = arr[i + 1];
    arr[i + 1] = arr[high];
    arr[high] = temp;
    steps[i + 1]++;
    await Future.delayed(Duration(milliseconds: widget.speed.toInt()));

    return i + 1;
  }                                                                                                                                                                           @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Algorithm Comparison'),
      ),
      body: Center(
        child: _sortResults.isEmpty
            ? CircularProgressIndicator()
            : SfCartesianChart(
          title: ChartTitle(text: 'Comparison of Sorting Algorithms'),
          legend: Legend(isVisible: true),
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(title: AxisTitle(text: 'Number of Swaps')),
          series: _sortResults.entries.map((entry) {
            return LineSeries<_ChartData, int>(
              dataSource: List.generate(
                entry.value.length,
                    (index) => _ChartData(widget.numbers[index], entry.value[index]),
              ),
              xValueMapper: (_ChartData data, _) => data.x,
              yValueMapper: (_ChartData data, _) => data.y,
              name: entry.key,
            );
          }).toList(),
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