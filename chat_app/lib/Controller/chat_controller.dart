import 'dart:async';

import 'package:chat_app/Model/message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class ChatController extends GetxController {
  final GlobalKey<AnimatedListState> key = GlobalKey<AnimatedListState>();
  List<Message> messages = [];
  final TextEditingController controller = TextEditingController();
  final ScrollController listController = ScrollController();
  final String email = Get.arguments['email'];
  final String to = Get.arguments['to'];
  final io.Socket _socket = io.io('http://172.16.16.100:4000', {
    'autoConnect': false,
    'transports': ['websocket'],
  });

  bool _isSend = false;
  bool get isSend => _isSend;

  bool _isTyping = false;
  bool get isTyping => _isTyping;

  bool _isOnline = false;
  bool get isOnline => _isOnline;

  DateTime? _lastSeen;
  DateTime? get lastSeen => _lastSeen;

  Timer? _timer;

  @override
  void onInit() {
    _socket.connect();
    _socket.emit('connected', email);
    _socket.emit('message-read', to);
    _socket.on('message', (data) {
      final Message message = Message.fromJson(data);
      key.currentState?.insertItem(
        messages.length,
        duration: const Duration(milliseconds: 200),
      );
      messages.add(message);
      Future.delayed(const Duration(milliseconds: 100), () {
        listController.animateTo(
          listController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
      });
      _socket.emit('message-read', to);
      update();
    });
    _socket.on('typing', (_) {
      _isTyping = true;
      update();
    });
    _socket.on('stop-typing', (_) {
      _isTyping = false;
      update();
    });
    _socket.on('user-connected', (data) {
      if (data != to) return;
      _isOnline = true;
      update();
    });
    _socket.on('user-disconnected', (data) {
      if (data != to) return;
      _isOnline = false;
      _lastSeen = DateTime.now();
      update();
    });
    _socket.on('message-read', (_) {
      messages
          .where((message) => message.from == email && !message.isRead)
          .forEach(
            (message) => messages[messages.indexOf(message)] =
                message.copyWith(isRead: true),
          );
      print(messages.last.isRead);
      update();
    });
    super.onInit();
  }

  @override
  void onClose() {
    _socket.emit('offline', email);
    _socket.disconnect();
    _socket.dispose();
    _timer?.cancel();
    super.onClose();
  }

  void onTextChanged(String s) {
    if (s.trim().isNotEmpty) {
      _isSend = true;
    } else {
      _isSend = false;
    }

    if (_timer != null) _timer?.cancel();
    if (s.isNotEmpty) {
      _socket.emit('typing', to);
      _timer = Timer(
        const Duration(milliseconds: 500),
        () => _socket.emit('stop-typing', to),
      );
    } else {
      _timer?.cancel();
      _timer = null;
      _socket.emit('stop-typing', to);
    }

    update();
  }

  void send() {
    if (controller.text.trim().isNotEmpty) {
      key.currentState?.insertItem(
        messages.length,
        duration: const Duration(milliseconds: 200),
      );
      final Message message = Message(
        from: email,
        to: to,
        text: controller.text.trim(),
        date: DateTime.now(),
      );
      messages.add(message);
      controller.clear();
      Future.delayed(const Duration(milliseconds: 100), () {
        listController.animateTo(
          listController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
      });
      _isSend = false;
      _socket.emit('message', message.toJson());
      onEditingComplete();
      update();
    }
  }

  void onEditingComplete() {
    _socket.emit('stop-typing', to);
    _timer?.cancel();
  }
}
