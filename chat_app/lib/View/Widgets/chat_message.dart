import 'package:chat_app/Model/message.dart';
import 'package:chat_app/View/Widgets/other_bubble.dart';
import 'package:chat_app/View/Widgets/user_bubble.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatefulWidget {
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
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  double _opacity = 1;
  bool _isSelect = false;
  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        setState(() {
          _opacity = 0.75;
        });
      },
      onPointerUp: (_) {
        setState(() {
          _opacity = 1;
        });
      },
      onPointerCancel: (_) {
        setState(() {
          _opacity = 1;
        });
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onLongPress: () {
          setState(() {
            _isSelect = !_isSelect;
            _opacity = 1;
          });
        },
        onTap: () {
          if (_isSelect) {
            setState(() {
              _isSelect = false;
            });
          }
        },
        child: Container(
          color: _isSelect ? Colors.teal.withOpacity(0.5) : null,
          child: AnimatedOpacity(
            opacity: _opacity,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: widget.message.from == widget.from
                ? UserBubble(
                    message: widget.message.text,
                    time: TimeOfDay(
                      hour: widget.message.date.hour,
                      minute: widget.message.date.minute,
                    ),
                    hasTail: widget.index == 0 ||
                        (widget.message.from == widget.from &&
                            widget.previousMessage!.from != widget.from),
                    isRead: widget.message.isRead,
                  )
                : OtherBubble(
                    message: widget.message.text,
                    time: TimeOfDay(
                      hour: widget.message.date.hour,
                      minute: widget.message.date.minute,
                    ),
                    hasTail: widget.index == 0 ||
                        (widget.message.from != widget.from &&
                            widget.previousMessage!.from == widget.from),
                  ),
          ),
        ),
      ),
    );
  }
}
