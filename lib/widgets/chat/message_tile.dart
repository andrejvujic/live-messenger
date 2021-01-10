import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:live_messanger/utils/utils.dart';
import 'package:live_messanger/widgets/chat/sender_picture.dart';

class MessageTile extends StatefulWidget {
  @override
  _MessageTileState createState() => _MessageTileState();

  final int index;
  final Map<String, dynamic> chatData;
  MessageTile({
    this.index,
    this.chatData,
  });
}

class _MessageTileState extends State<MessageTile> {
  final _utils = Utils();
  int _index;
  Map<String, dynamic> _chatData, _messageData;
  bool _isSentByUser = false, _isPreviousSentBySameUser = false;

  @override
  void initState() {
    _index = widget.index;
    _chatData = widget.chatData;
    _messageData = _chatData['messages'][_index];
    _isSentByUser = _utils.isSentByUser(
        _messageData, FirebaseAuth.instance.currentUser.uid);
    _isPreviousSentBySameUser = _utils.isPreviousSentBySameUser(
        _chatData, _index, _messageData['senderId']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (LongPressStartDetails _details) {
        showMenu(
          color: Colors.grey[900],
          context: context,
          position: RelativeRect.fromLTRB(
            _details.globalPosition.dx,
            _details.globalPosition.dy,
            _details.globalPosition.dx,
            _details.globalPosition.dy,
          ),
          items: [
            PopupMenuItem(
              value: 0,
              child: Text(
                'Kopiraj tekst',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ).then(
          (_selectedValue) {
            if (_selectedValue == 0) {
              Clipboard.setData(
                ClipboardData(
                  text: _messageData['text'],
                ),
              );
            }
          },
        );
      },
      child: Container(
        padding: EdgeInsets.all(5.0),
        child: Row(
          children: <Widget>[
            SenderPicture(
              messageData: _messageData,
              isSentByUser: _isSentByUser,
              isPreviousSentBySameUser: _isPreviousSentBySameUser,
              targetIsSentByUser: false,
            ),
            Expanded(
              child: ListTile(
                title: Row(
                  mainAxisAlignment: (_isSentByUser)
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(2.5),
                      alignment: (_isSentByUser)
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: (_isSentByUser)
                            ? Colors.deepOrange
                            : Colors.grey[900],
                        borderRadius: BorderRadius.circular(
                          15.0,
                        ),
                      ),
                      width: MediaQuery.of(context).size.width * 0.65,
                      child: Text(
                        _messageData['text'],
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                subtitle: Row(
                  mainAxisAlignment: (_isSentByUser)
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      alignment: (_isSentByUser)
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width * 0.65,
                      child: Text(
                        _utils.getLastChatActivity(
                          _messageData['sentOn'].toDate(),
                        ),
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.white54,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SenderPicture(
              messageData: _messageData,
              isSentByUser: _isSentByUser,
              isPreviousSentBySameUser: _isPreviousSentBySameUser,
              targetIsSentByUser: true,
            ),
          ],
        ),
      ),
    );
  }
}
