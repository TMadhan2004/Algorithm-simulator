import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart'; // Ensure to import this
import 'algorithm_sorting.dart';
import 'algorithm_descriptions.dart';
import 'timeline_sorting.dart';
import 'comparison_page.dart'; // Import the comparison page

class SortingAnimationPage extends StatefulWidget {
  final List<int> numbers;
  final String algorithm;
  final double speed;

  SortingAnimationPage({
    required this.numbers,
    required this.algorithm,
    required this.speed,
  });

  @override
  _SortingAnimationPageState createState() => _SortingAnimationPageState();
}

class _SortingAnimationPageState extends State<SortingAnimationPage> {
  late List<int> _numbers;
  List<String> _steps = [];
  int _currentStep = 0;
  bool _isSorting = false;
  List<String> _selectedAlgorithms = []; // Track selected algorithms

  @override
  void initState() {
    super.initState();
    _numbers = List.from(widget.numbers);
    _sort();
  }

  Future<void> _sort() async {
    setState(() {
      _isSorting = true;
    });
    _steps = [];
    switch (widget.algorithm) {
      case 'Bubble Sort':
        await _bubbleSort();
        break;
      case 'Selection Sort':
        await _selectionSort();
        break;
      case 'Insertion Sort':
        await _insertionSort();
        break;
      case 'Shell Sort':
        await _shellSort();
        break;
      case 'Heap Sort':
        await _heapSort();
        break;
      case 'Radix Sort':
        await _radixSort();
        break;
      case 'Merge Sort':
        await _mergeSort();
        break;
      case 'Quick Sort':
        await _quickSort();
        break;
    }
    setState(() {
      _isSorting = false;
    });
  }

  Future<void> _bubbleSort() async {
    List<int> arr = List.from(_numbers);
    for (int i = 0; i < arr.length - 1; i++) {
      for (int j = 0; j < arr.length - i - 1; j++) {
        if (arr[j] > arr[j + 1]) {
          int temp = arr[j];
          arr[j] = arr[j + 1];
          arr[j + 1] = temp;
          _steps.add('Step ${_steps.length + 1}: Swapped ${arr[j]} and ${arr[j + 1]} -> ${arr.toString()}');
          await Future.delayed(Duration(milliseconds: widget.speed.toInt()));
          setState(() {
            _currentStep = _steps.length - 1;
          });
        }
      }
    }
  }

  Future<void> _selectionSort() async {
    List<int> arr = List.from(_numbers);
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
      _steps.add('Step ${_steps.length + 1}: Swapped ${arr[i]} and ${arr[minIdx]} -> ${arr.toString()}');
      await Future.delayed(Duration(milliseconds: widget.speed.toInt()));
      setState(() {
        _currentStep = _steps.length - 1;
      });
    }
  }

  Future<void> _insertionSort() async {
    List<int> arr = List.from(_numbers);
    for (int i = 1; i < arr.length; i++) {
      int key = arr[i];
      int j = i - 1;
      while (j >= 0 && arr[j] > key) {
        arr[j + 1] = arr[j];
        j--;
      }
      arr[j + 1] = key;
      _steps.add('Step ${_steps.length + 1}: Inserted ${key} at position ${j + 1} -> ${arr.toString()}');
      await Future.delayed(Duration(milliseconds: widget.speed.toInt()));
      setState(() {
        _currentStep = _steps.length - 1;
      });
    }
  }

  Future<void> _shellSort() async {
    List<int> arr = List.from(_numbers);
    int gap = arr.length ~/ 2;
    while (gap > 0) {
      for (int i = gap; i < arr.length; i++) {
        int temp = arr[i];
        int j = i;
        while (j >= gap && arr[j - gap] > temp) {
          arr[j] = arr[j - gap];
          j -= gap;
        }
        arr[j] = temp;
        _steps.add('Step ${_steps.length + 1}: After gap ${gap}, array is -> ${arr.toString()}');
        await Future.delayed(Duration(milliseconds: widget.speed.toInt()));
        setState(() {
          _currentStep = _steps.length - 1;
        });
      }
      gap ~/= 2;
    }
  }

  Future<void> _heapSort() async {
    List<int> arr = List.from(_numbers);

    void heapify(List<int> array, int length, int i) {
      int largest = i;
      int left = 2 * i + 1;
      int right = 2 * i + 2;

      if (left < length && array[left] > array[largest]) {
        largest = left;
      }
      if (right < length && array[right] > array[largest]) {
        largest = right;
      }
      if (largest != i) {
        int swap = array[i];
        array[i] = array[largest];
        array[largest] = swap;
        heapify(array, length, largest);
      }
    }

    for (int i = arr.length ~/ 2 - 1; i >= 0; i--) {
      heapify(arr, arr.length, i);
    }

    for (int i = arr.length - 1; i >= 0; i--) {
      int temp = arr[0];
      arr[0] = arr[i];
      arr[i] = temp;
      heapify(arr, i, 0);
      _steps.add('Step ${_steps.length + 1}: After heapify, array is -> ${arr.toString()}');
      await Future.delayed(Duration(milliseconds: widget.speed.toInt()));
      setState(() {
        _currentStep = _steps.length - 1;
      });
    }
  }

  Future<void> _radixSort() async {
    List<int> arr = List.from(_numbers);
    int max = arr.reduce((a, b) => a > b ? a : b);
    int exp = 1;

    while (max ~/ exp > 0) {
      List<int> output = List.filled(arr.length, 0);
      List<int> count = List.filled(10, 0);

      for (int i = 0; i < arr.length; i++) {
        count[(arr[i] ~/ exp) % 10]++;
      }
      for (int i = 1; i < 10; i++) {
        count[i] += count[i - 1];
      }
      for (int i = arr.length - 1; i >= 0; i--) {
        output[count[(arr[i] ~/ exp) % 10] - 1] = arr[i];
        count[(arr[i] ~/ exp) % 10]--;
      }
      for (int i = 0; i < arr.length; i++) {
        arr[i] = output[i];
      }
      exp *= 10;
      _steps.add('Step ${_steps.length + 1}: After sorting with exp $exp, array is -> ${arr.toString()}');
      await Future.delayed(Duration(milliseconds: widget.speed.toInt()));
      setState(() {
        _currentStep = _steps.length - 1;
      });
    }
  }

  Future<void> _mergeSort() async {
    List<int> arr = List.from(_numbers);

    Future<void> mergeSort(List<int> array, int left, int right) async {
      if (left < right) {
        int mid = (left + right) ~/ 2;
        await mergeSort(array, left, mid);
        await mergeSort(array, mid + 1, right);
        await merge(array, left, mid, right);
      }
    }

    await mergeSort(arr, 0, arr.length - 1);
  }

  Future<void> merge(List<int> array, int left, int mid, int right) async {
    int n1 = mid - left + 1;
    int n2 = right - mid;
    List<int> leftArr = List<int>.filled(n1, 0);
    List<int> rightArr = List<int>.filled(n2, 0);

    for (int i = 0; i < n1; i++) {
      leftArr[i] = array[left + i];
    }
    for (int j = 0; j < n2; j++) {
      rightArr[j] = array[mid + 1 + j];
    }

    int i = 0, j = 0, k = left;
    while (i < n1 && j < n2) {
      if (leftArr[i] <= rightArr[j]) {
        array[k] = leftArr[i];
        i++;
      } else {
        array[k] = rightArr[j];
        j++;
      }
      k++;
    }

    while (i < n1) {
      array[k] = leftArr[i];
      i++;
      k++;
    }
    while (j < n2) {
      array[k] = rightArr[j];
      j++;
      k++;
    }
    _steps.add('Step ${_steps.length + 1}: After merging from $left to $right, array is -> ${array.toString()}');
    await Future.delayed(Duration(milliseconds: widget.speed.toInt()));
    setState(() {
      _currentStep = _steps.length - 1;
    });
  }

  Future<void> _quickSort() async {
    List<int> arr = List.from(_numbers);
    await quickSort(arr, 0, arr.length - 1);
  }

  Future<int> _partition(List<int> array, int low, int high) async {
    int pivot = array[high];
    int i = (low - 1);

    for (int j = low; j <= high - 1; j++) {
      if (array[j] < pivot) {
        i++;
        int temp = array[i];
        array[i] = array[j];
        array[j] = temp;
      }
    }
    int temp = array[i + 1];
    array[i + 1] = array[high];
    array[high] = temp;
    _steps.add('Step ${_steps.length + 1}: After partitioning with pivot $pivot, array is -> ${array.toString()}');
    await Future.delayed(Duration(milliseconds: widget.speed.toInt()));
    setState(() {
      _currentStep = _steps.length - 1;
    });
    return i + 1;
  }

  Future<void> quickSort(List<int> array, int low, int high) async {
    if (low < high) {
      int pi = await _partition(array, low, high);
      await quickSort(array, low, pi - 1);
      await quickSort(array, pi + 1, high);
    }
  }

  // void _showComparisonPage() {
  //   if (_selectedAlgorithms.length < 2) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Please select at least two algorithms for comparison.'),
  //       ),
  //     );
  //   } else {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => ComparisonPage(
  //           selectedAlgorithms: _selectedAlgorithms,
  //           numbers: widget.numbers,
  //           speed: widget.speed,
  //         ),
  //       ),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.algorithm} Animation'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AlgorithmSortingPage(
                    algorithm: widget.algorithm,
                  ),
                ),
              );
            },
            icon: Icon(Icons.list),
          ),
          IconButton(
            onPressed: () {
              // Handle Code button press
            },
            icon: Icon(Icons.code),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TimelineSortingPage(
                    numbers: _numbers,
                    algorithm: widget.algorithm,
                    speed: widget.speed,
                  ),
                ),
              );
            },
            icon: Icon(Icons.timeline),
          ),
        ],
      ),
      body: Center(
        child: _isSorting
            ? CircularProgressIndicator()
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Sorting with ${widget.algorithm}'),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _steps.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_steps[index]),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Text('Step: ${_currentStep + 1}/${_steps.length}'),
          ],
        ),
      ),
    );
  }
}