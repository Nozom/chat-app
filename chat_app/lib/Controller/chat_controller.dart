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
  Timer? _collapseTimer;

  bool _showButton = false;
  bool get showButton => _showButton;

  bool _isHeaderCollapsed = false;
  bool get isHeaderCollapsed => _isHeaderCollapsed;

  int _newMessages = 0;
  int get newMessages => _newMessages;

  Message? _reply;
  Message? get reply => _reply;

  bool onNotification(Notification notification) {
    if (notification is ScrollUpdateNotification) {
      _collapseTimer?.cancel();
      _isHeaderCollapsed = false;
      update();
    } else if (notification is ScrollEndNotification) {
      _collapseTimer = Timer(const Duration(seconds: 2), () {
        _isHeaderCollapsed = true;
        update();
      });
    }
    return true;
  }

  @override
  void onInit() {
    listController.addListener(() {
      if (listController.position.pixels <
          listController.position.maxScrollExtent - 200) {
        if (!_showButton) {
          _showButton = true;
          update();
        }
      } else {
        if (_showButton) {
          _newMessages = 0;
          _showButton = false;
          update();
        }
      }
    });
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
      if (listController.position.pixels >
          listController.position.maxScrollExtent - 200) {
        Future.delayed(const Duration(milliseconds: 100), scrollDown);
      } else {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (_newMessages == 0) {
            listController.animateTo(
              listController.position.pixels + 100,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
            );
          }
          _newMessages++;
          update();
        });
      }
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
    _collapseTimer?.cancel();
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
      closeReply();
      Future.delayed(const Duration(milliseconds: 100), scrollDown);

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

  void scrollDown() {
    listController.animateTo(
      listController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  void onSwipe(Message message) {
    _reply = message;
    update();
  }

  void closeReply() {
    _reply = null;
    update();
  }
}
