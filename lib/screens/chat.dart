import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as services;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:live_messanger/services/database_service.dart';
import 'package:live_messanger/utils/utils.dart';
import 'package:live_messanger/widgets/buttons/solid_button.dart';
import 'package:live_messanger/widgets/chat/message_tile.dart';
import 'package:live_messanger/widgets/inputs/text_input.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();

  final Map<String, dynamic> chat;
  Chat({
    this.chat,
  });
}

class _ChatState extends State<Chat> {
  TextEditingController _textController;
  ScrollController _messagesController;

  final _utils = Utils();

  final _databaseService =
      DatabaseService(uid: FirebaseAuth.instance.currentUser.uid);

  @override
  void initState() {
    _textController = TextEditingController();
    _messagesController = ScrollController();

    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    _messagesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_messagesController.hasClients) {
        _messagesController.animateTo(
            _messagesController.position.maxScrollExtent,
            duration: Duration(
              milliseconds: 300,
            ),
            curve: Curves.easeInOut);
      } else {
        setState(() => null);
      }
    });
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          widget.chat['title'],
        ),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ListTile(
                    leading: CircleAvatar(
                      radius: 32.0,
                      backgroundImage: CachedNetworkImageProvider(
                        widget.chat['image'],
                      ),
                    ),
                    title: Text(
                      widget.chat['title'],
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: _databaseService.chatData(widget.chat['id']),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final Map<String, dynamic> _chatData = snapshot.data.data();
          return Column(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView.builder(
                        controller: _messagesController,
                        itemCount: _chatData['messages'].length,
                        itemBuilder: (BuildContext context, int index) => Theme(
                          data: ThemeData(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            fontFamily: 'Poppins-Regular',
                          ),
                          child: MessageTile(
                            index: index,
                            chatData: _chatData,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: Container(
        margin: MediaQuery.of(context).viewInsets,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: <Widget>[
            TextInput(
              controller: _textController,
              hintText: 'Unesi poruku...',
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.15,
              color: Colors.grey[900],
              child: IconButton(
                splashRadius: 1.0,
                onPressed: () async {
                  if (_textController.text.isNotEmpty) {
                    await _databaseService.sendMessage(
                      widget.chat['id'],
                      FirebaseAuth.instance.currentUser.uid,
                      FirebaseAuth.instance.currentUser.photoURL,
                      _textController.text,
                    );
                    _textController.clear();
                    _messagesController
                        .jumpTo(_messagesController.position.maxScrollExtent);
                  }
                },
                icon: Icon(
                  Icons.send,
                  color: Colors.deepOrange,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
