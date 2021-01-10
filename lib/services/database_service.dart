import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({
    this.uid,
  });

  final CollectionReference chats =
      FirebaseFirestore.instance.collection('chats');

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

  Stream<DocumentSnapshot> chatData(String _chatRoomId) =>
      chats.doc(_chatRoomId).snapshots();

  Stream<QuerySnapshot> get userChats => chats
      .orderBy('lastMessageOn', descending: true)
      .where('participants', arrayContains: uid)
      .snapshots();
}
