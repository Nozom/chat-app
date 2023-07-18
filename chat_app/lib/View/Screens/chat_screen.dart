import 'package:chat_app/Controller/chat_controller.dart';
import 'package:chat_app/View/Widgets/other_bubble.dart';
import 'package:chat_app/View/Widgets/user_bubble.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Widgets/profile_avatar.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatController controller = Get.put(ChatController());
    return GetBuilder(
        init: controller,
        builder: (controller2) {
          return Scaffold(
            appBar: AppBar(
              foregroundColor: Colors.indigo,
              title: ListTile(
                leading: ProfileAvatar(
                  isOnline: controller2.isOnline,
                ),
                title: Text(controller2.to),
                subtitle: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: controller2.isTyping
                      ? const Align(
                          key: ValueKey<bool>(true),
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            'Typing...',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                        )
                      : controller2.isOnline
                          ? const Align(
                              key: ValueKey<bool>(false),
                              alignment: AlignmentDirectional.centerStart,
                              child: Text(
                                'Online',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                            )
                          : Align(
                              key: const ValueKey<bool>(false),
                              alignment: AlignmentDirectional.centerStart,
                              child: Text(
                                controller2.lastSeen != null
                                    ? 'Last seen at ${TimeOfDay.fromDateTime(
                                        controller2.lastSeen!,
                                      ).format(context)}'
                                    : 'Offline',
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.call),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.videocam),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.menu),
                ),
              ],
            ),
            body: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/wallpaper.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: AnimatedList(
                      key: controller.key,
                      initialItemCount: controller.messages.length,
                      controller: controller.listController,
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index, animation) {
                        return ScaleTransition(
                          scale: animation,
                          child: FadeTransition(
                            opacity: animation,
                            child: controller.messages[index].from ==
                                    controller.email
                                ? UserBubble(
                                    message: controller.messages[index].text,
                                    time: TimeOfDay(
                                      hour:
                                          controller.messages[index].date.hour,
                                      minute: controller
                                          .messages[index].date.minute,
                                    ),
                                    hasTail: index == 0 ||
                                        (controller.messages[index].from ==
                                                controller.email &&
                                            controller
                                                    .messages[index - 1].from !=
                                                controller.email),
                                    isRead: controller2.messages[index].isRead,
                                  )
                                : OtherBubble(
                                    message: controller.messages[index].text,
                                    time: TimeOfDay(
                                      hour:
                                          controller.messages[index].date.hour,
                                      minute: controller
                                          .messages[index].date.minute,
                                    ),
                                    hasTail: index == 0 ||
                                        (controller.messages[index].from !=
                                                controller.email &&
                                            controller
                                                    .messages[index - 1].from ==
                                                controller.email),
                                  ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller.controller,
                            onChanged: controller.onTextChanged,
                            onEditingComplete: controller.onEditingComplete,
                            minLines: 1,
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText: 'Type Something.....',
                              prefixIcon: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.emoji_emotions_outlined),
                              ),
                              suffixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.image_outlined,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Transform.rotate(
                                      angle: 0.6,
                                      child: const Icon(
                                        Icons.attach_file_outlined,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: controller.send,
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            // padding: const EdgeInsets.all(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Icon(
                              controller2.isSend ? Icons.send : Icons.mic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ), // This trailing comma makes auto-formatting nicer for build methods.
          );
        });
  }
}