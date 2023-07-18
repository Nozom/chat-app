import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JoinScreen extends StatelessWidget {
  JoinScreen({super.key});

  final TextEditingController _email = TextEditingController();
  final TextEditingController _to = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            keyboardType: TextInputType.emailAddress,
            controller: _email,
            decoration: const InputDecoration(hintText: 'Enter Email'),
          ),
          TextField(
            keyboardType: TextInputType.emailAddress,
            controller: _to,
            decoration: const InputDecoration(hintText: 'Enter to'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_email.text.isEmpty || _to.text.isEmpty) return;
              Get.toNamed('/chat', arguments: {
                'email': _email.text.trim(),
                'to': _to.text.trim(),
              });
            },
            child: const Text('Join'),
          )
        ],
      ),
    );
  }
}
