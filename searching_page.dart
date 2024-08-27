import 'package:flutter/material.dart';
import 'searching_animation_page.dart';

class SearchingPage extends StatefulWidget {
  @override
  _SearchingPageState createState() => _SearchingPageState();
}

class _SearchingPageState extends State<SearchingPage> {
  final List<int> _numbers = [];
  int? _target;
  String? _selectedAlgorithm;

  void _navigateToAnimationPage() {
    if (_selectedAlgorithm != null && _target != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchingAnimationPage(
            numbers: _numbers,
            algorithm: _selectedAlgorithm!,
            target: _target!,
            speed: 500.0, // Adjust speed as needed
          ),
        ),
      );
    } else {
      // Handle case where algorithm or target is not selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter the numbers, target, and select an algorithm')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Searching Algorithms'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Enter numbers (comma separated)'),
              onChanged: (value) {
                setState(() {
                  _numbers.clear();
                  if (value.isNotEmpty) {
                    _numbers.addAll(value.split(',').map(int.parse));
                  }
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Enter target number'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _target = int.tryParse(value);
                });
              },
            ),
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedAlgorithm = 'Linear Search';
                    });
                    _navigateToAnimationPage();
                  },
                  child: Text('Linear Search'),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedAlgorithm = 'Binary Search';
                    });
                    _navigateToAnimationPage();
                  },
                  child: Text('Binary Search'),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedAlgorithm = 'Hashing';
                    });
                    _navigateToAnimationPage();
                  },
                  child: Text('Hashing'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
