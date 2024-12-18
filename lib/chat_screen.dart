import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'chatgpt_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _geminiService = GeminiService();
  final _user = ChatUser(
    id: 'user',
    firstName: 'Bạn',
  );
  final _bot = ChatUser(
    id: 'bot',
    firstName: 'GPT',
    profileImage: 'assets/images/Hải.jpg', 
  );
  final List<ChatMessage> _messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat với GPT'),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
      ),
      body: Container(
        child: DashChat(
          currentUser: _user,
          messages: _messages,
          onSend: (ChatMessage message) {
            _sendMessage(message.text);
            setState(() {
              _messages.add(message);
            });
          },
          messageOptions: const MessageOptions(
            currentUserContainerColor: Colors.blueAccent,
            containerColor: Colors.grey,
          ),
          inputOptions: InputOptions(
            inputDecoration: InputDecoration(
              hintText: 'Nhập tin nhắn...',
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.white.withOpacity(0.8),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(20.0)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(20.0)),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _sendMessage(String message) async {
    try {
      final botResponse = await _geminiService.sendMessage(message);
      setState(() {
        _messages.insert(
          0,
          ChatMessage(user: _bot, createdAt: DateTime.now(), text: botResponse),
        );
      });
    } catch (e) {
      print('Lỗi: $e');
      setState(() {
        _messages.insert(
          0,
          ChatMessage(
            user: _bot,
            createdAt: DateTime.now(),
            text: 'Lỗi: $e',
          ),
        );
      });
    }
  }
}
