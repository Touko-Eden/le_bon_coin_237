import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
  @override
  List<Object?> get props => [];
}

class LoadConversationsEvent extends ChatEvent {}

class CreateOrGetConversationEvent extends ChatEvent {
  final int receiverId;
  final int? annonceId;
  const CreateOrGetConversationEvent(
      {required this.receiverId, this.annonceId});
  @override
  List<Object?> get props => [receiverId, annonceId];
}

class LoadMessagesEvent extends ChatEvent {
  final int conversationId;
  const LoadMessagesEvent(this.conversationId);
  @override
  List<Object?> get props => [conversationId];
}

class SendMessageEvent extends ChatEvent {
  final int conversationId;
  final String content;
  const SendMessageEvent({required this.conversationId, required this.content});
  @override
  List<Object?> get props => [conversationId, content];
}

class MarkAsReadEvent extends ChatEvent {
  final int conversationId;
  const MarkAsReadEvent(this.conversationId);
  @override
  List<Object?> get props => [conversationId];
}
