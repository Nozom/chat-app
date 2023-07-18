import 'package:chat_app/Model/message.dart';
import 'package:chat_app/View/Widgets/other_bubble.dart';
import 'package:chat_app/View/Widgets/user_bubble.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final Message message;
  final Message? previousMessage;
  final int index;
  final String from;
  const ChatMessage({
    super.key,
    required this.message,
    required this.index,
    required this.from,
    this.previousMessage,
  });

  @override
  Widget build(BuildContext context) {
    return message.from == from
        ? UserBubble(
            message: message.text,
            time: TimeOfDay(
              hour: message.date.hour,
              minute: message.date.minute,
            ),
            hasTail: index == 0 ||
                (message.from == from && previousMessage!.from != from),
            isRead: message.isRead,
          )
        : OtherBubble(
            message: message.text,
            time: TimeOfDay(
              hour: message.date.hour,
              minute: message.date.minute,
            ),
            hasTail: index == 0 ||
                (message.from != from && previousMessage!.from == from),
          );
  }
}
