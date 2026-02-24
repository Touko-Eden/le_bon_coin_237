import 'package:dartz/dartz.dart';
import '../../data/models/conversation_model.dart';
import '../../data/models/message_model.dart';
import '../../../../core/errors/failures.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<ConversationModel>>> getConversations();
  Future<Either<Failure, ConversationModel>> createOrGetConversation({required int receiverId, int? annonceId});
  Future<Either<Failure, List<MessageModel>>> getMessages(int conversationId);
  Future<Either<Failure, MessageModel>> sendMessage({required int conversationId, required String content});
  Future<Either<Failure, void>> markAsRead(int conversationId);
}
