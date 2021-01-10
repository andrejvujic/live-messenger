import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:live_messanger/screens/chart_name.dart';
import 'package:live_messanger/screens/participants.dart';
import 'package:live_messanger/services/database_service.dart';
import 'package:live_messanger/services/notifications_service.dart';
import 'package:live_messanger/widgets/chat/message_tile.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:visibility_detector/visibility_detector.dart';
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
  Map<String, String> _fcmTokens = {};
  bool _isDrawerOpen = false, _isLoading = false;

  final _notifications = NotificationsService();
  final _db = DatabaseService(uid: FirebaseAuth.instance.currentUser.uid);

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

  void _saveChatRoomTitle(String _chatRoomId, String _newChatRoomTitle) async {
    if (_newChatRoomTitle.length > 0) {
      setState(() => _isLoading = true);
      try {
        await _db.saveChatRoomTitle(_chatRoomId, _newChatRoomTitle);
      } catch (e) {
        print(e);
      }
      setState(() => _isLoading = false);

      Navigator.pop(context);
    }
  }

  void _getFcmTokens(List<QueryDocumentSnapshot> _data) {
    for (int i = 0; i < _data.length; i++) {
      _fcmTokens[_data[i].data()['userId']] = _data[i].data()['fcmToken'];
    }
  }

  void _notifyParticipants(String _chatTitle, String _userName,
      String _messageText, Map<String, String> _fcmTokens) {
    final List<dynamic> _participantIds = widget.chat['participants'];

    for (var _participantId in _participantIds) {
      if (_fcmTokens.containsKey(_participantId) &&
          _participantId != FirebaseAuth.instance.currentUser.uid) {
        _notifications.send(
          receiverId: _participantId,
          recieverFcmToken: _fcmTokens[_participantId],
          notificationTitle: 'Nova poruka',
          notificationBody:
              '(${widget.chat['title']}) $_userName: $_messageText',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          widget.chat['title'],
        ),
      ),
      endDrawer: VisibilityDetector(
        key: Key('end-drawer-key'),
        onVisibilityChanged: (VisibilityInfo _visibilityInfo) => setState(() =>
            _isDrawerOpen =
                (_visibilityInfo.visibleFraction > 0.0) ? true : false),
        child: Drawer(
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
                        backgroundColor: Colors.grey[800],
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
              ChatName(
                chatRoomTitle: widget.chat['title'],
                chatRoomId: widget.chat['id'],
                saveChatRoomTitle: _saveChatRoomTitle,
              ),
              Participants(
                participants: widget.chat['participants'],
                chatRoomId: widget.chat['id'],
              ),
            ],
          ),
        ),
      ),
      body: LoadingOverlay(
        isLoading: _isLoading,
        color: Colors.black,
        child: StreamBuilder(
          stream: _db.chatData(widget.chat['id']),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_messagesController.hasClients) {
                _messagesController
                    .jumpTo(_messagesController.position.maxScrollExtent);
              } else {
                setState(() => null);
              }
            });
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final Map<String, dynamic> _chatData = snapshot.data.data();

            return StreamBuilder(
              stream: _db.usersFcmTokens,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                List<QueryDocumentSnapshot> _data = snapshot.data.docs;
                _getFcmTokens(_data);

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
                                  Theme(
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
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        margin: (_isDrawerOpen)
            ? EdgeInsets.all(0.0)
            : MediaQuery.of(context).viewInsets,
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
                    final String _messageText = _textController.text;
                    _textController.clear();

                    await _db.sendMessage(
                      widget.chat['id'],
                      FirebaseAuth.instance.currentUser.uid,
                      FirebaseAuth.instance.currentUser.photoURL,
                      _messageText,
                    );
                    _notifyParticipants(
                      widget.chat['title'],
                      FirebaseAuth.instance.currentUser.displayName,
                      _messageText,
                      _fcmTokens,
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
