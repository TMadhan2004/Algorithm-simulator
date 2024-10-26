import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Define code snippets
const Map<String, Map<String, String>> codeSnippets = {
  'Linear Search': {
    'C': '''
#include <stdio.h>
int linearSearch(int arr[], int n, int target) {
  for (int i = 0; i < n; i++) {
    if (arr[i] == target) {
      return i;
    }
  }
  return -1;
}
    ''',
    'C++': '''
#include <iostream>
using namespace std;
int linearSearch(int arr[], int n, int target) {
  for (int i = 0; i < n; i++) {
    if (arr[i] == target) {
      return i;
    }
  }
  return -1;
}
    ''',
    'Java': '''
public class LinearSearch {
  public static int linearSearch(int[] arr, int target) {
    for (int i = 0; i < arr.length; i++) {
      if (arr[i] == target) {
        return i;
      }
    }
    return -1;
  }
}
    ''',
    'Python': '''
def linear_search(arr, target):
  for i in range(len(arr)):
    if arr[i] == target:
      return i
  return -1
    '''
  },
  'Binary Search': {
    'C': '''
#include <stdio.h>
int binarySearch(int arr[], int left, int right, int target) {
  while (left <= right) {
    int mid = left + (right - left) / 2;
    if (arr[mid] == target) return mid;
    if (arr[mid] < target) left = mid + 1;
    else right = mid - 1;
  }
  return -1;
}
    ''',
    'C++': '''
#include <iostream>
using namespace std;
int binarySearch(int arr[], int left, int right, int target) {
  while (left <= right) {
    int mid = left + (right - left) / 2;
    if (arr[mid] == target) return mid;
    if (arr[mid] < target) left = mid + 1;
    else right = mid - 1;
  }
  return -1;
}
    ''',
    'Java': '''
public class BinarySearch {
  public static int binarySearch(int[] arr, int target) {
    int left = 0, right = arr.length - 1;
    while (left <= right) {
      int mid = left + (right - left) / 2;
      if (arr[mid] == target) return mid;
      if (arr[mid] < target) left = mid + 1;
      else right = mid - 1;
    }
    return -1;
  }
}
    ''',
    'Python': '''
def binary_search(arr, target):
  left, right = 0, len(arr) - 1
  while left <= right:
    mid = left + (right - left) // 2
    if arr[mid] == target:
      return mid
    elif arr[mid] < target:
      left = mid + 1
    else:
      right = mid - 1
  return -1
    '''
  },
  'Hashing': {
    'C': '''
#include <stdio.h>
#define SIZE 10
int hashTable[SIZE];
int hashFunction(int key) {
  return key % SIZE;
}
void insert(int key) {
  int index = hashFunction(key);
  hashTable[index] = key;
}
    ''',
    'C++': '''
#include <iostream>
#define SIZE 10
int hashTable[SIZE];
int hashFunction(int key) {
  return key % SIZE;
}
void insert(int key) {
  int index = hashFunction(key);
  hashTable[index] = key;
}
    ''',
    'Java': '''
import java.util.HashMap;
public class Hashing {
  public static HashMap<Integer, Integer> hashTable = new HashMap<>();
  public static void insert(int key) {
    int index = key % 10;
    hashTable.put(index, key);
  }
}
    ''',
    'Python': '''
hash_table = {}
def insert(key):
  index = key % 10
  hash_table[index] = key
    '''
  }
};

class AlgorithmCodePage extends StatefulWidget {
  final String algorithm;

  AlgorithmCodePage({required this.algorithm});

  @override
  _AlgorithmCodePageState createState() => _AlgorithmCodePageState();
}

class _AlgorithmCodePageState extends State<AlgorithmCodePage> {
  String _selectedLanguage = 'Python';
  bool _isDarkTheme = false;

  @override
  Widget build(BuildContext context) {
    // Get the code for the selected algorithm and language
    String code = codeSnippets[widget.algorithm]?[_selectedLanguage] ??
        'Code not available';

    // Time complexities and explanations for different algorithms
    Map<String, Map<String, String>> timeComplexities = {
      'Linear Search': {
        'Best': 'O(1)',
        'Average': 'O(n)',
        'Worst': 'O(n)',
        'Description': 'Best-case: The element is found at the first index. '
            'Worst-case: The element is found at the last index or is not present in the array.',
      },
      'Binary Search': {
        'Best': 'O(1)',
        'Average': 'O(log n)',
        'Worst': 'O(log n)',
        'Description': 'Best-case: The element is found at the middle index. '
            'Worst-case: The target element is either the first element, the last element, or not present.',
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

    var complexities = timeComplexities[widget.algorithm] ??
        {
          'Best': 'N/A',
          'Average': 'N/A',
          'Worst': 'N/A',
          'Description': 'N/A',
        };

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.algorithm} Code'),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Language Dropdown
                DropdownButtonHideUnderline(
                  child: InkWell(
                    splashColor: Colors.transparent, // Remove splash color
                    highlightColor:
                        Colors.transparent, // Remove highlight color
                    child: DropdownButton<String>(
                      value: _selectedLanguage,
                      dropdownColor:
                          Colors.purple[100], // Set dropdown background color
                      iconEnabledColor:
                          Colors.purple, // Change icon color to purple
                      items:
                          ['C', 'C++', 'Java', 'Python'].map((String language) {
                        return DropdownMenuItem<String>(
                          value: language,
                          child: Text(
                            language,
                            style: TextStyle(
                                color: Colors.purple), // Set text color
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newLanguage) {
                        setState(() {
                          _selectedLanguage = newLanguage!;
                        });
                      },
                      selectedItemBuilder: (BuildContext context) {
                        return ['C', 'C++', 'Java', 'Python']
                            .map<Widget>((String value) {
                          return Text(
                            value,
                            style: TextStyle(
                                color:
                                    Colors.purple), // Set selected text color
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
                // Theme Toggle Button
                IconButton(
                  icon: Icon(Icons.brightness_6,
                      color: Colors.purple), // Set icon color to purple
                  onPressed: () {
                    setState(() {
                      _isDarkTheme = !_isDarkTheme;
                    });
                  },
                ),
                // Copy to Clipboard Button
                IconButton(
                  icon: Icon(Icons.copy,
                      color: Colors.purple), // Set icon color to purple
                  onPressed: () async {
                    if (await Clipboard.setData(ClipboardData(text: code))
                        .then((_) => true)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Code copied to clipboard')),
                      );
                    } else {
                      // Web workaround
                      final controller = TextEditingController(text: code);
                      await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Copy Code"),
                          content: TextField(
                            controller: controller,
                            readOnly: true,
                            decoration: InputDecoration(
                              hintText:
                                  "Copy manually if clipboard is restricted.",
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: Text("Close"),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          // Code Display Area
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              color: _isDarkTheme ? Colors.black87 : Colors.white,
              // Set a fixed height and width for the code container
              constraints: BoxConstraints(
                maxWidth: 400, // Fixed width of the code window
                maxHeight: 300, // Fixed height of the code window
              ),
              child: Scrollbar(
                thumbVisibility: true, // Always show the scrollbar thumbs
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical, // Vertical scrolling
                  child: SingleChildScrollView(
                    scrollDirection:
                        Axis.horizontal, // Horizontal scrolling for long lines
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: 400, // Match the width of the window
                        minHeight: 300, // Match the height of the window
                      ),
                      child: SelectableText(
                        code,
                        style: TextStyle(
                          color: _isDarkTheme ? Colors.white : Colors.black,
                          fontFamily: 'monospace',
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Time Complexity Table
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Time Complexity',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
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
                        child: Text(complexities['Best']!),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(complexities['Average']!),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(complexities['Worst']!),
                      ),
                    ]),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  'Description:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                SizedBox(height: 5),
                Text(complexities['Description']!),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
