import 'package:flutter/material.dart';
import 'package:live_messanger/widgets/buttons/solid_button.dart';

class YesNoAlert {
  final String title, text;
  final Function onYesPressed, onNoPressed;
  YesNoAlert({
    this.title,
    this.text,
    this.onYesPressed,
    this.onNoPressed,
  });

  Future<void> show(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: AlertDialog(
            backgroundColor: Colors.grey[900].withOpacity(
              0.45,
            ),
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
                  'NE',
                  style: TextStyle(
                    fontFamily: 'Poppins-Bold',
                    fontSize: 16.0,
                    color: Colors.red[600],
                  ),
                ),
                highlightColor: Colors.red,
                splashColor: Colors.red,
                onPressed: () {
                  onNoPressed?.call();
                  Navigator.pop(context);
                },
              ),
              SolidButton(
                child: Text(
                  'DA',
                  style: TextStyle(
                    fontFamily: 'Poppins-Bold',
                    fontSize: 16.0,
                    color: Colors.lightGreen[600],
                  ),
                ),
                highlightColor: Colors.green,
                splashColor: Colors.green,
                onPressed: () {
                  onYesPressed?.call();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
