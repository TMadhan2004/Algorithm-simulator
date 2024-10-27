import 'package:flutter/material.dart';

class SearchingAlgorithmDescriptionPage extends StatelessWidget {
  final String algorithm;

  SearchingAlgorithmDescriptionPage({required this.algorithm});

  @override
  Widget build(BuildContext context) {
    // Example descriptions
    Map<String, List<String>> descriptions = {
      'Linear Search': [
        '1. Start from the first element of the list.',
        '2. Compare each element with the target.',
        '3. If the target is found, return the index.',
        '4. If the target is not found, continue to the next element.',
        '5. If the end of the list is reached without finding the target, return -1.'
      ],
      'Binary Search': [
        '1. Start with the entire list and sort it.',
        '2. Calculate the middle index of the list.',
        '3. Compare the target with the middle element.',
        '4. If the target is equal to the middle element, return the index.',
        '5. If the target is less than the middle element, repeat for the left half of the list.',
        '6. If the target is greater, repeat for the right half.',
        '7. If the target is not found, return -1.'
      ],
      'Hashing': [
        '1. Create a hash table to store elements.',
        '2. Calculate the hash index for each element.',
        '3. Insert each element into the hash table at the calculated index.',
        '4. To search, calculate the hash index for the target.',
        '5. Check the hash table at the calculated index.',
        '6. If the target is found, return the index.',
        '7. If the target is not found, return -1.'
      ],
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('$algorithm Description'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,// Purple AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: descriptions[algorithm]?.length ?? 0,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  descriptions[algorithm]![index],
                  style: TextStyle(
                      color: Colors.purple[900],
                      fontSize: 16), // Dark purple text
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
