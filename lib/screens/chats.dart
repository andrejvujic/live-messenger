import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:live_messanger/screens/chat.dart';
import 'package:live_messanger/screens/route_builder.dart';
import 'package:live_messanger/services/database_service.dart';
import 'package:live_messanger/utils/utils.dart';
import 'package:live_messanger/widgets/alerts/yes_no_alert.dart';
import 'package:live_messanger/widgets/chat/chat_tile.dart';

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  final DatabaseService _db = DatabaseService(
    uid: FirebaseAuth.instance.currentUser.uid,
  );
  final _utils = Utils();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: _db.userChats,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            final List<QueryDocumentSnapshot> _chats = snapshot.data.docs;

            return (_chats.length > 0)
                ? Column(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: ListView.builder(
                                itemCount: _chats.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    key: Key(
                                      _chats[index]['id'],
                                    ),
                                    child: ChatTile(
                                      trailingWidth: 50.0,
                                      onTap: () => Navigator.push(
                                        context,
                                        buildRoute(
                                          Chat(
                                            chat: _chats[index].data(),
                                          ),
                                        ),
                                      ),
                                      leading: CachedNetworkImageProvider(
                                        _chats[index]['image'],
                                      ),
                                      title: Text(
                                        _chats[index]['title'],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      subtitle: Text(
                                        _utils.getLastChatActivity(
                                          _chats[index]['lastMessageOn']
                                              .toDate(),
                                        ),
                                        style: TextStyle(
                                          color: Colors.white54,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                      trailing: IconButton(
                                        onPressed: () => YesNoAlert(
                                          title: 'Upozorenje',
                                          text:
                                              'Da li ste sigurni da želite da obrišete ovaj razgovor? Nećete ga moći vratiti.',
                                          onYesPressed: () =>
                                              _db.removeChatRoom(
                                            _chats[index]['id'],
                                          ),
                                        ).show(context),
                                        icon: Icon(
                                          Icons.clear,
                                          color: Colors.deepOrange,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                : Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Nema razgovora',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                            fontFamily: 'Poppins-Bold',
                          ),
                        ),
                        Text(
                          'Trenutno niste učesnik nijednog razgovora. Kada budete, svi vaši razgovori će biti prikazani ovdje.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _db.createNewChatRoom(),
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
