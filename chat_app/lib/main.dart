import 'package:chat_app/Routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey.shade300,
      ),
      initialRoute: '/join',
      getPages: Routes.pages,
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({
//     super.key,
//   });

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final GlobalKey<AnimatedListState> _key = GlobalKey<AnimatedListState>();
//   final List<Map<String, dynamic>> _messages = [
//     {
//       "text": '_controller.text.trim()',
//       "date": TimeOfDay.now(),
//       "isMe": false,
//     },
//     {
//       "text": '_controller.text.trim()',
//       "date": TimeOfDay.now(),
//       "isMe": false,
//     },
//   ];
//   final TextEditingController _controller = TextEditingController();
//   final ScrollController _listController = ScrollController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Chat'),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Expanded(
//             child: AnimatedList(
//               key: _key,
//               initialItemCount: _messages.length,
//               controller: _listController,
//               itemBuilder: (context, index, animation) {
//                 return ScaleTransition(
//                   scale: animation,
//                   child: FadeTransition(
//                     opacity: animation,
//                     child: _messages[index]['isMe']
//                         ? UserBubble(
//                             message: _messages[index]['text'],
//                             time: _messages[index]['date'],
//                             hasTail: index == 0 ||
//                                 (_messages[index]['isMe'] &&
//                                     !_messages[index - 1]['isMe']),
//                           )
//                         : OtherBubble(
//                             message: _messages[index]['text'],
//                             time: _messages[index]['date'],
//                             hasTail: index == 0 ||
//                                 (_messages[index]['isMe'] &&
//                                     !_messages[index - 1]['isMe']),
//                           ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     onChanged: (_) {
//                       setState(() {});
//                     },
//                     minLines: 1,
//                     maxLines: 3,
//                     decoration: InputDecoration(
//                       hintText: 'Type Something.....',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(25),
//                         borderSide: BorderSide.none,
//                       ),
//                       filled: true,
//                       fillColor: Colors.white,
//                     ),
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     if (_controller.text.trim().isNotEmpty) {
//                       setState(() {
//                         _key.currentState?.insertItem(
//                           _messages.length,
//                           duration: const Duration(milliseconds: 200),
//                         );
//                         _messages.add({
//                           "text": _controller.text.trim(),
//                           "date": TimeOfDay.now(),
//                           "isMe": true,
//                         });
//                         _controller.clear();
//                       });
//                       Future.delayed(const Duration(milliseconds: 100), () {
//                         _listController.animateTo(
//                           _listController.position.maxScrollExtent,
//                           duration: const Duration(milliseconds: 500),
//                           curve: Curves.easeInOut,
//                         );
//                       });
//                     }
//                   },
//                   style: ElevatedButton.styleFrom(
//                     shape: const CircleBorder(),
//                     // padding: const EdgeInsets.all(12),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Icon(
//                       _controller.text.trim().isNotEmpty
//                           ? Icons.send
//                           : Icons.mic,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
