// algorithm_descriptions.dart

import 'package:flutter/material.dart';

// Map containing descriptions for each algorithm
const Map<String, String> algorithmDescriptions = {
  'Bubble Sort': '\n'
      'Bubble Sort is the simplest sorting algorithm that works by repeatedly swapping the adjacent elements if they are in the wrong order. This algorithm is not suitable for large data sets as its average and worst-case time complexity are quite high.\n\n'
      'Steps: \n'
      '1. Start at the beginning of the array.\n'
      '2. Compare the current element with the next element.\n'
      '3. If the current element is greater, swap them.\n'
      '4. Move to the next pair and repeat the process.\n'
      '5. After each complete pass, the largest unsorted element is "bubbled" to its correct position.\n'
      '6. Repeat until the entire array is sorted.\n\n'
      'Time Complexity : O(n^2)',
  'Selection Sort': '\n'
      'Selection Sort is a comparison-based sorting algorithm. It sorts an array by repeatedly selecting the smallest (or largest) element from the unsorted portion and swapping it with the first unsorted element. This process continues until the entire array is sorted.\n\n'
      'Steps: \n'
      '1. Find the smallest element in the array.\n'
      '2. Swap it with the first element.\n'
      '3. Move to the next unsorted portion.\n'
      '4. Repeat the process for all elements.\n\n'
      'Time Complexity : O(n^2)',
  'Insertion Sort': '\n'
      'Insertion sort is a simple sorting algorithm that works by iteratively inserting each element of an unsorted list into its correct position in a sorted portion of the list.\n\n'
      'Steps: \n'
      '1. Assume the first element is already sorted.\n'
      '2. Pick the next element and compare it with elements in the sorted portion.\n'
      '3. Shift larger elements one position to the right.\n'
      '4. Insert the picked element in its correct position.\n'
      '5. Repeat for all elements.\n\n'
      'Time Complexity : \n'
      'Best case: O(n)\n'
      'Average case: O(n^2)\n'
      'Worst case: O(n^2)',
  'Radix Sort': '\n'
      'Radix Sort is a linear sorting algorithm that sorts elements by processing them digit by digit. It is efficient for integers or strings with fixed-size keys.\n\n'
      'Steps: \n'
      '1. Find the Maximum Number to determine the number of digits.\n'
      '2. Sort by the Least Significant Digit (LSD) using a stable sorting algorithm.\n'
      '3. Sort by the next digit and repeat.\n'
      '4. Continue until all digits are processed.\n\n'
      'Time Complexity : O(d*(n+b))',
  'Shell Sort': '\n'
      'Shell sort is a variation of Insertion Sort that allows for the exchange of far items. It divides the array into subarrays and reduces the gap with each iteration.\n\n'
      'Steps: \n'
      '1. Divide the array into subarrays using a gap.\n'
      '2. Sort each subarray using insertion sort.\n'
      '3. Reduce the gap and repeat until the gap is 1.\n\n'
      'Time Complexity : O(n^{1.25})',
  'Quick Sort': '\n'
      'QuickSort is based on Divide and Conquer, picking a pivot and partitioning the array around it.\n\n'
      'Steps: \n'
      '1. Select a pivot element.\n'
      '2. Rearrange elements to place smaller elements left and larger right.\n'
      '3. Recursively apply to left and right subarrays.\n\n'
      'Time Complexity : \n'
      'Best case: Ω(n log n)\n'
      'Average case: ϴ(n log n)\n'
      'Worst case: O(n^2)',
  'Heap Sort': '\n'
      'Heap sort uses a Binary Heap structure to sort by first building a max-heap.\n\n'
      'Steps: \n'
      '1. Build a max-heap from the input array.\n'
      '2. Swap the root with the last element.\n'
      '3. Reduce heap size and heapify the root.\n\n'
      'Time Complexity : O(n log n)',
  'Merge Sort': '\n'
      'Merge sort divides the input array, sorts subarrays, and merges them back together.\n\n'
      'Steps: \n'
      '1. Divide the array into halves.\n'
      '2. Recursively divide until size 1.\n'
      '3. Merge sorted halves.\n\n'
      'Time Complexity : O(n log n)',
};

// Widget to display the description of a selected sorting algorithm
class AlgorithmSortingPage extends StatelessWidget {
  final String algorithm;

  AlgorithmSortingPage({
    required this.algorithm,
  });

  @override
  Widget build(BuildContext context) {
    String description =
        algorithmDescriptions[algorithm] ?? 'No description available';

    return Scaffold(
      appBar: AppBar(
        title: Text('$algorithm Algorithm Description'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          description,
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }
}
