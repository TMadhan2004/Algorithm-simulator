import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import this for TextInputFormatter
import 'sorting_animation_page.dart';
import 'comparison_page.dart'; // Import the new comparison page
import 'package:syncfusion_flutter_charts/charts.dart';

class SortingPage extends StatefulWidget {
  @override
  _SortingPageState createState() => _SortingPageState();
}

class _SortingPageState extends State<SortingPage> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  List<int> _numbers = [];
  Set<String> _selectedAlgorithms = {}; // Use a Set to store selected algorithms
  double _speed = 3000; // Default speed

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<String> _sortingAlgorithms = [
    'Bubble Sort',
    'Insertion Sort',
    'Shell Sort',
    'Heap Sort',
    'Radix Sort',
    'Merge Sort',
    'Quick Sort',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onAlgorithmSelected(bool selected, String algorithm) {
    setState(() {
      if (selected) {
        _selectedAlgorithms.add(algorithm);
      } else {
        _selectedAlgorithms.remove(algorithm);
      }
    });
  }

  void _generateAndSort() {
    setState(() {
      _numbers = _controller.text.split(',').map((e) => int.tryParse(e.trim()) ?? 0).toList();
    });

    if (_numbers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter numbers to sort.')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SortingAnimationPage(
          numbers: _numbers,
          algorithm: _selectedAlgorithms.isNotEmpty ? _selectedAlgorithms.first : 'Bubble Sort',
          speed: _speed,
        ),
      ),
    );
  }

  void _compareSelectedAlgorithms() {
    if (_selectedAlgorithms.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select at least 2 sorts to compare.')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ComparisonPage(
          selectedAlgorithms: _selectedAlgorithms.toList(),
          numbers: _numbers,
          speed: _speed,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sorting Algorithms'),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Enter numbers (comma-separated)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
                ],
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: _sortingAlgorithms.length,
                  itemBuilder: (context, index) {
                    final algorithm = _sortingAlgorithms[index];
                    return CheckboxListTile(
                      title: Text(algorithm),
                      value: _selectedAlgorithms.contains(algorithm),
                      onChanged: (selected) {
                        _onAlgorithmSelected(selected ?? false, algorithm);
                      },
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: _generateAndSort,
                child: Text('Sort'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _compareSelectedAlgorithms,
                child: Text('Comparison'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
