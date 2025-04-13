import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'dart:ui';
import '../services/chatgpt_service.dart';

class ChatScreenWithGpt extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreenWithGpt> {
  final List<types.Message> _messages = [];
  final types.User _user = types.User(id: '1');
  final types.User _bot = types.User(id: '2');
  final ChatGPTService _chatGPTService = ChatGPTService();
  final TextEditingController _messageController = TextEditingController();

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final userMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: DateTime.now().toString(),
      text: text,
    );

    setState(() {
      _messages.insert(0, userMessage);
    });

    _chatGPTService.getChatResponse(text).then((botReply) {
      final botMessage = types.TextMessage(
        author: _bot,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: DateTime.now().toString(),
        text: botReply,
      );

      setState(() {
        _messages.insert(0, botMessage);
      });
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Chat AI",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueGrey[900]!, Colors.black87],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: Chat(
                  messages: _messages,
                  onSendPressed: (message) {
                    _sendMessage(message.text);
                  },
                  user: _user,
                  theme: DefaultChatTheme(
                    backgroundColor: Colors.transparent,
                    inputBackgroundColor: Colors.black.withOpacity(0.1),
                    inputTextColor: Colors.white,
                    primaryColor: Colors.blueAccent.withOpacity(0.5), // For sent messages
                    secondaryColor: Colors.grey.withOpacity(0.5),    // For received messages
                    sentMessageBodyTextStyle: TextStyle(color: Colors.white, fontSize: 16),
                    receivedMessageBodyTextStyle: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _messageController,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: "اكتب رسالتك...",
                                  hintStyle: TextStyle(color: Colors.white60),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.send, color: Colors.white),
                              onPressed: () => _sendMessage(_messageController.text),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}