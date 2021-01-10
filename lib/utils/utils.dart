import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class Utils {
  Utils();

  String getLastChatActivity(DateTime _lastMessageOn) => (DateFormat()
              .add_yMMMd()
              .format(_lastMessageOn) ==
          DateFormat().add_yMMMd().format(DateTime.now()))
      ? 'Danas u ${DateFormat().add_Hm().format(_lastMessageOn)}'
      : '${DateFormat('dd/MM/yyyy').format(_lastMessageOn)} u ${DateFormat().add_Hm().format(_lastMessageOn)}';

  bool isSentByUser(Map<String, dynamic> _messageData, String _userId) =>
      _messageData['senderId'] == _userId;

  bool isPreviousSentBySameUser(
          Map<String, dynamic> _chatData, int _index, String _userId) =>
      (_index - 1 > -1)
          ? isSentByUser(_chatData['messages'][_index - 1], _userId)
          : false;
}
