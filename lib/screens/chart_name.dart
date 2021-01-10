import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:live_messanger/services/database_service.dart';
import 'package:live_messanger/widgets/buttons/solid_button.dart';
import 'package:live_messanger/widgets/inputs/text_input.dart';

class ChatName extends StatefulWidget {
  @override
  _ChatNameState createState() => _ChatNameState();

  final String chatRoomTitle, chatRoomId;
  final Function saveChatRoomTitle;
  ChatName({
    this.chatRoomTitle,
    this.chatRoomId,
    this.saveChatRoomTitle,
  });
}

class _ChatNameState extends State<ChatName> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = widget.chatRoomTitle;
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextInput(
          controller: _controller,
          margin: EdgeInsets.symmetric(
            horizontal: 5.0,
          ),
          fillColor: Colors.black,
          labelText: 'Naziv razgovora',
        ),
        SolidButton(
          onPressed: () {
            widget.saveChatRoomTitle?.call(widget.chatRoomId, _controller.text);
            Navigator.pop(context);
          },
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Saučuvaj',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
