import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Define code snippets for Dijkstra
const Map<String, Map<String, String>> codeSnippets = {
  'Dijkstra': {
    'C': '''
#include <stdio.h>
#include <limits.h>

#define V 9

int minDistance(int dist[], bool sptSet[]) {
    int min = INT_MAX, min_index;
    for (int v = 0; v < V; v++)
        if (sptSet[v] == false && dist[v] <= min)
            min = dist[v], min_index = v;
    return min_index;
}

void dijkstra(int graph[V][V], int src) {
    int dist[V];
    bool sptSet[V];

    for (int i = 0; i < V; i++)
        dist[i] = INT_MAX, sptSet[i] = false;

    dist[src] = 0;

    for (int count = 0; count < V - 1; count++) {
        int u = minDistance(dist, sptSet);
        sptSet[u] = true;

        for (int v = 0; v < V; v++)
            if (!sptSet[v] && graph[u][v] && dist[u] != INT_MAX &&
                dist[u] + graph[u][v] < dist[v])
                dist[v] = dist[u] + graph[u][v];
    }
}
    ''',
    'C++': '''
#include <iostream>
#include <vector>
#include <limits.h>
using namespace std;

#define V 9

int minDistance(int dist[], bool sptSet[]) {
    int min = INT_MAX, min_index;
    for (int v = 0; v < V; v++)
        if (!sptSet[v] && dist[v] <= min)
            min = dist[v], min_index = v;
    return min_index;
}

void dijkstra(int graph[V][V], int src) {
    int dist[V];
    bool sptSet[V];

    for (int i = 0; i < V; i++)
        dist[i] = INT_MAX, sptSet[i] = false;

    dist[src] = 0;

    for (int count = 0; count < V - 1; count++) {
        int u = minDistance(dist, sptSet);
        sptSet[u] = true;

        for (int v = 0; v < V; v++)
            if (!sptSet[v] && graph[u][v] && dist[u] != INT_MAX &&
                dist[u] + graph[u][v] < dist[v])
                dist[v] = dist[u] + graph[u][v];
    }
}
    ''',
    'Java': '''
import java.util.Arrays;

public class Dijkstra {
    static final int V = 9;

    int minDistance(int dist[], Boolean sptSet[]) {
        int min = Integer.MAX_VALUE, min_index = -1;
        for (int v = 0; v < V; v++)
            if (!sptSet[v] && dist[v] <= min) {
                min = dist[v];
                min_index = v;
            }
        return min_index;
    }

    void dijkstra(int graph[][], int src) {
        int dist[] = new int[V];
        Boolean sptSet[] = new Boolean[V];

        Arrays.fill(dist, Integer.MAX_VALUE);
        Arrays.fill(sptSet, false);
        dist[src] = 0;

        for (int count = 0; count < V - 1; count++) {
            int u = minDistance(dist, sptSet);
            sptSet[u] = true;

            for (int v = 0; v < V; v++)
                if (!sptSet[v] && graph[u][v] != 0 && dist[u] != Integer.MAX_VALUE &&
                    dist[u] + graph[u][v] < dist[v])
                    dist[v] = dist[u] + graph[u][v];
        }
    }
}
    ''',
    'Python': '''
import sys

def min_distance(dist, spt_set):
    min_val = sys.maxsize
    min_index = -1
    for v in range(len(dist)):
        if not spt_set[v] and dist[v] < min_val:
            min_val = dist[v]
            min_index = v
    return min_index

def dijkstra(graph, src):
    dist = [sys.maxsize] * len(graph)
    spt_set = [False] * len(graph)
    dist[src] = 0

    for _ in range(len(graph) - 1):
        u = min_distance(dist, spt_set)
        spt_set[u] = True

        for v in range(len(graph)):
            if (not spt_set[v] and graph[u][v] and
                dist[u] != sys.maxsize and
                dist[u] + graph[u][v] < dist[v]):
                dist[v] = dist[u] + graph[u][v]

    return dist
    '''
  }
};

class DijkstraCodePage extends StatefulWidget {
  @override
  _DijkstraCodePageState createState() => _DijkstraCodePageState();
}

class _DijkstraCodePageState extends State<DijkstraCodePage> {
  String _selectedLanguage = 'Python';
  bool _isDarkTheme = false;

  @override
  Widget build(BuildContext context) {
    // Get the code for the selected algorithm and language
    String code = codeSnippets['Dijkstra']?[_selectedLanguage] ?? 'Code not available';

    return Scaffold(
      appBar: AppBar(
        title: Text('Dijkstra Algorithm Code'),
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
