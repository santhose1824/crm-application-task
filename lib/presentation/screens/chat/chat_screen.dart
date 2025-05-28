import 'package:crm_application/bloc/chat/chat_bloc.dart';
import 'package:crm_application/bloc/chat/chat_event.dart';
import 'package:crm_application/bloc/chat/chat_state.dart';
import 'package:crm_application/data/model/message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatScreen extends StatefulWidget {
  final String currentUserId;
  final String peerId;
  final String peerName;

  const ChatScreen({
    super.key,
    required this.currentUserId,
    required this.peerId,
    required this.peerName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(LoadMessages(widget.currentUserId, widget.peerId));
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      final message = MessageModel(
        id: '',
        senderId: widget.currentUserId,
        receiverId: widget.peerId,
        message: text,
        timestamp: DateTime.now(),
      );
      context.read<ChatBloc>().add(SendMessage(message));
      _messageController.clear();
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 80,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.peerName,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ChatLoaded) {
                  final messages = state.messages;

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    itemCount: messages.length,
                    itemBuilder: (_, index) {
                      final message = messages[index];
                      final isMe = message.senderId == widget.currentUserId;
                      final initial = isMe
                          ? 'Me'
                          : widget.peerName.isNotEmpty
                          ? widget.peerName[0].toUpperCase()
                          : '?';

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: isMe
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          if (!isMe)
                            Padding(
                              padding: const EdgeInsets.only(top: 8, right: 6),
                              child: CircleAvatar(
                                backgroundColor: Colors.indigo.shade100,
                                radius: 18,
                                child: Text(
                                  initial,
                                  style: GoogleFonts.poppins(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          Flexible(
                            child: Container(
                              margin: EdgeInsets.only(
                                left: isMe ? 60 : 0,
                                right: isMe ? 0 : 60,
                                top: 6,
                                bottom: 6,
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: isMe ? Colors.indigo : Colors.grey[200],
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(16),
                                  topRight: const Radius.circular(16),
                                  bottomLeft: Radius.circular(isMe ? 16 : 0),
                                  bottomRight: Radius.circular(isMe ? 0 : 16),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.03),
                                    offset: const Offset(0, 2),
                                    blurRadius: 4,
                                  )
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    message.message,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color:
                                      isMe ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      timeago.format(message.timestamp),
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        color: isMe
                                            ? Colors.white70
                                            : Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (isMe)
                            Padding(
                              padding: const EdgeInsets.only(top: 8, left: 6),
                              child: CircleAvatar(
                                backgroundColor: Colors.indigo.shade100,
                                radius: 18,
                                child: Text(
                                  'Me',
                                  style: GoogleFonts.poppins(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  );
                } else if (state is ChatError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox();
              },
            ),
          ),

          // 📨 Message Input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            color: Colors.grey.shade100,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: GoogleFonts.poppins(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.indigo,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
