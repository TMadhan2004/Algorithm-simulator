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
        foregroundColor: Colors.white,
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
              child: DropdownButton<String>(
                value: _selectedLanguage,
                dropdownColor: Colors.purple[100],
                items: ['C', 'C++', 'Java', 'Python']
                    .map((language) => DropdownMenuItem(
                          value: language,
                          child: Text(language, style: TextStyle(fontSize: 16)),
                        ))
                    .toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedLanguage = newValue!;
                  });
                },
              ),
            ),
            // Centered Dark Mode Icon
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: IconButton(
                icon: Icon(
                  _isDarkTheme ? Icons.brightness_3 : Icons.brightness_7,
                  color: Colors.purple,
                ),
                onPressed: () {
                  setState(() {
                    _isDarkTheme = !_isDarkTheme;
                  });
                },
              ),
            ),
            // Copy to Clipboard Button
            IconButton(
              icon: Icon(Icons.copy, color: Colors.purple),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: code));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Code copied to clipboard!')),
                );
              },
            ),
          ],
        ),
      ),
      // Code Display Area with SelectableText for partial copying
      Expanded(
        child: SingleChildScrollView(
          child: IntrinsicHeight(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              color: _isDarkTheme ? Colors.black : Colors.white,
              child: SelectableText(
                code,
                style: TextStyle(
                  fontSize: 12,
                  color: _isDarkTheme ? Colors.white : Colors.black,
                  fontFamily: 'Courier', // Code-style font
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ),
      ),
    ],
  ),
);
  }
}
