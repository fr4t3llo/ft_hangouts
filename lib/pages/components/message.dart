class Message {
  final DateTime date;
  final String text;
  final bool sentByMe;
  final String contactId;

  Message({
    required this.date,
    required this.text,
    required this.sentByMe,
    required this.contactId,
  });
}