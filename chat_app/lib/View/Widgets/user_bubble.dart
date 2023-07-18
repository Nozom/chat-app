import 'package:flutter/material.dart';

class UserBubble extends StatelessWidget {
  final String message;
  final TimeOfDay time;
  final bool hasTail;
  final bool isRead;
  const UserBubble({
    super.key,
    required this.message,
    required this.time,
    this.hasTail = true,
    this.isRead = false,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: ClipPath(
        clipper: hasTail ? _UserBubbleClipper() : null,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
            minWidth: MediaQuery.of(context).size.width * 0.2,
          ),
          decoration: BoxDecoration(
            color: Colors.indigo,
            borderRadius: hasTail
                ? const BorderRadiusDirectional.only(
                    topEnd: Radius.circular(8),
                    bottomEnd: Radius.circular(8),
                  )
                : BorderRadius.circular(8),
          ),
          margin: hasTail
              ? const EdgeInsets.only(
                  left: 8,
                  right: 8,
                  top: 8,
                  bottom: 2,
                )
              : const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
          padding: const EdgeInsets.all(12),
          child: Padding(
            padding: const EdgeInsetsDirectional.only(start: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(
                          scale: animation,
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                      child: !isRead
                          ? const Icon(
                              Icons.check,
                              key: ValueKey('sent'),
                              size: 18,
                              color: Colors.white54,
                            )
                          : const Icon(
                              Icons.check_circle,
                              key: ValueKey('read'),
                              size: 18,
                              color: Colors.pinkAccent,
                            ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      time.format(context),
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UserBubbleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    final double w = size.width;
    final double h = size.height;
    path.lineTo(0, 0);
    path.lineTo(20, 30);
    path.lineTo(20, h);
    path.lineTo(w, h);
    path.lineTo(w, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
