import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final bool isOnline;
  const ProfileAvatar({
    super.key,
    this.isOnline = false,
  });

  final double _radius = 8;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        const CircleAvatar(
          backgroundColor: Colors.blueGrey,
          backgroundImage: AssetImage('assets/images/user.png'),
        ),
        Positioned.directional(
          textDirection: Directionality.of(context),
          bottom: -2,
          end: -2,
          child: CircleAvatar(
            radius: isOnline ? _radius : 0,
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            child: CircleAvatar(
              radius: _radius - 2,
              backgroundColor: Colors.greenAccent,
            ),
          ),
        ),
      ],
    );
  }
}
