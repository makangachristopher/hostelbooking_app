class NotificationModel {
  final String notificationID;
  final String recipientID;
  final String content;
  final DateTime timestamp;
  bool readStatus;

  NotificationModel({
    required this.notificationID,
    required this.recipientID,
    required this.content,
    required this.timestamp,
    required this.readStatus,
  });
}
