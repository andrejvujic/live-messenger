import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:live_messanger/services/database_service.dart';

class Participant extends StatefulWidget {
  @override
  _ParticipantState createState() => _ParticipantState();

  final String userId;
  Participant({
    this.userId,
  });
}

class _ParticipantState extends State<Participant> {
  DatabaseService _db;

  @override
  void initState() {
    _db = DatabaseService(uid: widget.userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _db.userData,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final Map<String, dynamic> _userData = snapshot.data.data();

        return ListTile(
          onTap: () => null,
          leading: CircleAvatar(
            backgroundColor: Colors.grey[800],
            backgroundImage: CachedNetworkImageProvider(
              _userData['photoUrl'],
            ),
          ),
          title: Text(
            _userData['name'],
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
          subtitle: Text(
            _userData['email'],
            style: TextStyle(
              color: Colors.white54,
              fontSize: 12.0,
            ),
          ),
        );
      },
    );
  }
}
