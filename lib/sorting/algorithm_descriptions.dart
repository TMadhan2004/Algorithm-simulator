import 'package:flutter/material.dart';

// Map containing descriptions and time complexities for each sorting algorithm
const Map<String, Map<String, dynamic>> algorithmDescriptions = {
  'Bubble Sort': {
    'Description':
        'Bubble Sort is the simplest sorting algorithm that works by repeatedly swapping the adjacent elements if they are in the wrong order. This algorithm is not suitable for large data sets as its average and worst-case time complexity are quite high.',
    'Steps': [
      '1. Start at the beginning of the array.',
      '2. Compare the current element with the next element.',
      '3. If the current element is greater, swap them.',
      '4. Move to the next pair and repeat the process.',
      '5. After each complete pass, the largest unsorted element is "bubbled" to its correct position.',
      '6. Repeat until the entire array is sorted.'
    ],
    'Time Complexity': {
      'Best': 'O(n)',
      'Average': 'O(n^2)',
      'Worst': 'O(n^2)',
    }
  },
  'Selection Sort': {
    'Description':
        'Selection Sort is a comparison-based sorting algorithm. It sorts an array by repeatedly selecting the smallest (or largest) element from the unsorted portion and swapping it with the first unsorted element.',
    'Steps': [
      '1. Find the smallest element in the array.',
      '2. Swap it with the first element.',
      '3. Move to the next unsorted portion.',
      '4. Repeat the process for all elements.'
    ],
    'Time Complexity': {
      'Best': 'O(n^2)',
      'Average': 'O(n^2)',
      'Worst': 'O(n^2)',
    }
  },
  'Insertion Sort': {
    'Description':
        'Insertion sort is a simple sorting algorithm that works by iteratively inserting each element of an unsorted list into its correct position in a sorted portion of the list.',
    'Steps': [
      '1. Assume the first element is already sorted.',
      '2. Pick the next element and compare it with elements in the sorted portion.',
      '3. Shift larger elements one position to the right.',
      '4. Insert the picked element in its correct position.'
    ],
    'Time Complexity': {
      'Best': 'O(n)',
      'Average': 'O(n^2)',
      'Worst': 'O(n^2)',
    }
  },
  'Radix Sort': {
    'Description':
        'Radix Sort is a linear sorting algorithm that sorts elements by processing them digit by digit. It is efficient for integers or strings with fixed-size keys.',
    'Steps': [
      '1. Find the Maximum Number to determine the number of digits.',
      '2. Sort by the Least Significant Digit (LSD) using a stable sorting algorithm.',
      '3. Sort by the next digit and repeat.',
      '4. Continue until all digits are processed.'
    ],
    'Time Complexity': {
      'Best': 'O(d*(n+b))',
      'Average': 'O(d*(n+b))',
      'Worst': 'O(d*(n+b))',
    }
  },
  'Shell Sort': {
    'Description':
        'Shell sort is a variation of Insertion Sort that allows for the exchange of far items. It divides the array into subarrays and reduces the gap with each iteration.',
    'Steps': [
      '1. Divide the array into subarrays using a gap.',
      '2. Sort each subarray using insertion sort.',
      '3. Reduce the gap and repeat until the gap is 1.'
    ],
    'Time Complexity': {
      'Best': 'O(n log n)',
      'Average': 'O(n^{1.25})',
      'Worst': 'O(n^2)',
    }
  },
  'Quick Sort': {
    'Description':
        'QuickSort is based on Divide and Conquer, picking a pivot and partitioning the array around it.',
    'Steps': [
      '1. Select a pivot element.',
      '2. Rearrange elements to place smaller elements left and larger right.',
      '3. Recursively apply to left and right subarrays.'
    ],
    'Time Complexity': {
      'Best': 'O(n log n)',
      'Average': 'O(n log n)',
      'Worst': 'O(n^2)',
    }
  },
  'Heap Sort': {
    'Description':
        'Heap sort uses a Binary Heap structure to sort by first building a max-heap.',
    'Steps': [
      '1. Build a max-heap from the input array.',
      '2. Swap the root with the last element.',
      '3. Reduce heap size and heapify the root.'
    ],
    'Time Complexity': {
      'Best': 'O(n log n)',
      'Average': 'O(n log n)',
      'Worst': 'O(n log n)',
    }
  },
  'Merge Sort': {
    'Description':
        'Merge sort divides the input array, sorts subarrays, and merges them back together.',
    'Steps': [
      '1. Divide the array into halves.',
      '2. Recursively divide until size 1.',
      '3. Merge sorted halves.'
    ],
    'Time Complexity': {
      'Best': 'O(n log n)',
      'Average': 'O(n log n)',
      'Worst': 'O(n log n)',
    }
  },
};

// Widget to display the description of a selected sorting algorithm
class AlgorithmSortingPage extends StatelessWidget {
  final String algorithm;

  AlgorithmSortingPage({
    required this.algorithm,
  });

  @override
  Widget build(BuildContext context) {
    final details = algorithmDescriptions[algorithm]!;
    final steps = details['Steps'] as List<String>;
    final timeComplexity = details['Time Complexity'] as Map<String, String>;

    return Scaffold(
      appBar: AppBar(
        title: Text('$algorithm Algorithm Description'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Description Section
            Text(
              'Description:',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple),
            ),
            SizedBox(height: 10),
            Text(
              details['Description'],
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 20),
            // Steps Section
            Text(
              'Steps:',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple),
            ),
            SizedBox(height: 10),
            ...steps.map((step) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  step,
                  style: TextStyle(fontSize: 16),
                ),
              );
            }).toList(),
            SizedBox(height: 20),
            // Time Complexity Section
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
                    child: Text('Case',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Complexity',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ]),
                TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Best', style: TextStyle(color: Colors.black)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(timeComplexity['Best']!,
                        style: TextStyle(color: Colors.black)),
                  ),
                ]),
                TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        Text('Average', style: TextStyle(color: Colors.black)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(timeComplexity['Average']!,
                        style: TextStyle(color: Colors.black)),
                  ),
                ]),
                TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Worst', style: TextStyle(color: Colors.black)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(timeComplexity['Worst']!,
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
