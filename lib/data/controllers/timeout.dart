import 'dart:async';
import 'package:flutter/material.dart';

class SessionTimeoutListener extends StatefulWidget {
  final Widget child;
  final Duration timeout;
  final VoidCallback onTimeout;

  const SessionTimeoutListener({
    super.key,
    required this.child,
    required this.timeout,
    required this.onTimeout,
  });

  @override
  _SessionTimeoutListenerState createState() => _SessionTimeoutListenerState();
}

class _SessionTimeoutListenerState extends State<SessionTimeoutListener> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer(widget.timeout, widget.onTimeout);
  }

  // Hàm này được gọi mỗi khi có tương tác (chạm, vuốt...)
  void _handleUserInteraction([_]) {
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: _handleUserInteraction,
      child: widget.child,
    );
  }
}