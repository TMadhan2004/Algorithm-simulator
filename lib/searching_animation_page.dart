import 'package:flutter/material.dart';
import 'searching_algorithm_description.dart'; // Import the new description page

class SearchingAnimationPage extends StatefulWidget {
  final List<int> numbers;
  final int target;
  final String algorithm;
  final double speed;

  SearchingAnimationPage({
    required this.numbers,
    required this.target,
    required this.algorithm,
    required this.speed,
  });

  @override
  _SearchingAnimationPageState createState() => _SearchingAnimationPageState();
}

class _SearchingAnimationPageState extends State<SearchingAnimationPage> {
  late List<int> _numbers;
  late int _target;
  List<String> _steps = [];
  int _currentStep = 0;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _numbers = List.from(widget.numbers);
    _target = widget.target;
    _search();
  }

  Future<void> _search() async {
    setState(() {
      _isSearching = true;
    });
    _steps = [];
    switch (widget.algorithm) {
      case 'Linear Search':
        await _linearSearch();
        break;
      case 'Binary Search':
        await _binarySearch();
        break;
      case 'Hashing':
        await _hashing();
        break;
    }
    setState(() {
      _isSearching = false;
    });
  }

  Future<void> _linearSearch() async {
    for (int i = 0; i < _numbers.length; i++) {
      _steps.add('Step ${_steps.length + 1}: Comparing ${_numbers[i]} with $_target');
      if (_numbers[i] == _target) {
        _steps.add('Step ${_steps.length + 1}: Found $_target at index $i');
        break;
      }
      await Future.delayed(Duration(milliseconds: widget.speed.toInt()));
      setState(() {
        _currentStep = _steps.length - 1;
      });
    }
    if (!_steps.last.contains('Found')) {
      _steps.add('Step ${_steps.length + 1}: $_target not found in the list');
      setState(() {
        _currentStep = _steps.length - 1;
      });
    }
  }

  Future<void> _binarySearch() async {
    List<int> arr = List.from(_numbers)..sort();
    int left = 0;
    int right = arr.length - 1;
    while (left <= right) {
      int mid = left + (right - left) ~/ 2;
      _steps.add('Step ${_steps.length + 1}: Checking middle index $mid with value ${arr[mid]}');
      if (arr[mid] == _target) {
        _steps.add('Step ${_steps.length + 1}: Found $_target at index $mid');
        break;
      } else if (arr[mid] < _target) {
        _steps.add('Step ${_steps.length + 1}: $_target > ${arr[mid]} -> move right');
        left = mid + 1;
      } else {
        _steps.add('Step ${_steps.length + 1}: $_target < ${arr[mid]} -> move left');
        right = mid - 1;
      }
      await Future.delayed(Duration(milliseconds: widget.speed.toInt()));
      setState(() {
        _currentStep = _steps.length - 1;
      });
    }
    if (!_steps.last.contains('Found')) {
      _steps.add('Step ${_steps.length + 1}: $_target not found in the list');
      setState(() {
        _currentStep = _steps.length - 1;
      });
    }
  }

  Future<void> _hashing() async {
    Map<int, int> hashTable = {};
    for (int i = 0; i < _numbers.length; i++) {
      hashTable[_numbers[i]] = i;
      _steps.add('Step ${_steps.length + 1}: Inserted ${_numbers[i]} into hash table at index $i');
      await Future.delayed(Duration(milliseconds: widget.speed.toInt()));
      setState(() {
        _currentStep = _steps.length - 1;
      });
    }
    if (hashTable.containsKey(_target)) {
      _steps.add('Step ${_steps.length + 1}: Found $_target at index ${hashTable[_target]} in hash table');
    } else {
      _steps.add('Step ${_steps.length + 1}: $_target not found in hash table');
    }
    setState(() {
      _currentStep = _steps.length - 1;
    });
  }

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
                  builder: (context) => SearchingAlgorithmDescriptionPage(
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
              // Handle Timeline button press
            },
            icon: Icon(Icons.timeline),
          ),
        ],
      ),
      body: Center(
        child: _isSearching
            ? CircularProgressIndicator()
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Searching for $_target using ${widget.algorithm}'),
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
