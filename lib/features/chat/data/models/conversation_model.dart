class ConversationModel {
  final int id;
  final int user1Id;
  final int user2Id;
  final int? annonceId;
  final String? lastMessageText;
  final DateTime? lastMessageAt;
  final int unreadForUser1;
  final int unreadForUser2;
  final Map<String, dynamic>? user1;
  final Map<String, dynamic>? user2;
  final Map<String, dynamic>? annonce;

  ConversationModel({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    required this.annonceId,
    required this.lastMessageText,
    required this.lastMessageAt,
    required this.unreadForUser1,
    required this.unreadForUser2,
    required this.user1,
    required this.user2,
    required this.annonce,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'],
      user1Id: json['user1Id'],
      user2Id: json['user2Id'],
      annonceId: json['annonceId'],
      lastMessageText: json['lastMessageText'],
      lastMessageAt: json['lastMessageAt'] != null ? DateTime.parse(json['lastMessageAt']) : null,
      unreadForUser1: json['unreadForUser1'] ?? 0,
      unreadForUser2: json['unreadForUser2'] ?? 0,
      user1: json['user1'],
      user2: json['user2'],
      annonce: json['annonce'],
    );
  }
}
