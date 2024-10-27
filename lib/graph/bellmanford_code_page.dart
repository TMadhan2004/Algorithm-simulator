import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Define code snippets for Bellman-Ford
const Map<String, Map<String, String>> codeSnippets = {
  'Bellman-Ford': {
    'C': '''
#include <stdio.h>
#include <limits.h>

#define V 5

void bellmanFord(int graph[V][V], int src) {
    int dist[V];
    for (int i = 0; i < V; i++)
        dist[i] = INT_MAX;
    dist[src] = 0;

    for (int i = 1; i < V; i++) {
        for (int u = 0; u < V; u++) {
            for (int v = 0; v < V; v++) {
                if (graph[u][v] && dist[u] != INT_MAX &&
                    dist[u] + graph[u][v] < dist[v]) {
                    dist[v] = dist[u] + graph[u][v];
                }
            }
        }
    }
}
    ''',
    'C++': '''
#include <iostream>
#include <limits.h>
using namespace std;

#define V 5

void bellmanFord(int graph[V][V], int src) {
    int dist[V];
    for (int i = 0; i < V; i++)
        dist[i] = INT_MAX;
    dist[src] = 0;

    for (int i = 1; i < V; i++) {
        for (int u = 0; u < V; u++) {
            for (int v = 0; v < V; v++) {
                if (graph[u][v] && dist[u] != INT_MAX &&
                    dist[u] + graph[u][v] < dist[v]) {
                    dist[v] = dist[u] + graph[u][v];
                }
            }
        }
    }
}
    ''',
    'Java': '''
public class BellmanFord {
    static final int V = 5;

    void bellmanFord(int graph[][], int src) {
        int dist[] = new int[V];
        for (int i = 0; i < V; i++)
            dist[i] = Integer.MAX_VALUE;
        dist[src] = 0;

        for (int i = 1; i < V; i++) {
            for (int u = 0; u < V; u++) {
                for (int v = 0; v < V; v++) {
                    if (graph[u][v] != 0 && dist[u] != Integer.MAX_VALUE &&
                        dist[u] + graph[u][v] < dist[v]) {
                        dist[v] = dist[u] + graph[u][v];
                    }
                }
            }
        }
    }
}
    ''',
    'Python': '''
def bellman_ford(graph, src):
    dist = [float("inf")] * len(graph)
    dist[src] = 0

    for _ in range(len(graph) - 1):
        for u in range(len(graph)):
            for v in range(len(graph)):
                if graph[u][v] and dist[u] != float("inf") and \
                   dist[u] + graph[u][v] < dist[v]:
                    dist[v] = dist[u] + graph[u][v]

    return dist
    '''
  }
};

class BellmanFordCodePage extends StatefulWidget {
  @override
  _BellmanFordCodePageState createState() => _BellmanFordCodePageState();
}

class _BellmanFordCodePageState extends State<BellmanFordCodePage> {
  String _selectedLanguage = 'Python';
  bool _isDarkTheme = false;

  @override
  Widget build(BuildContext context) {
    // Get the code for the selected algorithm and language
    String code = codeSnippets['Bellman-Ford']?[_selectedLanguage] ?? 'Code not available';

    return Scaffold(
      appBar: AppBar(
        title: Text('Bellman-Ford Algorithm Code'),
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
