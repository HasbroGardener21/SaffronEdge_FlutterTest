import 'package:flutter/material.dart';

class TimerDisplay extends StatelessWidget {
  final double progress;
  final String timeText;
  final bool isWork;

  const TimerDisplay({
    super.key,
    required this.progress,
    required this.timeText,
    required this.isWork,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 240,
          height: 240,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: 8,
            backgroundColor: Colors.white10,
            valueColor: AlwaysStoppedAnimation<Color>(
              isWork ? Colors.indigoAccent : Colors.tealAccent,
            ),
          ),
        ),
        Text(
          timeText,
          style: const TextStyle(
            fontSize: 56,
            fontWeight: FontWeight.w300,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }
}