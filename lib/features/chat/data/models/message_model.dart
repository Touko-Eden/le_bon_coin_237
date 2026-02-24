class MessageModel {
  final int id;
  final int conversationId;
  final int senderId;
  final String content;
  final DateTime createdAt;

  MessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.content,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      conversationId: json['conversationId'],
      senderId: json['senderId'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
