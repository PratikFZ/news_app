// ignore: file_names
import 'package:flutter/material.dart';

class InternetBanner extends StatefulWidget {
  final bool isInternetConnected;

  const InternetBanner({super.key, required this.isInternetConnected});

  @override
  State<InternetBanner> createState() => _InternetBannerState();
}

class _InternetBannerState extends State<InternetBanner> {
  double _height = 30;

  @override
  void didUpdateWidget(InternetBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isInternetConnected != widget.isInternetConnected) {
      // If internet becomes connected
      if (widget.isInternetConnected) {
        // Wait 2 seconds before changing height
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _height = 0;
            });
          }
        });
      } else {
        // Immediately show banner when internet disconnects
        setState(() {
          _height = 30;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        height: _height,
        color: widget.isInternetConnected ? Colors.green : Colors.red,
        child: Center(
          child: Text(
            widget.isInternetConnected ? "Online" : "Offline",
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
  }
}
