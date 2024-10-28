import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'searching_animation_page.dart';
import 'comparison_page.dart';

class SearchingPage extends StatefulWidget {
  @override
  _SearchingPageState createState() => _SearchingPageState();
}

class _SearchingPageState extends State<SearchingPage> {
  final TextEditingController _numbersController = TextEditingController();
  final TextEditingController _targetController = TextEditingController();
  List<int> _numbers = [];
  int? _target;
  List<String> _selectedAlgorithms = [];
  final List<String> _algorithms = [
    'Linear Search',
    'Binary Search',
    'Hashing'
  ];

  @override
  void initState() {
    super.initState();
    // Show the disclaimer dialog when the page is first initialized
    WidgetsBinding.instance.addPostFrameCallback((_) => _showDisclaimerDialog());
  }

  void _showDisclaimerDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Disclaimer'),
        content: Text(
          'Only 8 numbers are allowed. '
              'Integers can be entered as input. '
              'Please ensure you follow these restrictions while entering inputs.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  // Parse input for numbers
  void _parseInput() {
    setState(() {
      _numbers = _numbersController.text
          .split(',')
          .map((e) => int.tryParse(e.trim()) ?? 0)
          .toList();
    });
  }

  // Navigate to animation page with loading dialog
  void _goToAnimationPage(String algorithm) {
    _parseInput();
    _target = int.tryParse(_targetController.text);
    if (_numbers.isNotEmpty && _target != null) {
      _showLoadingDialog(() {
        Navigator.pop(context);
        _navigateToAnimation(algorithm);
      });
    } else {
      _showErrorSnackBar('Please enter valid numbers and target.');
    }
  }

  // Show loading dialog and navigate to ComparisonPage
  void _goToComparisonPage() {
    _parseInput();
    if (_selectedAlgorithms.length < 2) {
      _showErrorSnackBar('Select at least two algorithms for comparison.');
    } else if (_numbers.isEmpty) {
      _showErrorSnackBar('Enter numbers to compare.');
    } else {
      _showLoadingDialog(() {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ComparisonPage(
              selectedAlgorithms: _selectedAlgorithms,
              numbers: _numbers,
              target: _target ?? 0,
            ),
          ),
        );
      });
    }
  }

  // Navigate to SearchingAnimationPage
  void _navigateToAnimation(String algorithm) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchingAnimationPage(
          numbers: _numbers,
          algorithm: algorithm,
          target: _target!,
          speed: 500.0,
        ),
      ),
    );
  }

  // Show loading dialog with video animation
  void _showLoadingDialog(VoidCallback onComplete) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return LoadingDialog(onComplete: onComplete);
      },
    );
  }

  // Error handling
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Searching Algorithms'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _numbersController,
              decoration: InputDecoration(
                labelText: 'Enter numbers (comma separated)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _targetController,
              decoration: InputDecoration(
                labelText: 'Enter target number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            Text(
              'Choose a searching algorithm:',
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
                      onPressed: () => _goToAnimationPage(_algorithms[index]),
                      child: Text(_algorithms[index]),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () => _showAlgorithmSelectionDialog(),
              child: Text('Comparison'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Show algorithm selection dialog for comparison
  void _showAlgorithmSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Select algorithms to compare'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: _algorithms.map((algorithm) {
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
              actions: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: Text('Compare'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _goToComparisonPage();
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

// Loading dialog with video animation
class LoadingDialog extends StatefulWidget {
  final VoidCallback onComplete;

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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
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
