import 'package:flutter/material.dart';

class OtherBubble extends StatelessWidget {
  final String message;
  final TimeOfDay time;
  final bool hasTail;
  const OtherBubble({
    super.key,
    required this.message,
    required this.time,
    this.hasTail = true,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipPath(
            clipper: hasTail ? _OtherBubbleClipper() : null,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
                minWidth: MediaQuery.of(context).size.width * 0.2,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: hasTail
                    ? const BorderRadiusDirectional.only(
                        topStart: Radius.circular(8),
                        bottomStart: Radius.circular(8),
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
                padding: const EdgeInsetsDirectional.only(end: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message,
                    ),
                    Text(
                      time.format(context),
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: hasTail,
            maintainAnimation: true,
            maintainSize: true,
            maintainState: true,
            child: const CircleAvatar(
              backgroundColor: Colors.blueGrey,
              backgroundImage: AssetImage('assets/images/user.png'),
            ),
          ),
        ],
      ),
    );
  }
}

class _OtherBubbleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    final double w = size.width;
    final double h = size.height;
    path.lineTo(w, 0);
    path.lineTo(w - 20, 30);
    path.lineTo(w - 20, h);
    path.lineTo(0, h);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
