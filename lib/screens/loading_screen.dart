import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final _typingDuration = const Duration(milliseconds: 30);
  final _deletingDuration = const Duration(milliseconds: 10);
  late String _displayedText;
  late String _incomingText;
  late String _outgoingText;

  bool _isMounted = true; // To track if the widget is still mounted

  @override
  void initState() {
    _incomingText = "✈️ Welcome to  Explorer's Edge";
    _outgoingText = '';
    _displayedText = '';
    animateText();
    super.initState();
  }

  @override
  void dispose() {
    _isMounted = false; // Mark the widget as disposed
    super.dispose();
  }

  void animateText() async {
    final backwardLength = _outgoingText.length;
    if (backwardLength > 0) {
      for (var i = backwardLength; i >= 0; i--) {
        await Future.delayed(_deletingDuration);
        if (!_isMounted) return; // Exit if the widget is no longer mounted
        _displayedText = _outgoingText.substring(0, i);
        setState(() {});
      }
    }
    final forwardLength = _incomingText.length;
    if (forwardLength > 0) {
      for (var i = 0; i <= forwardLength; i++) {
        await Future.delayed(_typingDuration);
        if (!_isMounted) return; // Exit if the widget is no longer mounted
        _displayedText = _incomingText.substring(0, i);
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Center(
          child: Text(
            _displayedText,
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
