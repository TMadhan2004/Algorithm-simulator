import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


const Map<String, Map<String, String>> codeSnippets = {
  'Prim\'s': {
    'C': '''
#include <stdio.h>
#include <limits.h>

#define V 5

int minKey(int key[], int mstSet[]) {
    int min = INT_MAX, min_index;
    for (int v = 0; v < V; v++)
        if (mstSet[v] == 0 && key[v] < min)
            min = key[v], min_index = v;
    return min_index;
}

void primMST(int graph[V][V]) {
    int parent[V]; 
    int key[V]; 
    int mstSet[V]; 

    for (int i = 0; i < V; i++) {
        key[i] = INT_MAX;
        mstSet[i] = 0;
    }
    key[0] = 0;
    parent[0] = -1;

    for (int count = 0; count < V - 1; count++) {
        int u = minKey(key, mstSet);
        mstSet[u] = 1;

        for (int v = 0; v < V; v++) {
            if (graph[u][v] && mstSet[v] == 0 && graph[u][v] < key[v]) {
                parent[v] = u, key[v] = graph[u][v];
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

int minKey(int key[], bool mstSet[]) {
    int min = INT_MAX, min_index;
    for (int v = 0; v < V; v++)
        if (mstSet[v] == false && key[v] < min)
            min = key[v], min_index = v;
    return min_index;
}

void primMST(int graph[V][V]) {
    int parent[V]; 
    int key[V]; 
    bool mstSet[V]; 

    for (int i = 0; i < V; i++) {
        key[i] = INT_MAX;
        mstSet[i] = false;
    }
    key[0] = 0;
    parent[0] = -1;

    for (int count = 0; count < V - 1; count++) {
        int u = minKey(key, mstSet);
        mstSet[u] = true;

        for (int v = 0; v < V; v++) {
            if (graph[u][v] && mstSet[v] == false && graph[u][v] < key[v]) {
                parent[v] = u, key[v] = graph[u][v];
            }
        }
    }
}
    ''',
    'Java': '''
public class Prims {
    static final int V = 5;

    int minKey(int key[], boolean mstSet[]) {
        int min = Integer.MAX_VALUE, min_index = -1;
        for (int v = 0; v < V; v++)
            if (!mstSet[v] && key[v] < min) {
                min = key[v];
                min_index = v;
            }
        return min_index;
    }

    void primMST(int graph[][]) {
        int parent[] = new int[V];
        int key[] = new int[V];
        boolean mstSet[] = new boolean[V];

        for (int i = 0; i < V; i++) {
            key[i] = Integer.MAX_VALUE;
            mstSet[i] = false;
        }
        key[0] = 0; 
        parent[0] = -1; 

        for (int count = 0; count < V - 1; count++) {
            int u = minKey(key, mstSet);
            mstSet[u] = true;

            for (int v = 0; v < V; v++) {
                if (graph[u][v] != 0 && !mstSet[v] && graph[u][v] < key[v]) {
                    parent[v] = u;
                    key[v] = graph[u][v];
                }
            }
        }
    }
}
    ''',
    'Python': '''
def prims(graph):
    V = len(graph)
    key = [float("inf")] * V
    parent = [-1] * V
    mstSet = [False] * V

    key[0] = 0

    for _ in range(V - 1):
        u = min(range(V), key=lambda v: key[v] if not mstSet[v] else float("inf"))
        mstSet[u] = True

        for v in range(V):
            if graph[u][v] and not mstSet[v] and graph[u][v] < key[v]:
                parent[v] = u
                key[v] = graph[u][v]

    return parent
    '''
  }
};

class PrimsCodePage extends StatefulWidget {
  @override
  _PrimsCodePageState createState() => _PrimsCodePageState();
}

class _PrimsCodePageState extends State<PrimsCodePage> {
  String _selectedLanguage = 'Python';
  bool _isDarkTheme = false;

  @override
  Widget build(BuildContext context) {
    // Get the code for the selected algorithm and language
    String code = codeSnippets['Prim\'s']?[_selectedLanguage] ?? 'Code not available';

    return Scaffold(
      appBar: AppBar(
        title: Text('Prim\'s Algorithm Code'),
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
