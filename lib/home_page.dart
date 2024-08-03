import 'package:flutter/material.dart';
import 'sorting_page.dart';  // Ensure this file exists for sorting animations

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _controller = PageController(initialPage: 1000); // Arbitrary high initial page for cyclic scrolling
  int _currentPage = 1000;

  final List<Map<String, String>> _pages = [
    {'image': 'assets/sort.png', 'label': 'Sorting Algorithms', 'heroTag': 'sort'},
    {'image': 'assets/search.png', 'label': 'Searching Algorithms', 'heroTag': 'search'},
    {'image': 'assets/graph.png', 'label': 'Graph Algorithms', 'heroTag': 'graph'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Algorithm Simulator'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (context, index) {
                int actualIndex = index % _pages.length; // Enable cyclic scrolling
                return GestureDetector(
                  onTap: () {
                    if (actualIndex == 0) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SortingPage(),
                        ),
                      );
                    } else {
                      // Handle navigation for other pages
                    }
                  },
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Hero(
                          tag: _pages[actualIndex]['heroTag']!,
                          child: Image.asset(_pages[actualIndex]['image']!),
                        ),
                        SizedBox(height: 16),
                        Text(
                          _pages[actualIndex]['label']!,
                          style: TextStyle(fontSize: 24),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_pages.length, (index) {
              return AnimatedContainer(
                duration: Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: 4),
                height: 12,
                width: _currentPage % _pages.length == index ? 12 : 8,
                decoration: BoxDecoration(
                  color: _currentPage % _pages.length == index ? Colors.blue : Colors.grey,
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
