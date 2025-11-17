import 'package:agora_mobile/Types/character.dart';
import 'package:agora_mobile/Types/legislation.dart';
import 'package:provider/provider.dart';
import 'package:agora_mobile/app_state.dart';
import 'package:flutter/material.dart';

class LegislationChatTab extends StatefulWidget {
  final Legislation legislation;

  const LegislationChatTab({super.key, required this.legislation});

  @override
  State<LegislationChatTab> createState() => _LegislationChatTabState();
}

class _LegislationChatTabState extends State<LegislationChatTab> {

  final TextEditingController _messageController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  Character _selectedCharacter = Character.allCharacters[0];

  String? _errorMessage;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AgoraAppState>();
    final messages = appState.getChatHistory(widget.legislation.bill_id);
    final isLoading = appState.isChatLoading;
    final error = appState.chatError;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
          ),
          child: Row(
            children: [
              Text("Chat with: ",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(width: 8),
              DropdownButton<Character>(
                  value: _selectedCharacter,
                  items: Character.allCharacters.map((character) {
                    return DropdownMenuItem(
                      value: character,
                      child: Text(character.name),
                    );
                  }).toList(),
                  onChanged: (Character? newCharacter) {
                    if (newCharacter != null) {
                      setState(() {
                        _selectedCharacter = newCharacter;
                      });
                    }
                  })
            ],
          )),
      Expanded(
        child: ListView.builder(
          controller: _scrollController,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            final isUser = message.role == "user";

            return Container(
              alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Row(
                mainAxisAlignment:
                    isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isUser) ...[
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: _selectedCharacter.photoUrl.isNotEmpty
                          ? AssetImage(_selectedCharacter.photoUrl)
                          : null,
                      backgroundColor: Colors.indigo,
                      child: _selectedCharacter.photoUrl.isEmpty
                          ? Text(
                              _selectedCharacter.name[0],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )
                          : null,
                    ),
                    SizedBox(width: 8),
                  ],
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.blue : Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        message.content,
                        style: TextStyle(
                          color: isUser ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      if (error != null || _errorMessage != null)
        Container(
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.red[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red[300]!),
          ),
          child: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red[900]),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  error ?? _errorMessage ?? '',
                  style: TextStyle(color: Colors.red[900]),
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, size: 18),
                color: Colors.red[900],
                onPressed: () {
                  setState(() {
                    _errorMessage = null;
                  });
                },
              ),
            ],
          ),
        ),
      if (isLoading)
        Padding(
          padding: EdgeInsets.all(8),
          child: CircularProgressIndicator(),
        ),
      Row(children: [
        Expanded(
          child: TextField(
            controller: _messageController,
            decoration: InputDecoration(
              hintText: 'Type a message...',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) => _sendMessage(),
            enabled: !isLoading,
          ),
        ),
        IconButton(
          icon: Icon(Icons.send),
          onPressed: isLoading ? null : _sendMessage,
        ),
      ])
    ]);
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final appState = context.read<AgoraAppState>();
    final uid = appState.user?.uid;

    if (uid == null) {
      //Not logged in
      setState(() {
        _errorMessage = "You must be logged in to chat";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You must be logged in to chat'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    _messageController.clear();

    final messages = appState.getChatHistory(widget.legislation.bill_id);
    String? systemPrompt;
    if (messages.isEmpty) {
      systemPrompt = _buildSystemPrompt(_selectedCharacter);
      // messageToSend = "$context\n\nUser question: $text";
    }

    await appState.sendChatMessage(uid, widget.legislation.bill_id, text,
        systemPrompt: systemPrompt);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  String _buildSystemPrompt(Character character) {
    final legislationContext = """Title: ${widget.legislation.title}
    Bill Number: ${widget.legislation.number}
    Summary: ${widget.legislation.summary}
    Answer questions about this legislation based on the above given info.""";

    // [FULL TEXT START]
    // $fullText
    // [FULL TEXT END]
    return Character.createMessage(character, legislationContext);
  }
}
