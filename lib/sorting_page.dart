import 'package:flutter/material.dart';
import 'sorting_animation_page.dart';  // Ensure this file exists for sorting animations

class SortingPage extends StatefulWidget {
  @override
  _SortingPageState createState() => _SortingPageState();
}

class _SortingPageState extends State<SortingPage> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  List<int> _numbers = [];
  String _algorithm = 'Bubble Sort';
  double _speed = 3000; // Default speed

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<String> _sortingAlgorithms = [
    'Bubble Sort',
    'Selection Sort',
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
          algorithm: _algorithm,
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
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 3,
                  ),
                  itemCount: _sortingAlgorithms.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _algorithm = _sortingAlgorithms[index];
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: _algorithm == _sortingAlgorithms[index] ? Colors.blue : Colors.grey[300],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            _sortingAlgorithms[index],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _algorithm == _sortingAlgorithms[index] ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
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
            ],
          ),
        ),
      ),
    );
  }
}
