import 'package:flutter/material.dart';
import 'sorting/sorting_page.dart';  // Ensure this file exists for sorting animations
import 'sorting/comparison_page.dart';// Import the new comparison page
import 'splash_screen.dart';  // Import the splash screen
import 'home_page.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
void main() {
  runApp(SortingSimulatorApp());
}

class SortingSimulatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Algorithm Simulator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
      ),
      home: SplashScreen(),
      routes: {
        '/sorting': (context) => SortingPage(),
        '/comparison': (context) => ComparisonPage(
          selectedAlgorithms: [], // Pass actual data or handle it in the page itself
          numbers: [], // Pass actual data or handle it in the page itself
          speed: 0, // Pass actual data or handle it in the page itself
        ),
      },
    );
  }
}
