import 'package:flutter/material.dart';
import 'algorithm_descriptions.dart';
import 'sorting_codes.dart';

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
  late List<int> _positions;
  int _currentStep = 0;
  bool _isSorting = false;
  int _highlightIndex = -1;

  int _sortedUntil = -1;
  bool _isCompleted = false;
  int _swapCount = 0;
  String _currentDescription = '';
  List<String> _steps = [];

  @override
  void initState() {
    super.initState();
    _numbers = List.from(widget.numbers);
    _positions = List.generate(_numbers.length, (index) => index);
    WidgetsBinding.instance.addPostFrameCallback((_) => _sort());
  }

  void _resetSorting() {
    setState(() {
      // Reset the state variables
      _numbers = List.from(widget.numbers); // Reset to original numbers
      _positions = List.generate(_numbers.length, (index) => index);
      _currentStep = 0;
      _isSorting = false;
      _highlightIndex = -1;

      _sortedUntil = -1;
      _isCompleted = false;
      _swapCount = 0;
      _currentDescription = '';
      _steps.clear();
      // _mergeSteps = '';
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _sort());
  }

  Future<void> _sort() async {
    setState(() {
      _isSorting = true;
      _steps.clear();
    });
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
      _isCompleted = true;
    });
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _isSorting = false;
    });
  }

  Future<void> _bubbleSort() async {
    for (int i = 0; i < _numbers.length - 1; i++) {
      bool swapped = false;
      for (int j = 0; j < _numbers.length - i - 1; j++) {
        if (_numbers[j] > _numbers[j + 1]) {
          setState(() {
            _highlightIndex = j; // Highlight bars being swapped
          });
          await Future.delayed(Duration(seconds: 4));

          setState(() {
            _currentStep = _steps.length - 1; // Update the current step
          });

          // Swap and update
          int temp = _numbers[j];
          _numbers[j] = _numbers[j + 1];
          _numbers[j + 1] = temp;
          swapped = true;

          _steps.add(
              'Swapped ${_numbers[j]} and ${_numbers[j + 1]} -> ${_numbers.toString()}');

          setState(() {
            _currentDescription = _steps.last; // Display the last step
          });

          // Increment swap count
          setState(() {
            _swapCount++;
          });
        }
      }

      // Mark this position as sorted
      setState(() {
        _sortedUntil = _numbers.length - i - 1;
      });

      if (!swapped) break;
    }

    setState(() {
      _highlightIndex = -1; // Reset highlighting
    });
  }

  Future<void> _selectionSort() async {
    for (int i = 0; i < _numbers.length - 1; i++) {
      int minIdx = i;
      for (int j = i + 1; j < _numbers.length; j++) {
        setState(() {
          _highlightIndex = j; // Highlight selection
        });
        await Future.delayed(Duration(seconds: 4));

        if (_numbers[j] < _numbers[minIdx]) {
          minIdx = j;
        }
      }

      // Swap
      if (minIdx != i) {
        // Only swap if needed
        int temp = _numbers[i];
        _numbers[i] = _numbers[minIdx];
        _numbers[minIdx] = temp;

        _steps.add(
            'Swapped ${_numbers[i]} and ${_numbers[minIdx]} -> ${_numbers.toString()}');

        // Increment swap count
        setState(() {
          _currentDescription = _steps.last; // Display the last step
          _currentStep = _steps.length - 1;
          _swapCount++;
        });
      }

      setState(() {
        _sortedUntil = i;
      });
    }

    setState(() {
      _highlightIndex = -1;
    });
  }

  Future<void> _insertionSort() async {
    List<int> arr = List.from(_numbers);

    for (int i = 1; i < arr.length; i++) {
      int key = arr[i];
      int j = i - 1;

      // Highlight the key being processed
      setState(() {
        _highlightIndex = i;
      });
      await Future.delayed(Duration(seconds: 4));

      // Shift elements larger than the key
      while (j >= 0 && arr[j] > key) {
        arr[j + 1] = arr[j];
        _steps
            .add('Shifted ${arr[j]} to position ${j + 2} -> ${arr.toString()}');

        setState(() {
          _currentDescription = _steps.last;
          _numbers = List.from(arr); // Update the array
          _highlightIndex = j;
        });

        await Future.delayed(Duration(seconds: 4));
        j--;
      }

      arr[j + 1] = key;
      _steps.add('Inserted $key at position ${j + 1} -> ${arr.toString()}');
      setState(() {
        _currentDescription = _steps.last;
        _numbers = List.from(arr);
        _sortedUntil = i; // Update the sorted index
        _swapCount++;
      });
    }
    setState(() {
      _highlightIndex = -1; // Reset highlighting
    });
  }

  Future<void> _shellSort() async {
    List<int> arr = List.from(_numbers);
    int gap = arr.length ~/ 2;

    while (gap > 0) {
      for (int i = gap; i < arr.length; i++) {
        int temp = arr[i];
        int j = i;

        // Perform gapped insertion sort
        while (j >= gap && arr[j - gap] > temp) {
          arr[j] = arr[j - gap];
          _steps.add(
              'Shifted ${arr[j - gap]} to position ${j + 1} -> ${arr.toString()}');

          setState(() {
            _currentDescription = _steps.last;
            _numbers = List.from(arr);
            _highlightIndex = j;
          });

          await Future.delayed(Duration(seconds: 4));
          j -= gap;
        }
        arr[j] = temp;

        _steps.add('Inserted $temp at position $j -> ${arr.toString()}');
        setState(() {
          _currentDescription = _steps.last;
          _numbers = List.from(arr);
          _swapCount++;
        });
      }
      gap ~/= 2;
    }
    setState(() {
      _highlightIndex = -1;
    });
  }

  Future<void> _heapSort() async {
    Future<void> heapify(int length, int i) async {
      int largest = i;
      int left = 2 * i + 1;
      int right = 2 * i + 2;

      // Highlight the current node being processed
      setState(() {
        _highlightIndex = i;
      });

      await Future.delayed(Duration(seconds: 4)); // Delay for animation

      // Check if left child exists and is greater than root
      if (left < length && _numbers[left] > _numbers[largest]) {
        largest = left;
      }

      // Check if right child exists and is greater than largest so far
      if (right < length && _numbers[right] > _numbers[largest]) {
        largest = right;
      }

      // If largest is not root, swap and continue heapifying
      if (largest != i) {
        // Swap and update the main _numbers list directly
        setState(() {
          int temp = _numbers[i];
          _numbers[i] = _numbers[largest];
          _numbers[largest] = temp;

          // Log the swap action
          _steps.add(
              'Swapped ${_numbers[i]} with ${_numbers[largest]} -> ${_numbers.toString()}');
          _currentDescription = _steps.last; // Display the last step
          _swapCount++; // Increment swap count
          _highlightIndex = largest; // Highlight the swapped node
        });

        await Future.delayed(Duration(seconds: 4)); // Delay for animation

        // Recursively heapify the affected sub-tree
        await heapify(length, largest);
      }
    }

    // Build heap (rearranging the array)
    for (int i = _numbers.length ~/ 2 - 1; i >= 0; i--) {
      await heapify(_numbers.length, i);
    }

    // Extract elements from heap one by one
    for (int i = _numbers.length - 1; i >= 0; i--) {
      // Move current root to end
      setState(() {
        int temp = _numbers[0];
        _numbers[0] = _numbers[i];
        _numbers[i] = temp;

        // Log the swap action
        _steps.add(
            'Moved root ${temp} to position ${i} -> ${_numbers.toString()}');
        _currentDescription = _steps.last; // Display the last step
        _swapCount++; // Increment swap count
        _sortedUntil = i; // Mark the sorted section
      });

      await Future.delayed(Duration(seconds: 4)); // Delay for animation

      // Call heapify on the reduced heap
      await heapify(i, 0);

      // Log the heapify state
      setState(() {
        _steps.add('After heapify, array is -> ${_numbers.toString()}');
        _currentDescription = _steps.last; // Display the last step
        _currentStep = _steps.length - 1; // Update the current step
      });

      await Future.delayed(Duration(seconds: 4)); // Delay for animation
    }

    // Reset highlighting after sorting is complete
    setState(() {
      _highlightIndex = -1;
    });
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

      arr.setAll(0, output);
      _steps.add('After sorting with exp $exp: ${arr.toString()}');

      setState(() {
        _currentDescription = _steps.last;
        _numbers = List.from(arr);
        _highlightIndex = exp; // Highlight for visual feedback
      });

      await Future.delayed(Duration(seconds: 4));
      exp *= 10;
    }
    setState(() {
      _highlightIndex = -1;
    });
  }

  Future<void> _mergeSort() async {
    List<int> arr = List.from(_numbers);

    Future<void> mergeSort(List<int> array, int left, int right) async {
      if (left < right) {
        int mid = (left + right) ~/ 2;

        // Highlight the left and right halves before merging
        await mergeSort(array, left, mid);
        await mergeSort(array, mid + 1, right);
        await merge(array, left, mid, right);
      }
    }

    await mergeSort(arr, 0, arr.length - 1);
  }

  Future<void> merge(List<int> array, int left, int mid, int right) async {
    List<int> leftArr = array.sublist(left, mid + 1);
    List<int> rightArr = array.sublist(mid + 1, right + 1);

    int i = 0, j = 0, k = left;
    _steps.add(
        'Merging left: ${leftArr.toString()} and right: ${rightArr.toString()}');
    setState(() {
      _currentDescription = _steps.last; // Display the merging step
    });
    await Future.delayed(Duration(seconds: 4));

    // Highlight the merging process
    while (i < leftArr.length && j < rightArr.length) {
      setState(() {
        // Highlight the current elements being compared
        _highlightIndex = (i < leftArr.length)
            ? left + i
            : mid + 1 + j; // Highlight the correct index
      });
      await Future.delayed(
          Duration(seconds: 4)); // Allow time to see the highlight

      if (leftArr[i] <= rightArr[j]) {
        array[k++] = leftArr[i++];
        _steps.add('Chose ${leftArr[i - 1]} from left array');
      } else {
        array[k++] = rightArr[j++];
        _steps.add('Chose ${rightArr[j - 1]} from right array');
      }

      // Update the numbers and description after each decision
      setState(() {
        _numbers = List.from(array);
        _currentDescription =
            _steps.last; // Update current description with the last step
        _swapCount++; // Increment swap count on each merge step
      });
      await Future.delayed(Duration(seconds: 4)); // Show each swap
    }

    // Copy remaining elements of leftArr if any
    while (i < leftArr.length) {
      array[k++] = leftArr[i++];
      _steps.add('Copied ${leftArr[i - 1]} from left array');
      setState(() {
        _numbers = List.from(array);
        _currentDescription = _steps.last; // Update current description
      });
      await Future.delayed(Duration(seconds: 4)); // Show each copy
    }

    // Copy remaining elements of rightArr if any
    while (j < rightArr.length) {
      array[k++] = rightArr[j++];
      _steps.add('Copied ${rightArr[j - 1]} from right array');
      setState(() {
        _numbers = List.from(array);
        _currentDescription = _steps.last; // Update current description
      });
      await Future.delayed(Duration(seconds: 4)); // Show each copy
    }

    // Final update of numbers after merging
    setState(() {
      _numbers = List.from(array);
    });
  }

  Future<void> _quickSort() async {
    List<int> arr = List.from(_numbers);
    await quickSort(arr, 0, arr.length - 1);
    setState(() {
      _numbers = List.from(arr); // Update the main array after sorting
      _highlightIndex = -1; // Reset highlighting
    });
  }

  int _pivotIndex = -1;
  Future<int> _partition(List<int> array, int low, int high) async {
    int pivot = array[high];
    int i = low - 1;
    int swapCount = 0;

    setState(() {
      _pivotIndex = high; // Highlight the pivot element
    });

    await Future.delayed(Duration(seconds: 4));

    for (int j = low; j < high; j++) {
      setState(() {
        _highlightIndex = j; // Highlight the current index being compared
      });

      await Future.delayed(Duration(seconds: 4));

      if (array[j] < pivot) {
        i++;
        _swap(array, i, j); // Swap elements
        swapCount++;

        // Log the swap step
        _steps
            .add('Swapped ${array[i]} and ${array[j]} -> ${array.toString()}');
        setState(() {
          _currentDescription = _steps.last;
          _currentStep = _steps.length - 1;
        });

        await Future.delayed(Duration(seconds: 4));
      }
    }

    // Final swap for the pivot element
    _swap(array, i + 1, high);
    swapCount++;

    _steps.add(
        'Step ${_steps.length + 1}: After partitioning with pivot $pivot, array is -> ${array.toString()}');
    setState(() {
      _currentDescription = _steps.last;
      _currentStep = _steps.length - 1;
      _swapCount += swapCount;
      _pivotIndex = -1;
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

// Helper function to swap two elements in the array
  void _swap(List<int> array, int i, int j) {
    int temp = array[i];
    array[i] = array[j];
    array[j] = temp;
  }

  @override
  Widget build(BuildContext context) {
    final int maxNumber =
        _numbers.isNotEmpty ? _numbers.reduce((a, b) => a > b ? a : b) : 1;
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AlgorithmAnimationPage(
                    algorithm: widget.algorithm,
                  ),
                ),
              );
            },
            icon: Icon(Icons.code),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 16),
            Text(
              _currentDescription, // Display current swap description
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: _isSorting
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Sorting with ${widget.algorithm}'),
                        SizedBox(height: 16),
                        Center(
                          child: Container(
                            width: _numbers.length *
                                40.0, // Adjust width based on number of bars
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: List.generate(_numbers.length, (index) {
                                return AnimatedPositioned(
                                  duration: Duration(
                                      seconds:
                                          30), // Adjust for smoother animations
                                  left: index *
                                      40.0, // Space each bar horizontally
                                  bottom:
                                      0, // Align bars to the bottom of the Stack
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        width: 30,
                                        // height: _numbers[index] * 10.0, // Scale the height of each bar
                                        height: (maxNumber > 0
                                            ? _numbers[index] / maxNumber * 200
                                            : 0),
                                        color: index == _pivotIndex
                                            ? Colors
                                                .orange // Pivot element in orange
                                            : index == _highlightIndex
                                                ? Colors
                                                    .red // Highlighted element in red
                                                : (index <= _sortedUntil
                                                    ? Colors.green
                                                    : Colors.blue),
                                        child: Center(
                                          child: Text(
                                            '${_numbers[index]}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text('Swaps: $_swapCount'),
                      ],
                    )
                  : _isCompleted
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Sorting Complete!'),
                            SizedBox(height: 16),
                            Center(
                              child: Container(
                                width: _numbers.length * 40.0,
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children:
                                      List.generate(_numbers.length, (index) {
                                    return AnimatedPositioned(
                                      duration: Duration(
                                          milliseconds:
                                              300), // Adjust for smoother animations
                                      left: index * 40.0,
                                      bottom: 0,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            width: 30,
                                            // height: _numbers[index] * 10.0,
                                            height: (maxNumber > 0
                                                ? _numbers[index] /
                                                    maxNumber *
                                                    200
                                                : 0),
                                            color: Colors
                                                .green, // Final sorted order color
                                            child: Center(
                                              child: Text(
                                                '${_numbers[index]}',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Text('Sorting Complete!'),
            ),
            SizedBox(height: 16), // Spacer before button
            ElevatedButton(
              onPressed: _resetSorting, // Call reset function
              child: Text('Sort Again'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
