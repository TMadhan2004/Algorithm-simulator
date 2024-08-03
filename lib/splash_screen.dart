import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
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
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(Duration(seconds: 10)); // Set delay to 10 seconds
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
          gradient: LinearGradient(
            colors: [
              Colors.blue.withOpacity(0.5), // Blue color for the corners
              Colors.transparent,
              Colors.transparent,
              Colors.blue.withOpacity(0.5), // Blue color for the corners
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.0, 0.5, 0.5, 1.0],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GradientBorderPaint(), // The gradient border with static image inside
              SizedBox(height: 20),
              Center(
                child: AnimatedTextKit(
                  totalRepeatCount: 1,
                  animatedTexts: [
                    ScaleAnimatedText(
                      'Algorithm Simulator',
                      textStyle: const TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.w200,
                      ),
                      duration: Duration(milliseconds: 4000),
                    ),
                  ],
                  isRepeatingAnimation: false,
                ),
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
