import 'dart:async';

import 'package:flutter/material.dart';

class CountdownWidget extends StatefulWidget {
  final String appointmentTime;

  CountdownWidget({required this.appointmentTime});

  @override
  _CountdownWidgetState createState() => _CountdownWidgetState();
}

class _CountdownWidgetState extends State<CountdownWidget> {
  late DateTime appointmentDateTime;
  late DateTime now;
  late Duration timeLeft;
  late Timer _timer; // Declare the timer

  @override
  void initState() {
    super.initState();
    appointmentDateTime = DateTime.parse(widget.appointmentTime);
    now = DateTime.now();
    timeLeft = appointmentDateTime.difference(now);

    // Update the countdown every second
    _timer = Timer.periodic(Duration(seconds: 1), _updateCountdown);
  }

  // Method to update the countdown
  void _updateCountdown(Timer timer) {
    setState(() {
      now = DateTime.now(); // Update the current time
      timeLeft =
          appointmentDateTime.difference(now); // Recalculate the time left

      // Stop the timer when the countdown reaches 0
      if (timeLeft.isNegative) {
        _timer.cancel(); // Stop the timer
        timeLeft = Duration.zero; // Set timeLeft to 0 when the time is up
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String countdownText;

    if (timeLeft.isNegative) {
      // If the appointment time has already passed
      countdownText = "The appointment has already passed.";
    } else if (timeLeft.inDays > 0) {
      // More than 1 day left
      int days = timeLeft.inDays;
      int hours = timeLeft.inHours % 24; // Get remaining hours after days
      countdownText = "$days day, $hours hour left";
    } else if (timeLeft.inHours > 0) {
      // Less than 1 day, but more than 0 hours
      int hours = timeLeft.inHours;
      int minutes =
          timeLeft.inMinutes % 60; // Get remaining minutes after hours
      countdownText = "$hours hour, $minutes min left";
    } else if (timeLeft.inMinutes > 0) {
      // Less than 1 hour, but more than 0 minutes
      int minutes = timeLeft.inMinutes;
      int seconds =
          timeLeft.inSeconds % 60; // Get remaining seconds after minutes
      countdownText = "$minutes min, $seconds sec left";
    } else {
      // Less than 1 minute left
      int seconds = timeLeft.inSeconds;
      countdownText = "$seconds sec left";
    }

    return Text(
      countdownText,
      style: TextStyle(
        fontSize: 16,
        fontFamily: "garet",
        color: Colors.white.withOpacity(0.7),
      ),
    );
  }
}
