import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:live_messanger/services/database_service.dart';
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
        _messagesController
            .jumpTo(_messagesController.position.maxScrollExtent);
      }
    });
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          widget.chat['title'],
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
                        itemBuilder: (BuildContext context, int index) =>
                            Container(
                          padding: EdgeInsets.all(5.0),
                          child: ListTile(
                            title: Text(
                              _chatData['messages'][index]['text'],
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                            ),
                            subtitle: Text(
                              DateFormat('dd/MM/yyyy HH:mm').format(
                                _chatData['messages'][index]['sentOn'].toDate(),
                              ),
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.white54,
                              ),
                            ),
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
              color: Colors.grey[900].withOpacity(
                0.5,
              ),
              child: IconButton(
                onPressed: () async {
                  await _databaseService.sendMessage(
                    widget.chat['id'],
                    FirebaseAuth.instance.currentUser.uid,
                    _textController.text,
                  );
                  _textController.clear();
                  _messagesController
                      .jumpTo(_messagesController.position.maxScrollExtent);
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
