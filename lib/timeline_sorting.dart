import 'package:flutter/material.dart';

class TimelineSortingPage extends StatefulWidget {
  final List<int> numbers;
  final String algorithm;
  final double speed;

  TimelineSortingPage({
    required this.numbers,
    required this.algorithm,
    required this.speed,
  });

  @override
  _TimelineSortingPageState createState() => _TimelineSortingPageState();
}

class _TimelineSortingPageState extends State<TimelineSortingPage> {
  List<int> _numbers = [];
  List<List<int>> _iterations = [];
  List<int> _highlightedIndices = [];
  bool _isSorting = false;

  @override
  void initState() {
    super.initState();
    _numbers = widget.numbers.toList();
    _iterations = [_numbers.toList()];
    _sort();
  }

  void _sort() async {
    setState(() {
      _isSorting = true;
    });
    if (widget.algorithm == 'Bubble Sort') {
       _bubbleSort();
    } else if (widget.algorithm == 'Shell Sort') {
       _shellSort();
    } else if (widget.algorithm == 'Insertion Sort') {
       _insertionSort();
    } else if (widget.algorithm == 'Radix Sort') {
       _radixSort();
    } else if (widget.algorithm == 'Merge Sort') {
       _mergeSort(0, _numbers.length - 1);
    } else if (widget.algorithm == 'Selection Sort') {
       _selectionSort();
    } else if (widget.algorithm == 'Quick Sort') {
       _quickSort(0, _numbers.length - 1);
    } else if (widget.algorithm == 'Heap Sort') {
       _heapSort();
    }
    setState(() {
      _isSorting = false;
    });
  }

  Future<void> _bubbleSort() async {
    List<int> list = _numbers.toList();
    for (int i = 0; i < list.length - 1; i++) {
      for (int j = 0; j < list.length - i - 1; j++) {
        if (list[j] > list[j + 1]) {
          int temp = list[j];
          list[j] = list[j + 1];
          list[j + 1] = temp;
          _iterations.add(list.toList());
          _highlightedIndices = [j, j + 1];
          setState(() {});
        }
         Future.delayed(Duration(milliseconds: widget.speed.toInt()));
      }
    }
  }

  Future<void> _shellSort() async {
    List<int> list = _numbers.toList();
    int gap = list.length ~/ 2;
    while (gap > 0) {
      for (int i = gap; i < list.length; i++) {
        int temp = list[i];
        int j = i;
        while (j >= gap && list[j - gap] > temp) {
          list[j] = list[j - gap];
          j -= gap;
          _iterations.add(list.toList());
          _highlightedIndices = [j, j + gap];
          setState(() {});
           Future.delayed(Duration(milliseconds: widget.speed.toInt()));
        }
        list[j] = temp;
        _iterations.add(list.toList());
        _highlightedIndices = [j, i];
        setState(() {});
         Future.delayed(Duration(milliseconds: widget.speed.toInt()));
      }
      gap ~/= 2;
    }
  }

  Future<void> _insertionSort() async {
    List<int> list = _numbers.toList();
    for (int i = 1; i < list.length; i++) {
      int key = list[i];
      int j = i - 1;
      while (j >= 0 && list[j] > key) {
        list[j + 1] = list[j];
        j--;
        _iterations.add(list.toList());
        _highlightedIndices = [j + 1, j + 2];
        setState(() {});
         Future.delayed(Duration(milliseconds: widget.speed.toInt()));
      }
      list[j + 1] = key;
      _iterations.add(list.toList());
      _highlightedIndices = [j + 1, i];
      setState(() {});
       Future.delayed(Duration(milliseconds: widget.speed.toInt()));
    }
  }

  Future<void> _radixSort() async {
    int getMax(List<int> list, int n) {
      int mx = list[0];
      for (int i = 1; i < n; i++) {
        if (list[i] > mx) {
          mx = list[i];
        }
      }
      return mx;
    }

    void countSort(List<int> list, int n, int exp) {
      List<int> output = List.filled(n, 0);
      List<int> count = List.filled(10, 0);

      for (int i = 0; i < n; i++) {
        count[(list[i] ~/ exp) % 10]++;
      }

      for (int i = 1; i < 10; i++) {
        count[i] += count[i - 1];
      }

      for (int i = n - 1; i >= 0; i--) {
        output[count[(list[i] ~/ exp) % 10] - 1] = list[i];
        _iterations.add(output.toList());
        _highlightedIndices = [i];
        setState(() {});
         Future.delayed(Duration(milliseconds: widget.speed.toInt()));
      }

      for (int i = 0; i < n; i++) {
        list[i] = output[i];
        _iterations.add(list.toList());
        _highlightedIndices = [i];
        setState(() {});
         Future.delayed(Duration(milliseconds: widget.speed.toInt()));
      }
    }

    List<int> list = _numbers.toList();
    int max = getMax(list, list.length);

    for (int exp = 1; max ~/ exp > 0; exp *= 10) {
      countSort(list, list.length, exp);
       Future.delayed(Duration(milliseconds: widget.speed.toInt()));
    }
  }

  Future<void> _mergeSort(int l, int r) async {
    void merge(List<int> list, int l, int m, int r) {
      int n1 = m - l + 1;
      int n2 = r - m;

      List<int> L = List.filled(n1, 0);
      List<int> R = List.filled(n2, 0);

      for (int i = 0; i < n1; i++) {
        L[i] = list[l + i];
      }
      for (int j = 0; j < n2; j++) {
        R[j] = list[m + 1 + j];
      }

      int i = 0, j = 0;
      int k = l;
      while (i < n1 && j < n2) {
        if (L[i] <= R[j]) {
          list[k] = L[i];
          i++;
        } else {
          list[k] = R[j];
          j++;
        }
        _iterations.add(list.toList());
        _highlightedIndices = [k];
        setState(() {});
         Future.delayed(Duration(milliseconds: widget.speed.toInt()));
        k++;
      }

      while (i < n1) {
        list[k] = L[i];
        _iterations.add(list.toList());
        _highlightedIndices = [k];
        setState(() {});
         Future.delayed(Duration(milliseconds: widget.speed.toInt()));
        i++;
        k++;
      }

      while (j < n2) {
        list[k] = R[j];
        _iterations.add(list.toList());
        _highlightedIndices = [k];
        setState(() {});
         Future.delayed(Duration(milliseconds: widget.speed.toInt()));
        j++;
        k++;
      }
    }

    if (l < r) {
      int m = (l + r) ~/ 2;
      await _mergeSort(l, m);
      await _mergeSort(m + 1, r);
      merge(_numbers, l, m, r);
    }
  }

  Future<void> _selectionSort() async {
    List<int> list = _numbers.toList();
    int n = list.length;

    for (int i = 0; i < n - 1; i++) {
      int minIndex = i;
      for (int j = i + 1; j < n; j++) {
        if (list[j] < list[minIndex]) {
          minIndex = j;
        }
        _iterations.add(list.toList());
        _highlightedIndices = [i, j];
        setState(() {});
        await Future.delayed(Duration(milliseconds: widget.speed.toInt()));
      }
      int temp = list[minIndex];
      list[minIndex] = list[i];
      list[i] = temp;
      _iterations.add(list.toList());
      _highlightedIndices = [i, minIndex];
      setState(() {});
      await Future.delayed(Duration(milliseconds: widget.speed.toInt()));
    }
  }

  Future<void> _quickSort(int low, int high) async {
    if (low < high) {
      int pi = await _partition(low, high);
      await _quickSort(low, pi - 1);
      await _quickSort(pi + 1, high);
    }
  }

  Future<int> _partition(int low, int high) async {
    List<int> list = _numbers.toList();
    int pivot = list[high];
    int i = low - 1;

    for (int j = low; j <= high - 1; j++) {
      if (list[j] < pivot) {
        i++;
        int temp = list[i];
        list[i] = list[j];
        list[j] = temp;
        _iterations.add(list.toList());
        _highlightedIndices = [i, j];
        setState(() {});
        await Future.delayed(Duration(milliseconds: widget.speed.toInt()));
      }
    }
    int temp = list[i + 1];
    list[i + 1] = list[high];
    list[high] = temp;
    _iterations.add(list.toList());
    _highlightedIndices = [i + 1, high];
    setState(() {});
    await Future.delayed(Duration(milliseconds: widget.speed.toInt()));
    return i + 1;
  }

  Future<void> _heapSort() async {
    await heapify(_numbers, _numbers.length, 0);
    for (int i = _numbers.length - 1; i >= 0; i--) {
      int temp = _numbers[0];
      _numbers[0] = _numbers[i];
      _numbers[i] = temp;
      _iterations.add(_numbers.toList());
      _highlightedIndices = [0, i];
      setState(() {});
      await heapify(_numbers, i, 0);
      await Future.delayed(Duration(milliseconds: widget.speed.toInt()));
    }
  }

  Future<void> heapify(List<int> list, int n, int i) async {
    int largest = i;
    int l = 2 * i + 1;
    int r = 2 * i + 2;

    if (l < n && list[l] > list[largest]) {
      largest = l;
    }

    if (r < n && list[r] > list[largest]) {
      largest = r;
    }

    if (largest != i) {
      int swap = list[i];
      list[i] = list[largest];
      list[largest] = swap;

      _iterations.add(list.toList());
      _highlightedIndices = [i, largest];
      setState(() {});
      await Future.delayed(Duration(milliseconds: widget.speed.toInt()));

      await heapify(list, n, largest);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timeline Sorting'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _iterations.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _iterations[index]
                          .asMap()
                          .map((i, e) => MapEntry(
                          i,
                          Column(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 2),
                                width: 20,
                                height: 20,
                                color: _highlightedIndices.contains(i)
                                    ? Colors.red
                                    : Colors.blue,
                                child: Center(
                                  child: Text(
                                    '$e',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              if (_highlightedIndices.contains(i))
                                Icon(
                                  Icons.arrow_drop_up,
                                  color: Colors.red,
                                ),
                            ],
                          )))
                          .values
                          .toList(),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isSorting ? null : _sort,
              child: Text(_isSorting ? 'Sorting...' : 'Sort Again'),
            ),
          ],
        ),
      ),
    );
  }
}
