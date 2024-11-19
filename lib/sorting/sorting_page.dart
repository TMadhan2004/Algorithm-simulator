import 'package:flutter/material.dart';
import 'sorting_animation_page.dart';
import 'comparison_page.dart';
import 'package:video_player/video_player.dart';

class SortingPage extends StatefulWidget {
  @override
  _SortingPageState createState() => _SortingPageState();
}

class _SortingPageState extends State<SortingPage> {
  final TextEditingController _numbersController = TextEditingController();
  List<int> _numbers = [];
  List<String> _selectedAlgorithms = [];

  final List<String> _algorithms = [
    'Bubble Sort',
    'Selection Sort',
    'Insertion Sort',
    'Shell Sort',
    'Heap Sort',
    'Radix Sort',
    'Merge Sort',
    'Quick Sort',
  ];

  bool _parseInput() {
    String input = _numbersController.text;

    final RegExp validInputPattern = RegExp(r'^(-?\d+\s*,\s*)*-?\d+$');

    if (!validInputPattern.hasMatch(input)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter only numbers separated by commas.')),
      );
      return false;
    }

    setState(() {
      _numbers = input.split(',').map((e) => int.parse(e.trim())).toList();
    });
    return true;
  }

  void _goToSortingAnimation(String algorithm) {
    if (_parseInput() && _numbers.isNotEmpty) {
      if (_numbers.length > 20) {
        _showMaxInputDialog();
      } else {
        _showLoadingDialog(() {
          Navigator.pop(context);
          _navigateToSortingAnimation(algorithm);
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter numbers to sort.')),
      );
    }
  }

  void _goToComparisonPage() {
    if (_parseInput() && _numbers.isNotEmpty) {
      if (_numbers.length > 20) {
        _showMaxInputDialog();
      } else if (_selectedAlgorithms.length < 2) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select at least two algorithms for comparison.')),
        );
      } else {
        _showLoadingDialog(() {
          Navigator.pop(context); // Close loading dialog
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ComparisonPage(
                    selectedAlgorithms: _selectedAlgorithms,
                    numbers: _numbers,
                    speed: 1, // Default speed for comparison
                  ),
            ),
          );
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter numbers to compare.')),
      );
    }
  }

  void _showMaxInputDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Input Limit Exceeded'),
        content: Text('You can only enter up to 20 numbers for sorting or comparison. Please reduce the number of inputs.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showLoadingDialog(VoidCallback onComplete) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return LoadingDialog(onComplete: onComplete);
      },
    );
  }

  void _navigateToSortingAnimation(String algorithm) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SortingAnimationPage(
          numbers: _numbers,
          algorithm: algorithm,
          speed: 1, // Default speed for sorting animation
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sorting Algorithms'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input for numbers
            TextField(
              controller: _numbersController,
              decoration: InputDecoration(
                labelText: 'Enter numbers separated by commas',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),

            // Buttons for sorting algorithms
            Text(
              'Choose a sorting algorithm:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _algorithms.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ElevatedButton(
                      onPressed: () {
                        _goToSortingAnimation(_algorithms[index]);
                      },
                      child: Text(_algorithms[index]),
                    ),
                  );
                },
              ),
            ),

            // Centered comparison button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _showAlgorithmSelectionDialog();
                },
                child: Text('Comparison'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAlgorithmSelectionDialog() {
    final List<String> comparisonAlgorithms = _algorithms
        .where((algorithm) => algorithm != 'Merge Sort' && algorithm != 'Radix Sort' && algorithm != 'Heap Sort' && algorithm != 'Quick Sort')
        .toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Select algorithms to compare'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: comparisonAlgorithms.map((algorithm) {
                    bool isSelected = _selectedAlgorithms.contains(algorithm);
                    return CheckboxListTile(
                      title: Text(algorithm),
                      value: isSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            _selectedAlgorithms.add(algorithm);
                          } else {
                            _selectedAlgorithms.remove(algorithm);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
                TextButton(
                  child: Text('Compare'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the selection dialog
                    _goToComparisonPage(); // Call to navigate with loading dialog
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class LoadingDialog extends StatefulWidget {
  final Function onComplete;

  const LoadingDialog({Key? key, required this.onComplete}) : super(key: key);

  @override
  _LoadingDialogState createState() => _LoadingDialogState();
}

class _LoadingDialogState extends State<LoadingDialog> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/loading.mov')
      ..initialize().then((_) {
        setState(() {
          _controller.setLooping(false);
          _controller.play();
        });

        Future.delayed(Duration(seconds: 3), () {
          widget.onComplete();
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.0),
      ),
      backgroundColor: Colors.white,
      child: Container(
        width: 200,
        height: 200,
        child: Center(
          child: _controller.value.isInitialized
              ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
              : CircularProgressIndicator(),
        ),
      ),
    );
  }
}
