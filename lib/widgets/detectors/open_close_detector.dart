import 'package:flutter/material.dart';

class OpenCloseDetector extends StatefulWidget {
  @override
  _OpenCloseDetectorState createState() => _OpenCloseDetectorState();

  final Widget child;
  final Function onOpen, onClose;
  OpenCloseDetector({
    @required this.child,
    this.onOpen,
    this.onClose,
  });
}

class _OpenCloseDetectorState extends State<OpenCloseDetector> {
  @override
  void dispose() {
    widget.onClose?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => widget.onOpen?.call());
    return widget.child;
  }
}
