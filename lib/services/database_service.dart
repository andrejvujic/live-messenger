import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class DatabaseService {
  final String uid;
  DatabaseService({
    this.uid,
  });

  final CollectionReference chats =
      FirebaseFirestore.instance.collection('chats');
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference fcmTokens =
      FirebaseFirestore.instance.collection('fcmTokens');

  Future<void> saveFcmDeviceToken(FirebaseMessaging _fcm) async {
    /// Saves the device token that is used
    /// in the NotificationService class when sending
    /// notifications
    final String _token = await _fcm.getToken();
    await fcmTokens.doc(uid).set({
      'fcmToken': _token,
      'userId': uid,
    });

    Map<String, dynamic> _userData =
        await users.doc(uid).get().then((value) => value.data());
    _userData['fcmToken'] = _token;
    await users.doc(uid).set(_userData);
  }

  Future<void> syncFcmDeviceToken(FirebaseMessaging _fcm) async {
    final String _token = await _fcm.getToken();
    Map<String, dynamic> _userData =
        await users.doc(uid).get().then((value) => value.data());

    if (_userData['fcmToken'] != _token) {
      await saveFcmDeviceToken(_fcm);
    }
  }

  Future<void> saveChatRoomTitle(
    String _chatRoomId,
    String _newChatRoomTitle,
  ) async {
    final Map<String, dynamic> _chatRoomData =
        await chats.doc(_chatRoomId).get().then((value) => value.data());
    _chatRoomData['title'] = _newChatRoomTitle;
    await chats.doc(_chatRoomId).set(_chatRoomData);
  }

  Future<void> updateChatRoomData(Map<String, dynamic> _chatRoomData) async =>
      await chats.doc(_chatRoomData['id']).set(_chatRoomData);

  Future<void> createNewChatRoom() async {
    final Map<String, dynamic> _chatRoomData = {
      'id': '',
      'createdOn': Timestamp.now(),
      'lastMessageOn': Timestamp.now(),
      'admins': <String>[
        uid,
      ],
      'participants': <String>[
        uid,
      ],
      'messages': [],
      'title': 'Razgovor',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/live-messenger-7026d.appspot.com/o/default.jpg?alt=media&token=946763bc-3486-4968-abf6-a6085398ef73'
    };

    _chatRoomData['id'] =
        await chats.add(_chatRoomData).then((data) => data.id);
    await updateChatRoomData(_chatRoomData);
  }

  Future<void> removeChatRoom(String _id) async =>
      await chats.doc(_id).delete();

  Future<void> sendMessage(String _chatRoomId, String _senderId,
      String _senderPhotoUrl, String _messageText) async {
    final Map<String, dynamic> _chatRoomData =
        await chats.doc(_chatRoomId).get().then((value) => value.data());

    _chatRoomData['messages'].add({
      'text': _messageText,
      'senderId': _senderId,
      'senderPhotoUrl': _senderPhotoUrl,
      'sentOn': Timestamp.now(),
    });

    await chats.doc(_chatRoomId).set(_chatRoomData);
  }

  Future<void> addUser(
    String _email,
    String _name,
    String _photoUrl,
  ) async {
    final Map<String, dynamic> _userData = {
      'email': _email,
      'name': _name,
      'photoUrl': _photoUrl,
      'id': uid,
    };

    await users.doc(uid).set(_userData);
  }

  Future<String> addParticipantToChatRoom(
      String _chatRoomId, String _userId) async {
    final Map<String, dynamic> _chatRoomData =
        await chats.doc(_chatRoomId).get().then((value) => value.data());

    if (!_chatRoomData['participants'].contains(_userId)) {
      _chatRoomData['participants'].add(_userId);
      await chats.doc(_chatRoomId).set(_chatRoomData);
      return 'Korisnik je uspješno dodan medju učesnike ovog razgovora.';
    }

    return 'Nije bilo moguće dodati korisnika medju učesnike ovog razgovora jer on već učesnik ovog razgovora.';
  }

  Stream<QuerySnapshot> get usersFcmTokens => fcmTokens.snapshots();

  Stream<DocumentSnapshot> chatData(String _chatRoomId) =>
      chats.doc(_chatRoomId).snapshots();

  Stream<DocumentSnapshot> get userData => users.doc(uid).snapshots();

  Stream<QuerySnapshot> get userChats => chats
      .orderBy('lastMessageOn', descending: true)
      .where('participants', arrayContains: uid)
      .snapshots();

  Future<List<QueryDocumentSnapshot>> getUserDataByEmail(
    String _searchEmail,
  ) =>
      users
          .where('email', isEqualTo: _searchEmail)
          .get()
          .then((value) => value.docs);
}
