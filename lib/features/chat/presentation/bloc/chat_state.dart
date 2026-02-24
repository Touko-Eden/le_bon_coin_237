import 'package:equatable/equatable.dart';
import '../../data/models/conversation_model.dart';
import '../../data/models/message_model.dart';

abstract class ChatState extends Equatable {
  const ChatState();
  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}
class ChatLoading extends ChatState {}

class ConversationsLoaded extends ChatState {
  final List<ConversationModel> conversations;
  const ConversationsLoaded(this.conversations);
  @override
  List<Object?> get props => [conversations];
}

class ConversationReady extends ChatState {
  final ConversationModel conversation;
  const ConversationReady(this.conversation);
  @override
  List<Object?> get props => [conversation];
}

class MessagesLoaded extends ChatState {
  final int conversationId;
  final List<MessageModel> messages;
  const MessagesLoaded(this.conversationId, this.messages);
  @override
  List<Object?> get props => [conversationId, messages];
}

class ChatError extends ChatState {
  final String message;
  const ChatError(this.message);
  @override
  List<Object?> get props => [message];
}
