import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondmain_237/core/constants/app_colors.dart';
import 'package:secondmain_237/core/network/socket_service.dart';
import 'package:secondmain_237/features/authentification/presentation/bloc/auth_bloc.dart';
import 'package:secondmain_237/features/authentification/presentation/bloc/auth_state.dart';
import '../../data/models/message_model.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';

class ChatPage extends StatefulWidget {
  final int conversationId;
  final String otherName;
  const ChatPage({super.key, required this.conversationId, required this.otherName});
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  late final int _conversationId;

  @override
  void initState() {
    super.initState();
    _conversationId = widget.conversationId;
    context.read<ChatBloc>().add(LoadMessagesEvent(_conversationId));
    context.read<ChatBloc>().add(MarkAsReadEvent(_conversationId));
    socketService.connect();
    socketService.on('message:new', (data) {
      if (data is Map && data['conversationId'] == _conversationId) {
        context.read<ChatBloc>().add(LoadMessagesEvent(_conversationId));
        context.read<ChatBloc>().add(MarkAsReadEvent(_conversationId));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.otherName)),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatLoading) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                }
                if (state is MessagesLoaded && state.conversationId == widget.conversationId) {
                  return _buildMessages(state.messages);
                }
                if (state is ChatError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          _buildInput(),
        ],
      ),
    );
  }

  Widget _buildMessages(List<MessageModel> messages) {
    final authState = context.read<AuthBloc>().state;
    final currentUserId = (authState is Authenticated) ? authState.user.id : null;

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final m = messages[index];
        final isMine = (currentUserId != null && m.senderId == currentUserId);
        return Align(
          alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.all(10),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
            decoration: BoxDecoration(
              color: isMine ? AppColors.primary : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              m.content,
              style: TextStyle(color: isMine ? Colors.white : Colors.black87),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInput() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Votre message...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.send, color: AppColors.primary),
              onPressed: () {
                final txt = _controller.text.trim();
                if (txt.isNotEmpty) {
                  context.read<ChatBloc>().add(SendMessageEvent(conversationId: widget.conversationId, content: txt));
                  _controller.clear();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
