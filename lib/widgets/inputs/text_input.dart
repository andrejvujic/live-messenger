import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  @override
  _TextInputState createState() => _TextInputState();

  final String initialValue, hintText, labelText, helperText;
  final int maxLength, maxLines;
  final double width;
  final Color fillColor, hintColor, labelColor, textColor, cursorColor;
  final EdgeInsets margin, padding;
  final TextEditingController controller;
  final Function onChanged;
  final TextInputType keyboardType;

  TextInput({
    this.initialValue,
    this.hintText,
    this.labelText,
    this.helperText,
    this.maxLength,
    this.maxLines = 1,
    this.width,
    this.cursorColor = Colors.deepOrange,
    this.fillColor,
    this.hintColor = Colors.white54,
    this.labelColor = Colors.white,
    this.textColor = Colors.white,
    this.controller,
    this.onChanged,
    this.margin = const EdgeInsets.all(0.0),
    this.padding = const EdgeInsets.all(0.0),
    this.keyboardType = TextInputType.text,
  });
}

class _TextInputState extends State<TextInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? MediaQuery.of(context).size.width * 0.85,
      margin: widget.margin,
      padding: widget.padding,
      child: TextFormField(
        cursorColor: widget.cursorColor,
        style: TextStyle(
          color: widget.textColor,
        ),
        onChanged: (
          String _value,
        ) =>
            widget.onChanged?.call(
          _value,
        ),
        keyboardType: widget.keyboardType,
        controller: widget.controller,
        initialValue: widget.initialValue,
        maxLines: widget.maxLines,
        maxLength: widget.maxLength,
        maxLengthEnforced: false,
        decoration: InputDecoration(
          filled: true,
          border: InputBorder.none,
          hintText: widget.hintText,
          labelText: widget.labelText,
          hintStyle: TextStyle(
            color: widget.hintColor,
          ),
          labelStyle: TextStyle(
            color: widget.labelColor,
          ),
          fillColor: widget.fillColor ?? Colors.grey[900],
        ),
      ),
    );
  }
}
