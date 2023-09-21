import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  final DateTime startTime;
  final Duration countdownDuration = const Duration(hours: 3);

  const CountdownTimer({super.key, required this.startTime});

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;
  Duration _remainingTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startCountdown() {
    final now = DateTime.now();
    final endTime = widget.startTime.add(widget.countdownDuration);

    if (now.isBefore(widget.startTime)) {
      // Countdown from startTime to startTime + 3 hours
      _remainingTime = widget.startTime.difference(now);
    } else if (now.isBefore(endTime)) {
      // Countdown from now to startTime + 3 hours
      _remainingTime = endTime.difference(now);
    } else {
      // Countdown has ended
      _remainingTime = Duration.zero;
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime.inSeconds > 0) {
        setState(() {
          _remainingTime = _remainingTime - const Duration(seconds: 1);
        });
      } else {
        _timer.cancel();
        // Handle countdown completion here
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final hours = _remainingTime.inHours.toString().padLeft(2, '0');
    final minutes = (_remainingTime.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (_remainingTime.inSeconds % 60).toString().padLeft(2, '0');

    return Card(
      elevation: 10,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          '$hours:$minutes:$seconds',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
