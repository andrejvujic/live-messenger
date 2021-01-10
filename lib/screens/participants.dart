import 'package:flutter/material.dart';
import 'package:live_messanger/screens/add_participant.dart';
import 'package:live_messanger/screens/participant.dart';
import 'package:live_messanger/screens/route_builder.dart';
import 'package:live_messanger/widgets/buttons/solid_button.dart';
import 'package:live_messanger/widgets/divider/text_divider.dart';

class Participants extends StatefulWidget {
  @override
  _ParticipantsState createState() => _ParticipantsState();

  final String chatRoomId;
  final List<dynamic> participants;
  Participants({
    this.participants,
    this.chatRoomId,
  });
}

class _ParticipantsState extends State<Participants> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        fontFamily: 'Poppins-Regular',
        primarySwatch: Colors.grey,
      ),
      child: Container(
        height: 375.0,
        child: Column(
          children: <Widget>[
            TextDivider(
              widgetMargin: EdgeInsets.symmetric(horizontal: 5.0),
              childMargin: EdgeInsets.symmetric(horizontal: 5.0),
              child: Text(
                'Učesnici (${widget.participants.length})',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.all(0.0),
                      itemCount: widget.participants.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Participant(
                          userId: widget.participants[index],
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
            SolidButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  buildRoute(
                    AddParticipant(
                      chatRoomId: widget.chatRoomId,
                    ),
                  ),
                );
              },
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    'Dodaj',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
            TextDivider(
              widgetMargin: EdgeInsets.symmetric(horizontal: 5.0),
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
