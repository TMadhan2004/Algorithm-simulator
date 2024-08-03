import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'home_page.dart';

class FlutterDashImage extends StatelessWidget {
  const FlutterDashImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const ShapeDecoration(shape: CircleBorder()),
      child: Image.asset(
        'assets/logo.png', // Replace with your splash screen image
        height: 100,
        width: 100,
        fit: BoxFit.cover,
      ),
    );
  }
}

class GradientBorderPainter extends CustomPainter {
  final double radius;
  final double strokeWidth;
  final Gradient gradient;
  final _paint = Paint()..style = PaintingStyle.stroke;

  GradientBorderPainter({
    Key? key,
    required this.radius,
    required this.strokeWidth,
    required this.gradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(
      center: center,
      radius: radius,
    );
    _paint
      ..strokeWidth = strokeWidth
      ..shader = gradient.createShader(rect);
    canvas.drawCircle(center, radius, _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class GradientBorderPaint extends StatefulWidget {
  const GradientBorderPaint({super.key});

  @override
  State<GradientBorderPaint> createState() => _GradientBorderPaintState();
}

class _GradientBorderPaintState extends State<GradientBorderPaint>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );
    _animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController
      ..forward()
      ..repeat(reverse: false);
  }

  Gradient get _gradient => const LinearGradient(
    colors: [
      Colors.yellowAccent,
      Colors.redAccent,
      Colors.greenAccent,
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        RotationTransition(
          turns: _animation,
          child: CustomPaint(
            size: const Size(180, 180),
            painter: GradientBorderPainter(
              radius: 90,
              strokeWidth: 4,
              gradient: _gradient,
            ),
          ),
        ),
        FlutterDashImage(), // Display the static image inside the border
      ],
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    // Initialize the video player with the .mov file
    _videoPlayerController = VideoPlayerController.asset(
      'assets/titlecard.mov', // Ensure this path is correct
    );

    _initializeVideoPlayerFuture = _videoPlayerController.initialize().then((_) {
      _videoPlayerController.setLooping(false);
      _videoPlayerController.play();

      // Listen for the video end and pause on the last frame for 2 more seconds
      _videoPlayerController.addListener(() {
        if (_videoPlayerController.value.position >=
            _videoPlayerController.value.duration &&
            !_videoPlayerController.value.isPlaying) {
          // Pause the video when it reaches the end
          _videoPlayerController.pause();
          Future.delayed(const Duration(seconds: 2), () {
            _navigateToHome();
          });
        }
      });
    }).catchError((error) {
      // Handle initialization error
      print('Video initialization error: $error');
      Future.delayed(const Duration(seconds: 6), () {
        _navigateToHome();
      });
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  _navigateToHome() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Set the background color to white
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GradientBorderPaint(), // The gradient border with static image inside
              SizedBox(height: 20),
              FutureBuilder(
                future: _initializeVideoPlayerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return AspectRatio(
                      aspectRatio: _videoPlayerController.value.aspectRatio,
                      child: VideoPlayer(_videoPlayerController),
                    );
                  } else if (snapshot.hasError) {
                    // Show error message if video fails to load
                    return Text('Error loading video: ${snapshot.error}');
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SplashScreen(),
  ));
}
