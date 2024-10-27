import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'input_page.dart';
import 'graph_input_page.dart';

class GraphAlgorithmSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Graph Algorithm"),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => KruskalsAlgorithmVideoPage(),
                  ),
                );
              },
              child: Text('Kruskal\'s Algorithm'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PrimAlgorithmVideoPage(),
                  ),
                );
              },
              child: Text('Prim\'s Algorithm'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DijkstraAlgorithmVideoPage(),
                  ),
                );
              },
              child: Text('Dijkstra\'s Algorithm'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BellmanFordAlgorithmVideoPage(),
                  ),
                );
              },
              child: Text('Bellman-Ford Algorithm'),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showLoadingDialog(BuildContext context, VoidCallback onLoadingComplete) async {
  final VideoPlayerController loadingController = VideoPlayerController.asset('assets/loading.mov');

  await loadingController.initialize();
  loadingController.setLooping(false); // Play once
  loadingController.play();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      // Close the dialog and call onLoadingComplete after 3 seconds
      Future.delayed(Duration(seconds: 3), () {
        Navigator.of(context).pop(); // Close the dialog
        onLoadingComplete(); // Call the provided callback
      });

      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0), // Circular shape
        ),
        backgroundColor: Colors.white, // White background
        child: Container(
          width: 200, // Adjust the size of the dialog
          height: 200,
          child: Center(
            child: AspectRatio(
              aspectRatio: loadingController.value.aspectRatio,
              child: VideoPlayer(loadingController),
            ),
          ),
        ),
      );
    },
  );

  // Dispose the controller after the dialog is closed
  loadingController.addListener(() {
    if (loadingController.value.position == loadingController.value.duration) {
      loadingController.dispose(); // Dispose if video finishes
    }
  });

  // Ensure to dispose of the controller when done
  loadingController.setLooping(false); // Ensure looping is off
}


class KruskalsAlgorithmVideoPage extends StatefulWidget {
  @override
  _KruskalsAlgorithmVideoPageState createState() => _KruskalsAlgorithmVideoPageState();
}

class _KruskalsAlgorithmVideoPageState extends State<KruskalsAlgorithmVideoPage> {
  late VideoPlayerController _controller;
  double _playbackSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/krusalgo.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
    _controller.addListener(() {
      setState(() {}); // Update state on every frame change
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        if (_controller.value.position == _controller.value.duration) {
          _controller.seekTo(Duration.zero); // Replay from the start
        }
        _controller.play();
      }
    });
  }

  void _changePlaybackSpeed() {
    setState(() {
      if (_playbackSpeed == 1.0) {
        _playbackSpeed = 2.0;
      } else if (_playbackSpeed == 2.0) {
        _playbackSpeed = 0.5;
      } else {
        _playbackSpeed = 1.0;
      }
      _controller.setPlaybackSpeed(_playbackSpeed);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Kruskal's Algorithm"),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: _controller.value.isInitialized
                  ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
                  : CircularProgressIndicator(),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _togglePlayPause,
                child: Icon(
                  _controller.value.isPlaying
                      ? Icons.pause
                      : (_controller.value.position == _controller.value.duration
                      ? Icons.replay
                      : Icons.play_arrow),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                ),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  showLoadingDialog(context, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => KruskalInputPage(algorithm: 'Kruskal'),
                      ),
                    );
                  });
                },
                child: Text('Try Yourself'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                ),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: _changePlaybackSpeed,
                child: Text('${_playbackSpeed}x'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class PrimAlgorithmVideoPage extends StatefulWidget {
  @override
  _PrimAlgorithmVideoPageState createState() => _PrimAlgorithmVideoPageState();
}

class _PrimAlgorithmVideoPageState extends State<PrimAlgorithmVideoPage> {
  late VideoPlayerController _controller;
  double _playbackSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/primalgo.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
    _controller.addListener(_onVideoEnd);
  }

  @override
  void dispose() {
    _controller.removeListener(_onVideoEnd);
    _controller.dispose();
    super.dispose();
  }

  void _onVideoEnd() {
    if (_controller.value.position == _controller.value.duration) {
      setState(() {});
    }
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  void _changePlaybackSpeed() {
    setState(() {
      if (_playbackSpeed == 1.0) {
        _playbackSpeed = 2.0;
      } else if (_playbackSpeed == 2.0) {
        _playbackSpeed = 0.5;
      } else {
        _playbackSpeed = 1.0;
      }
      _controller.setPlaybackSpeed(_playbackSpeed);
    });
  }

  void _showLoadingDialog(BuildContext context) async {
    final VideoPlayerController loadingController = VideoPlayerController.asset('assets/loading.mov');

    await loadingController.initialize();
    loadingController.setLooping(false); // Play once
    loadingController.play();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0), // Circular shape
          ),
          backgroundColor: Colors.white, // White background
          child: Container(
            width: 200, // Adjust the size of the dialog
            height: 200,
            child: Center(
              child: AspectRatio(
                aspectRatio: loadingController.value.aspectRatio,
                child: VideoPlayer(loadingController),
              ),
            ),
          ),
        );
      },
    );

    // Close the dialog and navigate after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pop(); // Close the dialog
      loadingController.dispose(); // Dispose of the controller

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => KruskalInputPage(algorithm: 'Prim'),
        ),
      );
    });

    // Dispose the controller when the video finishes
    loadingController.addListener(() {
      if (loadingController.value.position == loadingController.value.duration) {
        loadingController.dispose(); // Dispose if video finishes
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Prim's Algorithm"),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: _controller.value.isInitialized
                  ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
                  : CircularProgressIndicator(),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _togglePlayPause,
                child: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                ),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () => _showLoadingDialog(context),
                child: Text('Try Yourself'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                ),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: _changePlaybackSpeed,
                child: Text('${_playbackSpeed}x'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class DijkstraAlgorithmVideoPage extends StatefulWidget {
  @override
  _DijkstraAlgorithmVideoPageState createState() => _DijkstraAlgorithmVideoPageState();
}

class _DijkstraAlgorithmVideoPageState extends State<DijkstraAlgorithmVideoPage> {
  late VideoPlayerController _controller;
  double _playbackSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/dijkstraalgo.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
    _controller.addListener(_onVideoEnd);
  }

  @override
  void dispose() {
    _controller.removeListener(_onVideoEnd);
    _controller.dispose();
    super.dispose();
  }

  void _onVideoEnd() {
    if (_controller.value.position == _controller.value.duration) {
      setState(() {});
    }
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  void _changePlaybackSpeed() {
    setState(() {
      if (_playbackSpeed == 1.0) {
        _playbackSpeed = 2.0;
      } else if (_playbackSpeed == 2.0) {
        _playbackSpeed = 0.5;
      } else {
        _playbackSpeed = 1.0;
      }
      _controller.setPlaybackSpeed(_playbackSpeed);
    });
  }

  void _showLoadingDialog(BuildContext context) async {
    final VideoPlayerController loadingController = VideoPlayerController.asset('assets/loading.mov');

    await loadingController.initialize();
    loadingController.setLooping(false); // Play once
    loadingController.play();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0), // Circular shape
          ),
          backgroundColor: Colors.white, // White background
          child: Container(
            width: 200, // Adjust the size of the dialog
            height: 200,
            child: Center(
              child: AspectRatio(
                aspectRatio: loadingController.value.aspectRatio,
                child: VideoPlayer(loadingController),
              ),
            ),
          ),
        );
      },
    );

    // Close the dialog and navigate after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pop(); // Close the dialog
      loadingController.dispose(); // Dispose of the controller

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GraphInputPage(algorithm: 'Dijkstra'),
        ),
      );
    });

    // Dispose the controller when the video finishes
    loadingController.addListener(() {
      if (loadingController.value.position == loadingController.value.duration) {
        loadingController.dispose(); // Dispose if video finishes
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dijkstra's Algorithm"),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: _controller.value.isInitialized
                  ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
                  : CircularProgressIndicator(),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _togglePlayPause,
                child: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                ),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () => _showLoadingDialog(context),
                child: Text('Try Yourself'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                ),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: _changePlaybackSpeed,
                child: Text('${_playbackSpeed}x'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class BellmanFordAlgorithmVideoPage extends StatefulWidget {
  @override
  _BellmanFordAlgorithmVideoPageState createState() => _BellmanFordAlgorithmVideoPageState();
}

class _BellmanFordAlgorithmVideoPageState extends State<BellmanFordAlgorithmVideoPage> {
  late VideoPlayerController _controller;
  double _playbackSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/bellmanfordalgo.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
    _controller.addListener(_onVideoEnd);
  }

  @override
  void dispose() {
    _controller.removeListener(_onVideoEnd);
    _controller.dispose();
    super.dispose();
  }

  void _onVideoEnd() {
    if (_controller.value.position == _controller.value.duration) {
      setState(() {});
    }
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  void _changePlaybackSpeed() {
    setState(() {
      if (_playbackSpeed == 1.0) {
        _playbackSpeed = 2.0;
      } else if (_playbackSpeed == 2.0) {
        _playbackSpeed = 0.5;
      } else {
        _playbackSpeed = 1.0;
      }
      _controller.setPlaybackSpeed(_playbackSpeed);
    });
  }

  void _showLoadingDialog(BuildContext context) async {
    final VideoPlayerController loadingController = VideoPlayerController.asset('assets/loading.mov');

    await loadingController.initialize();
    loadingController.setLooping(false); // Play once
    loadingController.play();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0), // Circular shape
          ),
          backgroundColor: Colors.white, // White background
          child: Container(
            width: 200, // Adjust the size of the dialog
            height: 200,
            child: Center(
              child: AspectRatio(
                aspectRatio: loadingController.value.aspectRatio,
                child: VideoPlayer(loadingController),
              ),
            ),
          ),
        );
      },
    );

    // Close the dialog and navigate after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pop(); // Close the dialog
      loadingController.dispose(); // Dispose of the controller

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GraphInputPage(algorithm: 'Bellman-Ford')
        ),
      );
    });

    // Dispose the controller when the video finishes
    loadingController.addListener(() {
      if (loadingController.value.position == loadingController.value.duration) {
        loadingController.dispose(); // Dispose if video finishes
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bellman-Ford Algorithm"),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: _controller.value.isInitialized
                  ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
                  : CircularProgressIndicator(),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _togglePlayPause,
                child: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                ),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () => _showLoadingDialog(context),
                child: Text('Try Yourself'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                ),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: _changePlaybackSpeed,
                child: Text('${_playbackSpeed}x'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}


