import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:live_messanger/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:live_messanger/screens/chat.dart';
import 'package:live_messanger/screens/route_builder.dart';
import 'package:live_messanger/services/database_service.dart';
import 'package:live_messanger/utils/utils.dart';
import 'package:live_messanger/widgets/alerts/yes_no_alert.dart';
import 'package:live_messanger/widgets/chat/chat_tile.dart';

Future<void> myBackgroundMessageHandler(Map<String, dynamic> message) async {}

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  final DatabaseService _db = DatabaseService(
    uid: FirebaseAuth.instance.currentUser.uid,
  );
  final _utils = Utils();
  final FirebaseMessaging _fcm = FirebaseMessaging();

  @override
  void initState() {
    _setUpFCM();
    super.initState();
  }

  Future<void> _onMessage(Map message) async {
    /// Called when the user recieves a
    /// notification and the app is
    /// running in the foreground

    print(message);
    if (message['data']['message_target_id'] ==
        FirebaseAuth.instance.currentUser.uid) {}
  }

  Future<void> _onLaunchOrResumeMessage(Map message) async {
    /// Called when the user clicks on
    /// a recieved notification and the
    /// app was closed or running in
    /// the background
    print(message);
    if (message['data']['message_target_id'] ==
        FirebaseAuth.instance.currentUser.uid) {}
  }

  void _setUpFCM() {
    /// Configures handling new
    /// notifications
    _fcm.configure(
      onMessage: _onMessage,
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: _onLaunchOrResumeMessage,
      onResume: _onLaunchOrResumeMessage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Moji razgovori'),
      ),
      drawer: Drawer(
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
                      backgroundColor: Colors.grey[800],
                      backgroundImage: CachedNetworkImageProvider(
                        FirebaseAuth.instance.currentUser.photoURL,
                      ),
                    ),
                    title: Text(
                      FirebaseAuth.instance.currentUser.displayName,
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
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              title: Text(
                'Odjavi se',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                ),
              ),
              onTap: () => context.read<AuthService>().signOut(),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: _db.userData,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            final Map<String, dynamic> userData = snapshot.data.data();

            if (userData == null) {
              _db.addUser(
                FirebaseAuth.instance.currentUser.email,
                FirebaseAuth.instance.currentUser.displayName,
                FirebaseAuth.instance.currentUser.photoURL,
              );
              _db.saveFcmDeviceToken(_fcm);
            } else {
              if (!(userData?.containsKey('fcmToken') ?? false)) {
                _db.saveFcmDeviceToken(_fcm);
              } else {
                _db.syncFcmDeviceToken(_fcm);
              }
            }

            return StreamBuilder(
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
                                    itemBuilder:
                                        (BuildContext context, int index) {
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
                                fontSize: 18.0,
                                color: Colors.white,
                                fontFamily: 'Poppins-Bold',
                              ),
                            ),
                            Text(
                              'Trenutno niste učesnik nijednog razgovora. Kada budete, svi vaši razgovori će biti prikazani ovdje.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white54,
                              ),
                            ),
                          ],
                        ),
                      );
              },
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
