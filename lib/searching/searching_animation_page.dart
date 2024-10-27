import 'package:flutter/material.dart';
import 'searching_algorithm_description.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'searching_code_page.dart';

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

class _SearchingAnimationPageState extends State<SearchingAnimationPage>
    with TickerProviderStateMixin {
  late List<int> _numbers;
  late int _target;
  List<String> _steps = [];
  List<List<int>> _iterations = [];
  List<int> _highlightedIndices = [];
  int _currentStep = 0;
  bool _isSearching = false;
  bool _foundTarget = false;
  int? _targetIndex;

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
      _foundTarget = false;
      _targetIndex = null;
      _steps.clear();
      _iterations.clear();
      _highlightedIndices.clear();
    });

    // Start searching based on the selected algorithm
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
      _steps.add(
          'Step ${_steps.length + 1}: Comparing ${_numbers[i]} with $_target');
      _iterations.add(List.from(_numbers));
      _highlightedIndices.add(i);

      setState(() {
        _currentStep = _steps.length - 1;
      });

      await Future.delayed(Duration(milliseconds: widget.speed.toInt()));

      if (_numbers[i] == _target) {
        _steps.add('Step ${_steps.length + 1}: Found $_target at index $i');
        _foundTarget = true;
        _targetIndex = i;
        setState(() {});
        return;
      }
    }
    _steps.add('Step ${_steps.length + 1}: $_target not found in the list');
    setState(() {});
  }

  Future<void> _binarySearch() async {
    List<int> arr = List.from(_numbers)..sort();
    int left = 0;
    int right = arr.length - 1;

    while (left <= right) {
      int mid = left + (right - left) ~/ 2;
      _steps.add(
          'Step ${_steps.length + 1}: Checking middle index $mid with value ${arr[mid]}');
      _iterations.add(List.from(arr));
      _highlightedIndices.add(mid);

      setState(() {
        _currentStep = _steps.length - 1;
      });

      await Future.delayed(Duration(milliseconds: widget.speed.toInt()));

      if (arr[mid] == _target) {
        _steps.add('Step ${_steps.length + 1}: Found $_target at index $mid');
        _foundTarget = true;
        _targetIndex = mid;
        setState(() {});
        return;
      } else if (arr[mid] < _target) {
        left = mid + 1;
      } else {
        right = mid - 1;
      }
    }
    _steps.add('Step ${_steps.length + 1}: $_target not found in the list');
    setState(() {});
  }

  Future<void> _hashing() async {
    Map<int, int> hashTable = {};
    for (int i = 0; i < _numbers.length; i++) {
      hashTable[_numbers[i]] = i;
      _steps.add(
          'Step ${_steps.length + 1}: Inserted ${_numbers[i]} into hash table at index $i');
      _iterations.add(List.from(_numbers));
      _highlightedIndices.add(i);

      setState(() {
        _currentStep = _steps.length - 1;
      });

      await Future.delayed(Duration(milliseconds: widget.speed.toInt()));
    }

    if (hashTable.containsKey(_target)) {
      _steps.add(
          'Step ${_steps.length + 1}: Found $_target at index ${hashTable[_target]} in hash table');
      _foundTarget = true;
      _targetIndex = hashTable[_target];
    } else {
      _steps.add('Step ${_steps.length + 1}: $_target not found in hash table');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.algorithm} Animation'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
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
            icon: Icon(Icons.info_outline),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AlgorithmCodePage(algorithm: widget.algorithm),
                ),
              );
            },
            icon: Icon(Icons.code),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Searching for $_target using ${widget.algorithm}',
              style: TextStyle(color: Colors.purple, fontSize: 18),
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _steps.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedOpacity(
                        duration: Duration(milliseconds: 300),
                        opacity: 1,
                        child: ListTile(
                          title: Text(_steps[index]),
                        ),
                      ),
                      if (_iterations.isNotEmpty && index < _iterations.length)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                              _iterations[index].asMap().entries.map((entry) {
                            int i = entry.key;
                            int value = entry.value;
                            bool isHighlighted =
                                _highlightedIndices[index] == i;
                            bool isTarget = _foundTarget && i == _targetIndex;

                            return ScaleTransition(
                              scale: CurvedAnimation(
                                parent: AnimationController(
                                  duration: const Duration(milliseconds: 300),
                                  vsync: this,
                                )..forward(),
                                curve: Curves.easeIn,
                              ),
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 2),
                                width: 40,
                                height: 40,
                                color: isTarget
                                    ? Colors.green
                                    : isHighlighted
                                        ? Colors.red
                                        : Colors.blue,
                                child: Center(
                                  child: Text(
                                    '$value',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                    ],
                  );
                },
              ),
            ),
            if (_foundTarget && _targetIndex != null) ...[
              Text(
                'Target element found: ${widget.numbers[_targetIndex!]} (at index $_targetIndex)',
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ] else if (!_isSearching) ...[
              Text(
                'Target element not found.',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back),
        backgroundColor: Colors.purple,
      ),
    );
  }
}
