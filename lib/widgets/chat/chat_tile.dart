import 'package:flutter/material.dart';

class ChatTile extends StatefulWidget {
  @override
  _ChatTileState createState() => _ChatTileState();

  final Color tileColor;
  final ImageProvider<Object> leading;
  final Widget title, subtitle, trailing;
  final double trailingWidth;
  final EdgeInsets tileMargin, tilePadding;
  final Function onTap, onLongPress;
  ChatTile({
    @required this.leading,
    @required this.title,
    this.tileMargin = const EdgeInsets.all(0.0),
    this.tilePadding = const EdgeInsets.symmetric(
      vertical: 10.0,
      horizontal: 0.0,
    ),
    this.tileColor = Colors.black,
    this.subtitle,
    this.trailing,
    this.trailingWidth = 0.0,
    this.onTap,
    this.onLongPress,
  });
}

class _ChatTileState extends State<ChatTile> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.white10,
        fontFamily: 'Poppins-Regular',
      ),
      child: Container(
        margin: widget.tileMargin,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.white10, width: 0.5),
            bottom: BorderSide(color: Colors.white10, width: 0.5),
          ),
        ),
        child: ListTile(
          contentPadding: widget.tilePadding,
          onTap: () => widget.onTap?.call(),
          onLongPress: () => widget.onLongPress?.call(),
          leading: CircleAvatar(
            radius: 32.0,
            backgroundColor: Colors.grey[900],
            backgroundImage: widget.leading,
          ),
          title: widget.title,
          subtitle: widget.subtitle,
          trailing: Container(
            child: widget.trailing,
            width: widget.trailingWidth,
          ),
        ),
      ),
    );
  }
}
