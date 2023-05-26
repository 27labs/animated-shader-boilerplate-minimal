import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() {
  runApp(const HelloTime());
}

class HelloTime extends StatelessWidget {
  const HelloTime({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              Expanded(
                child: ShadedArea(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ShadedArea extends StatelessWidget {
  ShadedArea({super.key});

  @override
  build(_) => FutureBuilder(
    future: FragmentProgram.fromAsset('shaders/animated.frag'),
    builder: (_, snapshot) {
      if(snapshot.hasData) {
        return TimedShader(snapshot.data!.fragmentShader());
      }
      return Center(child: CircularProgressIndicator(),);
    },
  );
}

class TimedShader extends StatefulWidget {
  final shader;
  TimedShader(this.shader, {super.key});

  @override
  createState() => TimedShaderState();
}

class TimedShaderState extends State<TimedShader> with SingleTickerProviderStateMixin {
  Ticker? clock;
  double time = 0;

  @override
  initState() {
    super.initState();
    clock = createTicker((elapsed) {
      const pace = 0.001;
      setState(() {
        time = elapsed.inMilliseconds * pace;
      });
    })..start();
  }

  @override
  dispose() {
    clock?.dispose();
    super.dispose();
  }

  @override
  build(_) => CustomPaint(
          size: Size.square(double.infinity),
          painter: FragmentPainter(widget.shader, time),
        );
}

class FragmentPainter extends CustomPainter {
  final FragmentShader shader;
  final time;
  FragmentPainter(this.shader, this.time);

  @override
  paint(canvas, size) {
    shader.setFloat(0, time);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..shader = shader
    );
  }

  @override
  shouldRepaint(FragmentPainter oldDelegate) => oldDelegate.time != time;
}