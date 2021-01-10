import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SenderPicture extends StatefulWidget {
  @override
  _SenderPictureState createState() => _SenderPictureState();

  final Map<String, dynamic> messageData;
  final bool isSentByUser, isPreviousSentBySameUser, targetIsSentByUser;
  SenderPicture({
    this.messageData,
    this.isSentByUser,
    this.isPreviousSentBySameUser,
    this.targetIsSentByUser,
  });
}

class _SenderPictureState extends State<SenderPicture> {
  Map<String, dynamic> _messageData;
  bool _isSentByUser = false,
      _isPreviousSentBySameUser = false,
      _targetIsSentByUser = false;

  @override
  void initState() {
    _messageData = widget.messageData;
    _isSentByUser = widget.isSentByUser;
    _isPreviousSentBySameUser = widget.isPreviousSentBySameUser;
    _targetIsSentByUser = widget.targetIsSentByUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (_isSentByUser == _targetIsSentByUser && !_isPreviousSentBySameUser)
        ? CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(
              _messageData['senderPhotoUrl'],
            ),
          )
        : (_isPreviousSentBySameUser)
            ? CircleAvatar(
                backgroundColor: Colors.black,
              )
            : Container(width: 0.0);
  }
}
