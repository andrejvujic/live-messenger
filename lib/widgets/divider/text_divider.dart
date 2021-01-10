import 'package:flutter/material.dart';

class TextDivider extends StatefulWidget {
  @override
  _TextDividerState createState() => _TextDividerState();

  final Widget child;
  final EdgeInsets childPadding, childMargin, widgetPadding, widgetMargin;
  final Color dividerColor;
  final double dividerThickness, dividerHeight;
  TextDivider({
    this.child,
    this.childMargin = const EdgeInsets.all(0.0),
    this.childPadding = const EdgeInsets.all(0.0),
    this.widgetMargin = const EdgeInsets.all(0.0),
    this.widgetPadding = const EdgeInsets.all(0.0),
    this.dividerColor = Colors.grey,
    this.dividerThickness = 1.0,
    this.dividerHeight = 16.0,
  });
}

class _TextDividerState extends State<TextDivider> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.widgetMargin,
      padding: widget.widgetPadding,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Divider(
              height: widget.dividerHeight,
              thickness: widget.dividerThickness,
              color: widget.dividerColor,
            ),
          ),
          Container(
              margin: widget.childMargin,
              padding: widget.childPadding,
              child: widget.child),
          Expanded(
            child: Divider(
              height: widget.dividerHeight,
              thickness: widget.dividerThickness,
              color: widget.dividerColor,
            ),
          ),
        ],
      ),
    );
  }
}
