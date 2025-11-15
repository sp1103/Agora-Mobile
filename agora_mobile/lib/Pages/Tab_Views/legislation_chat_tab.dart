import 'package:agora_mobile/Types/chat_message.dart';
import 'package:agora_mobile/Types/legislation.dart';
import 'package:flutter/material.dart';

class LegislationChatTab extends StatefulWidget {
  final Legislation legislation;

  const LegislationChatTab({super.key, required this.legislation});

  @override
  State<LegislationChatTab> createState() => _LegislationChatTabState();
}

class _LegislationChatTabState extends State<LegislationChatTab> {
  List<ChatMessage> _messages = [];

  TextEditingController _messageController = TextEditingController();

  ScrollController _scrollController = ScrollController();

  bool _isLoading = false;

  String? _errorMessage;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _messages.length,
          itemBuilder: (context, index) {
            final message = _messages[index];
            final isUser = _messages[index].role == "user";
            return Container(
              alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isUser ? Colors.blue : Colors.grey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  message.content,
                  style: TextStyle(
                    color: isUser ? Colors.white : Colors.black,
                  ),
                ),
              ),
            );
          },
        ),
      ),
      Container(
        child: Row(children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) => _sendMessage(),
              enabled: !_isLoading,
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _isLoading ? null : _sendMessage,
          ),
        ]),
      )
    ]);
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(role: "user", content: text));

      _messageController.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    //TODO: Call Deepseek API to get response
  }
}
