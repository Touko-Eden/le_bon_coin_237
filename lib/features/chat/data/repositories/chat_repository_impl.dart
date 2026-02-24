import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../datasources/chat_remote_datasource.dart';
import '../models/conversation_model.dart';
import '../models/message_model.dart';
import '../../domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remote;
  ChatRepositoryImpl({required this.remote});

  @override
  Future<Either<Failure, List<ConversationModel>>> getConversations() async {
    try {
      final data = await remote.getConversations();
      return Right(data);
    } on DioException catch (e) {
      return Left(
          ServerFailure(e.response?.data['message'] ?? 'Erreur serveur'));
    } catch (e) {
      return Left(ServerFailure('Erreur inattendue: $e'));
    }
  }

  @override
  Future<Either<Failure, ConversationModel>> createOrGetConversation(
      {required int receiverId, int? annonceId}) async {
    try {
      final data = await remote.createOrGetConversation(
          receiverId: receiverId, annonceId: annonceId);
      return Right(data);
    } on DioException catch (e) {
      return Left(
          ServerFailure(e.response?.data['message'] ?? 'Erreur serveur'));
    } catch (e) {
      return Left(ServerFailure('Erreur inattendue: $e'));
    }
  }

  @override
  Future<Either<Failure, List<MessageModel>>> getMessages(
      int conversationId) async {
    try {
      final data = await remote.getMessages(conversationId);
      return Right(data);
    } on DioException catch (e) {
      return Left(
          ServerFailure(e.response?.data['message'] ?? 'Erreur serveur'));
    } catch (e) {
      return Left(ServerFailure('Erreur inattendue: $e'));
    }
  }

  @override
  Future<Either<Failure, MessageModel>> sendMessage(
      {required int conversationId, required String content}) async {
    try {
      final data = await remote.sendMessage(
          conversationId: conversationId, content: content);
      return Right(data);
    } on DioException catch (e) {
      return Left(
          ServerFailure(e.response?.data['message'] ?? 'Erreur serveur'));
    } catch (e) {
      return Left(ServerFailure('Erreur inattendue: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(int conversationId) async {
    try {
      await remote.markAsRead(conversationId);
      return const Right(null);
    } on DioException catch (e) {
      return Left(
          ServerFailure(e.response?.data['message'] ?? 'Erreur serveur'));
    } catch (e) {
      return Left(ServerFailure('Erreur inattendue: $e'));
    }
  }
}
