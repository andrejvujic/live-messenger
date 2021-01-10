import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:live_messanger/services/database_service.dart';
import 'package:live_messanger/widgets/alerts/info_alert.dart';
import 'package:live_messanger/widgets/divider/text_divider.dart';
import 'package:live_messanger/widgets/inputs/text_input.dart';
import 'package:loading_overlay/loading_overlay.dart';

class AddParticipant extends StatefulWidget {
  @override
  _AddParticipantState createState() => _AddParticipantState();

  final String chatRoomId;
  AddParticipant({
    this.chatRoomId,
  });
}

class _AddParticipantState extends State<AddParticipant> {
  final _db = DatabaseService(uid: FirebaseAuth.instance.currentUser.uid);
  final _controller = TextEditingController();

  bool _isLoading = false, _isLoadingResult = false;
  Map<String, dynamic> _searchResult;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dodaj učesnika'),
        automaticallyImplyLeading: !_isLoading,
      ),
      body: LoadingOverlay(
        isLoading: _isLoading,
        color: Colors.black,
        child: Column(
          children: <Widget>[
            SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextInput(
                          width: MediaQuery.of(context).size.width * 0.75,
                          labelText: 'Email',
                          hintText: 'Unesite email',
                          keyboardType: TextInputType.emailAddress,
                          controller: _controller,
                        ),
                        IconButton(
                          onPressed: () async {
                            setState(() => _isLoadingResult = true);
                            final List<QueryDocumentSnapshot> _docSnapshot =
                                await _db.getUserDataByEmail(_controller.text);

                            setState(() {
                              _isLoadingResult = false;
                              _searchResult = ((_docSnapshot?.length ?? 0) > 0)
                                  ? _docSnapshot[0].data()
                                  : {};
                            });
                          },
                          tooltip: 'Pretraži',
                          splashRadius: 20.0,
                          icon: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    TextDivider(
                      dividerHeight: 64.0,
                      widgetMargin: EdgeInsets.symmetric(
                        horizontal: 5.0,
                      ),
                      childMargin: EdgeInsets.symmetric(
                        horizontal: 5.0,
                      ),
                      child: Text(
                        'Rezultati',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    (_isLoadingResult)
                        ? CircularProgressIndicator()
                        : Container(),
                    ((_searchResult?.length ?? 0) > 0 && !_isLoadingResult)
                        ? ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.grey[800],
                              backgroundImage: CachedNetworkImageProvider(
                                _searchResult['photoUrl'],
                              ),
                            ),
                            title: Text(
                              _searchResult['name'],
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            subtitle: Text(
                              _searchResult['email'],
                              style: TextStyle(
                                color: Colors.white54,
                              ),
                            ),
                            trailing: Container(
                              width: MediaQuery.of(context).size.width * 0.15,
                              child: IconButton(
                                tooltip: 'Dodaj učesnika',
                                onPressed: () async {
                                  setState(() => _isLoading = true);
                                  try {
                                    InfoAlert(
                                      title: 'Informacija',
                                      text: await _db.addParticipantToChatRoom(
                                        widget.chatRoomId,
                                        _searchResult['id'],
                                      ),
                                    ).show(context);
                                  } catch (e) {}
                                  setState(() => _isLoading = false);
                                },
                                splashRadius: 24.0,
                                icon: Icon(
                                  Icons.done,
                                  color: Colors.green,
                                  size: 36.0,
                                ),
                              ),
                            ),
                          )
                        : (_isLoadingResult)
                            ? Container()
                            : (_searchResult == null)
                                ? Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.85,
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          'Započnite pretragu',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Poppins-Bold',
                                            fontSize: 18.0,
                                          ),
                                        ),
                                        Text(
                                          'Unesite email pa pritisnite na lupu i tako započnite pretragu.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white54,
                                            fontFamily: 'Poppins-Bold',
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.85,
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          'Korisnik nije pronađen',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Poppins-Bold',
                                            fontSize: 18.0,
                                          ),
                                        ),
                                        Text(
                                          'Korisnik ne postoji ili je obrisan. Provjerite da li ste unijeli tačan email, pa pokušajte ponovo.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white54,
                                            fontFamily: 'Poppins-Bold',
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
