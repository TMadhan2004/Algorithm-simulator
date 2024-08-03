import 'package:flutter/material.dart';
import 'splash_screen.dart';  // Import the splash screen
import 'sorting_page.dart';  // Ensure this file exists for sorting animations
import 'home_page.dart';     // Create a separate file for HomePage to avoid cyclic imports

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
      ),
      home: SplashScreen(),  // Start with SplashScreen
    );
  }
}
