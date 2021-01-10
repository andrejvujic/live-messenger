import 'package:flutter/material.dart';
import 'package:live_messanger/widgets/buttons/solid_button.dart';

class InfoAlert {
  final String title, text;

  InfoAlert({
    this.title,
    this.text,
  });

  Future<void> show(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: AlertDialog(
            backgroundColor: Colors.grey[900],
            title: Text(
              title,
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'Poppins-Bold',
                color: Colors.white,
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              SolidButton(
                child: Text(
                  'OK',
                  style: TextStyle(
                    fontFamily: 'Poppins-Bold',
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }
}
