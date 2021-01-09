import 'package:flutter/material.dart';
import 'package:live_messanger/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                      top: 225.0,
                    ),
                    width: 350.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              75.0,
                            ),
                          ),
                          child: Image.asset(
                            'assets/icon-light.png',
                            height: 50.0,
                          ),
                        ),
                        Text(
                          'Live Messanger',
                          style: TextStyle(
                            fontSize: 32.0,
                            fontFamily: 'Poppins-Bold',
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 5.0,
                      bottom: 75.0,
                    ),
                    child: Text(
                      'Razgovarajte sa porodicom i prijateljima, sigurno i potpuno besplatno.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  GoogleSignInButton(
                    darkMode: true,
                    onPressed: () async =>
                        context.read<AuthService>().signInWithGoogle(),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 20.0,
              child: Column(
                children: <Widget>[
                  Text(
                    'Copyright © 2021 Andrej Vujić',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'All rights reserved.',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
