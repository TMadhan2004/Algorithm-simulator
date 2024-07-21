// algorithm_descriptions.dart

const Map<String, String> algorithmDescriptions = {
  'Bubble Sort': 'Bubble Sort:\n'
      '1. Compare adjacent elements and swap if in wrong order.\n'
      '2. Repeat for all elements until the array is sorted.',
  'Selection Sort': 'Selection Sort:\n'
      '1. Initialize: Start with an unsorted array. Assume the first element (at index 0) is the minimum.\n'
      '2. Find the Minimum: Iterate through the array starting from the current position to the end to find the minimum element.\n'
      '3. Swap: Swap the minimum element found with the element at the current position.\n'
      '4. Repeat: Move to the next position in the array. Repeat steps 2 and 3 until the array is fully sorted.',
  'Insertion Sort': 'Insertion Sort:\n'
      '1. Start with the first element, assuming it\'s sorted.\n'
      '2. Take the next element and insert it into the sorted part of the array.\n'
      '3. Repeat until the array is fully sorted.',
  'Radix Sort': 'Radix Sort:\n'
      '1. Sort the elements based on the least significant digit.\n'
      '2. Move to the next significant digit and sort.\n'
      '3. Repeat for all digit places until the array is sorted.',
  'Shell Sort': 'Shell Sort:\n'
      '1. Divide the array into smaller sub-arrays.\n'
      '2. Sort each sub-array using insertion sort.\n'
      '3. Repeat until the array is fully sorted.',
  'Quick Sort': 'Quick Sort:\n'
      '1. Choose a pivot element.\n'
      '2. Partition the array into two halves around the pivot.\n'
      '3. Recursively sort the sub-arrays.',
  'Heap Sort': 'Heap Sort:\n'
      '1. Build a max heap from the input array.\n'
      '2. Swap the root (maximum value) with the last element.\n'
      '3. Reduce the heap size and heapify the root.\n'
      '4. Repeat until the array is sorted.',
  'Merge Sort': 'Merge Sort:\n'
      '1. Divide the array into two halves.\n'
      '2. Recursively sort each half.\n'
      '3. Merge the two sorted halves into one sorted array.',
};
