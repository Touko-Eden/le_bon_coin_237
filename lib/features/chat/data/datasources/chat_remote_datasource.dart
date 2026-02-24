import 'package:dio/dio.dart';
import 'package:secondmain_237/core/constants/api_constants.dart';
import 'package:secondmain_237/core/network/dio_client.dart';
import '../models/conversation_model.dart';
import '../models/message_model.dart';

abstract class ChatRemoteDataSource {
  Future<List<ConversationModel>> getConversations();
  Future<ConversationModel> createOrGetConversation(
      {required int receiverId, int? annonceId});
  Future<List<MessageModel>> getMessages(int conversationId);
  Future<MessageModel> sendMessage(
      {required int conversationId, required String content});
  Future<void> markAsRead(int conversationId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final DioClient dioClient;
  ChatRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<ConversationModel>> getConversations() async {
    final response = await dioClient.get(ApiConstants.chatConversations);
    if (response.data['success'] == true) {
      final List<dynamic> data = response.data['data'];
      return data.map((e) => ConversationModel.fromJson(e)).toList();
    }
    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      type: DioExceptionType.badResponse,
      error: response.data['message'] ?? 'Erreur chargement conversations',
    );
  }

  @override
  Future<ConversationModel> createOrGetConversation(
      {required int receiverId, int? annonceId}) async {
    final response = await dioClient.post(
      ApiConstants.chatConversations,
      data: {
        'receiverId': receiverId,
        if (annonceId != null) 'annonceId': annonceId
      },
    );
    if (response.data['success'] == true) {
      return ConversationModel.fromJson(response.data['data']);
    }
    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      type: DioExceptionType.badResponse,
      error: response.data['message'] ?? 'Erreur création conversation',
    );
  }

  @override
  Future<List<MessageModel>> getMessages(int conversationId) async {
    final response =
        await dioClient.get(ApiConstants.chatMessages(conversationId));
    if (response.data['success'] == true) {
      final List<dynamic> data = response.data['data'];
      return data.map((e) => MessageModel.fromJson(e)).toList();
    }
    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      type: DioExceptionType.badResponse,
      error: response.data['message'] ?? 'Erreur chargement messages',
    );
  }

  @override
  Future<MessageModel> sendMessage(
      {required int conversationId, required String content}) async {
    final response = await dioClient.post(
        ApiConstants.chatMessages(conversationId),
        data: {'content': content});
    if (response.data['success'] == true) {
      return MessageModel.fromJson(response.data['data']);
    }
    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      type: DioExceptionType.badResponse,
      error: response.data['message'] ?? 'Erreur envoi message',
    );
  }

  @override
  Future<void> markAsRead(int conversationId) async {
    final response =
        await dioClient.put(ApiConstants.chatMarkRead(conversationId));
    if (response.data['success'] == true) {
      return;
    }
    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      type: DioExceptionType.badResponse,
      error: response.data['message'] ?? 'Erreur marquage lecture',
    );
  }
}
