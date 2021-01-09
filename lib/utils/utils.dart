import 'package:intl/intl.dart';

class Utils {
  Utils();

  String getLastChatActivity(DateTime _lastMessageOn) {
    return (DateFormat().add_yMMMd().format(_lastMessageOn) ==
            DateFormat().add_yMMMd().format(DateTime.now()))
        ? 'Danas u ${DateFormat().add_Hm().format(_lastMessageOn)}'
        : '${DateFormat('dd/MM/yyyy').format(_lastMessageOn)} u ${DateFormat().add_Hm().format(_lastMessageOn)}';
  }
}
