import 'package:flutter/material.dart';

class SearchingAlgorithmDescriptionPage extends StatelessWidget {
  final String algorithm;

  SearchingAlgorithmDescriptionPage({required this.algorithm});

  @override
  Widget build(BuildContext context) {
    // Example descriptions
    Map<String, List<String>> descriptions = {
      'Linear Search': [
        'Start from the first element of the list.',
        'Compare each element with the target.',
        'If the target is found, return the index.',
        'If the target is not found, continue to the next element.',
        'If the end of the list is reached without finding the target, return -1.'
      ],
      'Binary Search': [
        'Start with the entire list and sort it.',
        'Calculate the middle index of the list.',
        'Compare the target with the middle element.',
        'If the target is equal to the middle element, return the index.',
        'If the target is less than the middle element, repeat for the left half of the list.',
        'If the target is greater, repeat for the right half.',
        'If the target is not found, return -1.'
      ],
      'Hashing': [
        'Create a hash table to store elements.',
        'Calculate the hash index for each element.',
        'Insert each element into the hash table at the calculated index.',
        'To search, calculate the hash index for the target.',
        'Check the hash table at the calculated index.',
        'If the target is found, return the index.',
        'If the target is not found, return -1.'
      ],
    };

    // Time complexities
    Map<String, Map<String, String>> timeComplexities = {
      'Linear Search': {
        'Best': 'O(1)',
        'Average': 'O(n)',
        'Worst': 'O(n)',
        'Description':
            ' Linear search, also known as sequential search, is a simple searching algorithm that checks each element in a list or array one by one until the target element is found or the end of the list is reached.'
      },
      'Binary Search': {
        'Best': 'O(1)',
        'Average': 'O(log n)',
        'Worst': 'O(log n)',
        'Description':
            'Binary search is a more efficient searching algorithm that works on sorted arrays. It repeatedly divides the search interval in half, comparing the target value to the middle element of the array.'
      },
      'Hashing': {
        'Best': 'O(1)',
        'Average': 'O(1)',
        'Worst': 'O(n)',
        'Description':
            'Hashing uses a hash function to map data to fixed-size values for indexing. '
                'It is efficient for data access.',
      },
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('$algorithm Description'),
        backgroundColor: Colors.purple, // Purple AppBar
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Description
            Text(
              'Description:',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple),
            ),
            SizedBox(height: 5),
            Text(
              timeComplexities[algorithm]!['Description']!,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16), // Match step font size and color
            ),
            SizedBox(height: 20),
            // Steps
            Text(
              'Steps:',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple),
            ),
            SizedBox(height: 10),
            ...descriptions[algorithm]!.asMap().entries.map((entry) {
              int index = entry.key + 1; // Increment index for numbering
              String step = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  '$index. $step',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16), // Match step font size and color
                ),
              );
            }).toList(),
            SizedBox(height: 20),
            // Time Complexity
            Text(
              'Time Complexity:',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple),
            ),
            SizedBox(height: 10),
            Table(
              border: TableBorder.all(color: Colors.purple),
              children: [
                TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Best',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Average',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Worst',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ]),
                TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(timeComplexities[algorithm]!['Best']!,
                        style: TextStyle(color: Colors.black)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(timeComplexities[algorithm]!['Average']!,
                        style: TextStyle(color: Colors.black)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(timeComplexities[algorithm]!['Worst']!,
                        style: TextStyle(color: Colors.black)),
                  ),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
