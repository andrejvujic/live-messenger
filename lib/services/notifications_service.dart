import 'package:http/http.dart';
import 'dart:convert';

class NotificationsService {
  /// Handles sending FCM notifications
  /// using Google's FCM api
  NotificationsService();

  final String serverToken = '';

  Future<void> send({
    String receiverId,
    String recieverFcmToken,
    String notificationTitle,
    String notificationBody,
  }) async {
    /// Sends a notification with the
    /// given title and body to the given
    /// user
    Response r = await post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'title': notificationTitle,
            'body': notificationBody,
            'color': "#ff5722",
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'message_target_id': receiverId,
          },
          'to': recieverFcmToken,
        },
      ),
    );

    print('[NotificationService] ${r.body}, ${r.reasonPhrase}');
  }
}
