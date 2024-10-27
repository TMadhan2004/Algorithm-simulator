import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Define code snippets for Kruskal's Algorithm
const Map<String, Map<String, String>> codeSnippets = {
  'Kruskal\'s': {
    'C': '''
#include <stdio.h>
#include <stdlib.h>

#define V 5

typedef struct {
    int src, dest, weight;
} Edge;

int compare(const void* a, const void* b) {
    return ((Edge*)a)->weight - ((Edge*)b)->weight;
}

int findParent(int parent[], int i) {
    if (parent[i] == -1)
        return i;
    return findParent(parent, parent[i]);
}

void kruskal(Edge edges[], int numEdges) {
    qsort(edges, numEdges, sizeof(edges[0]), compare);
    int parent[V];
    for (int i = 0; i < V; i++)
        parent[i] = -1;

    for (int i = 0; i < numEdges; i++) {
        int srcParent = findParent(parent, edges[i].src);
        int destParent = findParent(parent, edges[i].dest);
        if (srcParent != destParent) {
            printf("Edge %d - %d with weight %d is included in the MST\n", edges[i].src, edges[i].dest, edges[i].weight);
            parent[srcParent] = destParent;
        }
    }
}
    ''',
    'C++': '''
#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

struct Edge {
    int src, dest, weight;
};

bool compare(Edge a, Edge b) {
    return a.weight < b.weight;
}

int findParent(int parent[], int i) {
    if (parent[i] == -1)
        return i;
    return findParent(parent, parent[i]);
}

void kruskal(vector<Edge>& edges, int V) {
    sort(edges.begin(), edges.end(), compare);
    int parent[V];
    for (int i = 0; i < V; i++)
        parent[i] = -1;

    for (auto edge : edges) {
        int srcParent = findParent(parent, edge.src);
        int destParent = findParent(parent, edge.dest);
        if (srcParent != destParent) {
            cout << "Edge " << edge.src << " - " << edge.dest << " with weight " << edge.weight << " is included in the MST" << endl;
            parent[srcParent] = destParent;
        }
    }
}
    ''',
    'Java': '''
import java.util.Arrays;

class Kruskal {
    static class Edge implements Comparable<Edge> {
        int src, dest, weight;

        public int compareTo(Edge compareEdge) {
            return this.weight - compareEdge.weight;
        }
    }

    int findParent(int parent[], int i) {
        if (parent[i] == -1)
            return i;
        return findParent(parent, parent[i]);
    }

    void kruskal(Edge edges[], int numEdges) {
        Arrays.sort(edges);
        int parent[V] = new int[V];
        Arrays.fill(parent, -1);

        for (int i = 0; i < numEdges; i++) {
            int srcParent = findParent(parent, edges[i].src);
            int destParent = findParent(parent, edges[i].dest);
            if (srcParent != destParent) {
                System.out.println("Edge " + edges[i].src + " - " + edges[i].dest + " with weight " + edges[i].weight + " is included in the MST");
                parent[srcParent] = destParent;
            }
        }
    }
}
    ''',
    'Python': '''
class Edge:
    def __init__(self, src, dest, weight):
        self.src = src
        self.dest = dest
        self.weight = weight

def find_parent(parent, i):
    if parent[i] == -1:
        return i
    return find_parent(parent, parent[i])

def kruskal(edges, V):
    edges.sort(key=lambda x: x.weight)
    parent = [-1] * V

    for edge in edges:
        src_parent = find_parent(parent, edge.src)
        dest_parent = find_parent(parent, edge.dest)
        if src_parent != dest_parent:
            print(f"Edge {edge.src} - {edge.dest} with weight {edge.weight} is included in the MST")
            parent[src_parent] = dest_parent
    '''
  }
};

class KruskalCodePage extends StatefulWidget {
  @override
  _KruskalCodePageState createState() => _KruskalCodePageState();
}

class _KruskalCodePageState extends State<KruskalCodePage> {
  String _selectedLanguage = 'Python';
  bool _isDarkTheme = false;

  @override
  Widget build(BuildContext context) {
    // Get the code for the selected algorithm and language
    String code = codeSnippets['Kruskal\'s']?[_selectedLanguage] ?? 'Code not available';

    return Scaffold(
      appBar: AppBar(
        title: Text('Kruskal\'s Algorithm Code'),
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
                    iconEnabledColor: Colors.purple,
                    items: ['C', 'C++', 'Java', 'Python'].map((String language) {
                      return DropdownMenuItem<String>(
                        value: language,
                        child: Text(language, style: TextStyle(color: Colors.purple)),
                      );
                    }).toList(),
                    onChanged: (String? newLanguage) {
                      setState(() {
                        _selectedLanguage = newLanguage!;
                      });
                    },
                  ),
                ),
                // Theme Toggle Button
                IconButton(
                  icon: Icon(Icons.brightness_6, color: Colors.purple),
                  onPressed: () {
                    setState(() {
                      _isDarkTheme = !_isDarkTheme;
                    });
                  },
                ),
                // Copy to Clipboard Button
                IconButton(
                  icon: Icon(Icons.copy, color: Colors.purple),
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: code));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Code copied to clipboard')),
                    );
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
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SelectableText(
                  code,
                  style: TextStyle(
                    color: _isDarkTheme ? Colors.white : Colors.black,
                    fontFamily: 'monospace',
                    fontSize: 14,
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
