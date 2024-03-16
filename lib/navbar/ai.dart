import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as type;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:bubble/bubble.dart';

class AIScreen extends StatefulWidget {
  const AIScreen({super.key});

  @override
  State<AIScreen> createState() => _AIScreenState();
}

class _AIScreenState extends State<AIScreen> {
  final List<type.Message> userMsg = [];
  final user = const type.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3ac');

  void addMessage(type.Message message) {
    setState(() {
      userMsg.add(message);
    });
  }

  void setMessage(type.PartialText message) {
    final textMsg = type.TextMessage(
        author: user,
        createdAt: DateTime.now().microsecondsSinceEpoch,
        id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
        text: message.text);

    addMessage(textMsg);
  }

  Widget _bubbleBuilder(
    Widget child, {
    required message,
    required nextMessageInGroup,
  }) =>
      Bubble(
        color: user.id != message.author.id ||
                message.type == type.MessageType.image
            ? const Color.fromARGB(255, 255, 255, 255) // AI message
            : const Color.fromARGB(255, 66, 125, 243), // User message
        margin: nextMessageInGroup
            ? const BubbleEdges.symmetric(horizontal: 6)
            : null,
        nip: nextMessageInGroup
            ? BubbleNip.no
            : user.id != message.author.id
                ? BubbleNip.leftBottom
                : BubbleNip.rightBottom,
        child: child,
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              const Text("AI Assistant",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 21,
                      fontWeight: FontWeight.bold)),
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(16),
                color: Colors.black,
                constraints:
                    const BoxConstraints.expand(height: 557.2, width: 600),
                child: Chat(
                  messages: userMsg,
                  onSendPressed: setMessage,
                  user: user,
                  bubbleBuilder: _bubbleBuilder,
                ),
              ),
            ])));
  }
}
