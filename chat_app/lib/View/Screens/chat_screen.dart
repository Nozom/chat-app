import 'package:chat_app/Controller/chat_controller.dart';
import 'package:chat_app/Model/message.dart';
import 'package:chat_app/View/Widgets/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:swipe_to/swipe_to.dart';

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
                  icon: const Icon(Icons.more_vert),
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
                    child: NotificationListener(
                      onNotification: controller2.onNotification,
                      child: GroupedListView<Message, DateTime>(
                        elements: controller.messages,
                        controller: controller.listController,
                        groupBy: (message) => DateTime(
                          message.date.year,
                          message.date.month,
                          message.date.day,
                        ),
                        floatingHeader: true,
                        useStickyGroupSeparators: true,
                        groupSeparatorBuilder: (date) {
                          final int days = DateTime.now()
                              .difference(
                                  DateTime(date.year, date.month, date.day))
                              .inDays;
                          return Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.all(8),
                              constraints: BoxConstraints(
                                minWidth:
                                    MediaQuery.of(context).size.width * 0.1,
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                days == 0
                                    ? 'Today'
                                    : days == 1
                                        ? 'Yesterday'
                                        : DateTime(
                                                date.year, date.month, date.day)
                                            .toString(),
                                style: const TextStyle(color: Colors.black54),
                              ),
                            ),
                          );
                        },
                        itemBuilder: (context, message) {
                          final int index =
                              controller.messages.indexOf(message);
                          return SwipeTo(
                            onRightSwipe: () {
                              controller.onSwipe(message);
                            },
                            iconColor: Colors.white,
                            child: ChatMessage(
                              message: message,
                              index: index,
                              from: controller.email,
                              previousMessage: index > 0
                                  ? controller.messages[index - 1]
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                    // child: AnimatedList(
                    //   key: controller.key,
                    //   initialItemCount: controller.messages.length,
                    //   controller: controller.listController,
                    //   padding: const EdgeInsets.all(8),
                    //   itemBuilder: (context, index, animation) {
                    //     return ScaleTransition(
                    //       scale: animation,
                    //       child: FadeTransition(
                    //         opacity: animation,
                    //         child: ChatMessage(
                    //           message: controller2.messages[index],
                    //           index: index,
                    //           from: controller.email,
                    //           previousMessage: index > 0
                    //               ? controller.messages[index - 1]
                    //               : null,
                    //         ),
                    //       ),
                    //     );
                    //   },
                    // ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeInOut,
                                padding: const EdgeInsets.all(8),
                                height: controller.reply != null ? 100 : 0,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadiusDirectional.vertical(
                                    top: Radius.circular(15),
                                  ),
                                  color: Colors.white,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  clipBehavior: Clip.none,
                                  decoration: const BoxDecoration(
                                    color: Colors.grey,
                                    // borderRadius:
                                    //     BorderRadius.circular(15),
                                    border: BorderDirectional(
                                      start: BorderSide(
                                        color: Colors.indigo,
                                        width: 6,
                                      ),
                                    ),
                                  ),
                                  child: controller.reply != null
                                      ? SingleChildScrollView(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          child: Stack(
                                            clipBehavior: Clip.none,
                                            alignment:
                                                AlignmentDirectional.topEnd,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  Text(
                                                    controller.reply!.from !=
                                                            controller.email
                                                        ? controller.reply!.from
                                                        : 'You',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.indigo,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  Text(
                                                    controller.reply!.text,
                                                  ),
                                                ],
                                              ),
                                              Positioned.directional(
                                                textDirection:
                                                    Directionality.of(context),
                                                top: -15,
                                                end: -15,
                                                child: IconButton(
                                                  onPressed:
                                                      controller.closeReply,
                                                  icon: const Icon(
                                                    Icons.close,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : const SizedBox(),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:  controller.reply != null
                                      ? const BorderRadius.vertical(
                                          bottom: Radius.circular(25),
                                        )
                                      : BorderRadius.circular(25),
                                ),
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
                                      icon: const Icon(
                                          Icons.emoji_emotions_outlined),
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
                                      borderRadius:BorderRadius.circular(25),
                                      borderSide: BorderSide.none,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                ),
                              ),
                            ],
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
            ),
            floatingActionButton: controller2.showButton
                ? Container(
                    margin: const EdgeInsets.only(bottom: 60),
                    clipBehavior: Clip.none,
                    child: Badge(
                      alignment: AlignmentDirectional.topEnd,
                      isLabelVisible: controller.newMessages > 0,
                      label: Text('${controller.newMessages}'),
                      child: FloatingActionButton(
                        onPressed: controller.scrollDown,
                        mini: true,
                        shape: const CircleBorder(),
                        child: const Icon(
                          Icons.arrow_downward_outlined,
                        ),
                      ),
                    ),
                  )
                : null, // This trailing comma makes auto-formatting nicer for build methods.
          );
        });
  }
}
