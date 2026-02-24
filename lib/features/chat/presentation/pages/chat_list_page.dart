import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondmain_237/core/constants/app_colors.dart';
import 'package:secondmain_237/core/network/socket_service.dart';
import 'package:secondmain_237/features/authentification/presentation/bloc/auth_bloc.dart';
import 'package:secondmain_237/features/authentification/presentation/bloc/auth_state.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';
import 'chat_page.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});
  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(LoadConversationsEvent());
    socketService.connect();
    socketService.on('conversation:updated', (_) {
      context.read<ChatBloc>().add(LoadConversationsEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Messagerie')),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Center(
                child: CircularProgressIndicator(color: AppColors.primary));
          }
          if (state is ConversationsLoaded) {
            if (state.conversations.isEmpty) {
              return const Center(child: Text('Aucune conversation'));
            }
            return ListView.separated(
              itemCount: state.conversations.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final c = state.conversations[index];

                final authState = context.read<AuthBloc>().state;
                final currentUserId =
                    (authState is Authenticated) ? authState.user.id : -1;

                final otherUser =
                    (c.user1Id == currentUserId) ? c.user2 : c.user1;
                final unreadCount = (c.user1Id == currentUserId)
                    ? c.unreadForUser1
                    : c.unreadForUser2;
                final otherName = otherUser?['fullName'] ?? 'Utilisateur';

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: Text(
                        (otherName.isNotEmpty ? otherName.substring(0, 1) : '?')
                            .toUpperCase(),
                        style: const TextStyle(color: AppColors.primary)),
                  ),
                  title: Text(otherName,
                      style: TextStyle(
                          fontWeight: unreadCount > 0
                              ? FontWeight.bold
                              : FontWeight.normal)),
                  subtitle: Text(
                    c.lastMessageText ?? 'Nouvelle conversation',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: unreadCount > 0
                            ? FontWeight.bold
                            : FontWeight.normal),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (c.lastMessageAt != null)
                        Text(
                          TimeOfDay.fromDateTime(c.lastMessageAt!)
                              .format(context),
                          style: TextStyle(
                            color: unreadCount > 0
                                ? AppColors.primary
                                : AppColors.textSecondary,
                            fontSize: 12,
                            fontWeight: unreadCount > 0
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      if (unreadCount > 0)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            unreadCount.toString(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) =>
                          ChatPage(conversationId: c.id, otherName: otherName),
                    ));
                  },
                );
              },
            );
          }
          if (state is ChatError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
