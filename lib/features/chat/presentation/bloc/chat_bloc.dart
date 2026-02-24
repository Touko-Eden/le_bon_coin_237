import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/chat_repository.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository repo;
  ChatBloc({required this.repo}) : super(ChatInitial()) {
    on<LoadConversationsEvent>(_onLoadConversations);
    on<CreateOrGetConversationEvent>(_onCreateOrGetConversation);
    on<LoadMessagesEvent>(_onLoadMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<MarkAsReadEvent>(_onMarkAsRead);
  }

  Future<void> _onMarkAsRead(MarkAsReadEvent event, Emitter<ChatState> emit) async {
    // On ne change pas l'état (loading) pour ça, c'est en arrière plan
    await repo.markAsRead(event.conversationId);
    // On pourrait recharger les conversations pour mettre à jour le badge
    add(LoadConversationsEvent());
  }

  Future<void> _onLoadConversations(LoadConversationsEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    final res = await repo.getConversations();
    res.fold(
      (l) => emit(ChatError(l.message)),
      (r) => emit(ConversationsLoaded(r)),
    );
  }

  Future<void> _onCreateOrGetConversation(CreateOrGetConversationEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    final res = await repo.createOrGetConversation(receiverId: event.receiverId, annonceId: event.annonceId);
    res.fold(
      (l) => emit(ChatError(l.message)),
      (r) => emit(ConversationReady(r)),
    );
  }

  Future<void> _onLoadMessages(LoadMessagesEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    final res = await repo.getMessages(event.conversationId);
    res.fold(
      (l) => emit(ChatError(l.message)),
      (r) => emit(MessagesLoaded(event.conversationId, r)),
    );
  }

  Future<void> _onSendMessage(SendMessageEvent event, Emitter<ChatState> emit) async {
    final res = await repo.sendMessage(conversationId: event.conversationId, content: event.content);
    res.fold(
      (l) => emit(ChatError(l.message)),
      (r) async {
        // recharger les messages après l'envoi
        final res2 = await repo.getMessages(event.conversationId);
        res2.fold(
          (l2) => emit(ChatError(l2.message)),
          (r2) => emit(MessagesLoaded(event.conversationId, r2)),
        );
      },
    );
  }
}
