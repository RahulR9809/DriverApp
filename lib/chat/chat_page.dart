

// import 'package:flutter/material.dart';

// class ChatPage extends StatefulWidget {
//   const ChatPage({super.key});

//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> with SingleTickerProviderStateMixin {
//   final TextEditingController _messageController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   late AnimationController _sendButtonController;

//   List<String> messages = ["Hi, How can I help you?", "I need a ride to the airport!"];
//   final List<String> timestamps = ["10:00 AM", "10:05 AM"];
//   List<String> statuses = ["sent", "sent"]; // Message status: 'sending' or 'sent'

//   @override
//   void initState() {
//     super.initState();
//     _sendButtonController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 200),
//       lowerBound: 1.0,
//       upperBound: 1.2,
//     );
//   }

//   @override
//   void dispose() {
//     _messageController.dispose();
//     _scrollController.dispose();
//     _sendButtonController.dispose();
//     super.dispose();
//   }

//   void _sendMessage() {
//     final message = _messageController.text.trim();
//     if (message.isNotEmpty) {
//       final currentTime = TimeOfDay.now().format(context);
//       setState(() {
//         messages.add("You: $message");
//         timestamps.add(currentTime);
//         statuses.add("sending"); // Initially set status to 'sending'
//         _messageController.clear();
//       });

//       Future.delayed(const Duration(milliseconds: 100), () {
//         _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
//       });

//       // Simulate message delivery after 2 seconds
//       Future.delayed(const Duration(seconds: 2), () {
//         setState(() {
//           statuses[messages.length - 1] = "sent"; // Update the last message status
//         });
//       });

//       _sendButtonController.reverse(); // Reset animation
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Driver Chat',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.deepPurpleAccent,
//         centerTitle: true,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               controller: _scrollController,
//               padding: const EdgeInsets.all(10),
//               itemCount: messages.length,
//               itemBuilder: (context, index) {
//                 final isUserMessage = messages[index].startsWith("You:");
//                 return Column(
//                   crossAxisAlignment: isUserMessage
//                       ? CrossAxisAlignment.end
//                       : CrossAxisAlignment.start,
//                   children: [
//                     if (index == 0 || index % 3 == 0)
//                       Center(
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 8),
//                           child: Text(
//                             "Today",
//                             style: TextStyle(color: Colors.grey[600], fontSize: 12),
//                           ),
//                         ),
//                       ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 4),
//                       child: CustomPaint(
//                         painter: ChatBubblePainter(isUserMessage: isUserMessage),
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 12, horizontal: 16),
//                           constraints: BoxConstraints(
//                               maxWidth: MediaQuery.of(context).size.width * 0.7),
//                           decoration: BoxDecoration(
//                             color: isUserMessage
//                                 ? Colors.deepPurpleAccent
//                                 : Colors.grey[300],
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Text(
//                             messages[index].replaceFirst("You: ", ""),
//                             style: TextStyle(
//                               color: isUserMessage ? Colors.white : Colors.black87,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(right: 12, left: 12),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Text(
//                             timestamps[index],
//                             style: TextStyle(color: Colors.grey[500], fontSize: 10),
//                           ),
//                           const SizedBox(width: 4),
//                           Icon(
//                             statuses[index] == "sending"
//                                 ? Icons.access_time // Timer icon
//                                 : Icons.check, // Checkmark icon
//                             size: 14,
//                             color: isUserMessage
//                                 ? Colors.deepPurpleAccent
//                                 : Colors.grey[500],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//           _buildMessageInput(),
//         ],
//       ),
//     );
//   }

//   Widget _buildMessageInput() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 4,
//             offset: const Offset(0, -2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: _messageController,
//               decoration: InputDecoration(
//                 hintText: "Type a message...",
//                 contentPadding: const EdgeInsets.symmetric(
//                     horizontal: 16, vertical: 14),
//                 filled: true,
//                 fillColor: Colors.grey[100],
//                 suffixIcon: _messageController.text.isNotEmpty
//                     ? IconButton(
//                         onPressed: () => _messageController.clear(),
//                         icon: const Icon(Icons.close, color: Colors.grey),
//                       )
//                     : null,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(30),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//               onChanged: (_) => setState(() {}),
//             ),
//           ),
//           const SizedBox(width: 8),
//           ScaleTransition(
//             scale: _sendButtonController,
//             child: GestureDetector(
//               onTapDown: (_) => _sendButtonController.forward(),
//               onTapUp: (_) => _sendMessage(),
//               child: Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: const BoxDecoration(
//                   shape: BoxShape.circle,
//                   gradient: LinearGradient(
//                     colors: [Colors.deepPurple, Colors.deepPurpleAccent],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                 ),
//                 child: const Icon(Icons.send, color: Colors.white),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ChatBubblePainter extends CustomPainter {
//   final bool isUserMessage;

//   ChatBubblePainter({required this.isUserMessage});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = isUserMessage ? Colors.deepPurpleAccent : Colors.grey[300]!;

//     final path = Path();
//     const double tailSize = 10.0;

//     if (isUserMessage) {
//       path.moveTo(size.width, size.height);
//       path.lineTo(size.width, size.height - tailSize);
//       path.lineTo(size.width - tailSize, size.height);
//     } else {
//       path.moveTo(0, size.height);
//       path.lineTo(0, size.height - tailSize);
//       path.lineTo(tailSize, size.height);
//     }

//     path.close();
//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => false;
// }














// import 'package:employerapp/chat/bloc/chat_bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class Message {
//   final String text;
//   final bool isSender;

//   Message({required this.text, required this.isSender});
// }

// class ChatPage extends StatefulWidget {
//   const ChatPage({Key? key}) : super(key: key);

//   @override
//   _ChatPageState createState() => _ChatPageState();
// }
// class _ChatPageState extends State<ChatPage> {
//   late ChatBloc _chatBloc;
//   final TextEditingController _messageController = TextEditingController();
//   final ScrollController _scrollController = ScrollController(); // ✅ Scroll controller

//   @override
//   void initState() {
//     super.initState();
//     // _chatBloc = BlocProvider.of<ChatBloc>(context);
//     _initializeChat();
//   }

//   Future<void> _initializeChat() async {
//     // final prefs = await SharedPreferences.getInstance();
//     // final driverId = prefs.getString('login_id') ?? '';
//     // _chatBloc.add(ChatSocketConnectedevent(driverId: driverId));
//     _chatBloc.add(LoadMessages());
//   }

//   @override
//   void dispose() {
//     _messageController.dispose();
//     _scrollController.dispose(); // ✅ Dispose the scroll controller
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Chat'),
//         centerTitle: true,
//       ),
//       body: BlocBuilder<ChatBloc, ChatState>(
//         builder: (context, state) {
//           if (state is ChatLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (state is ChatMessagesLoaded) {
//             return _buildChatList(state.messages);
//           }

//           if (state is ChatError) {
//             return Center(
//               child: Text(
//                 state.message,
//                 style: const TextStyle(color: Colors.red),
//               ),
//             );
//           }

//           return const Center(child: Text('No messages yet.'));
//         },
//       ),
//     );
//   }

//   // ✅ Updated chat list to scroll to the bottom when new messages arrive
//   Widget _buildChatList(List<Message> messages) {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (_scrollController.hasClients) {
//         _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
//       }
//     });

//     return Column(
//       children: [
//         Expanded(
//           child: ListView.builder(
//             controller: _scrollController,
//             itemCount: messages.length,
//             itemBuilder: (context, index) {
//               return _buildChatBubble(
//                  message: messages[index].text,
//                 isSender: messages[index].isSender,
//               );
//             },
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   controller: _messageController,
//                   decoration: const InputDecoration(
//                     hintText: 'Type a message...',
//                     border: OutlineInputBorder(),
//                     filled: true,
//                   ),
//                 ),
//               ),
//               IconButton(
//                 icon: const Icon(Icons.send),
//                 onPressed: () {
//                   final message = _messageController.text.trim();
//                   if (message.isNotEmpty) {
//                     _chatBloc.add(SendMessage(message: message));
//                     _messageController.clear();
//                     WidgetsBinding.instance.addPostFrameCallback((_) {
//                       if (_scrollController.hasClients) {
//                         _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
//                       }
//                     });
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('Message cannot be empty'),
//                       ),
//                     );
//                   }
//                 },
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildChatBubble({required String message, required bool isSender}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
//       child: Row(
//         mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: isSender ? Colors.deepPurpleAccent : Colors.grey[300],
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Text(
//               message,
//               style: TextStyle(
//                 color: isSender ? Colors.white : Colors.black,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



import 'package:employerapp/chat/bloc/chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late ChatBloc _chatBloc;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = []; // Local message cache

  @override
  void initState() {
    super.initState();
    _chatBloc = BlocProvider.of<ChatBloc>(context);
    _initializeChat();
    print("ChatPage: initState called");
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
    print("ChatPage: dispose called");
  }

  Future<void> _initializeChat() async {
    _chatBloc.add(LoadMessages());
    print("ChatPage: _initializeChat called - Loading messages");
  }

  @override
  Widget build(BuildContext context) {
    print("ChatPage: build called");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocListener<ChatBloc, ChatState>(
              listener: (context, state) {
                if (state is ChatReceivedMessagesUpdated) {
                  print("ChatPage: New message received");
                  _updateMessages(state.messages);
                }
                if (state is ChatSentMessagesUpdated) {
                  print("ChatPage: New message sent");
                  _updateMessages(state.messages);
                }
              },
              child: _buildChatList(),
            ),
          ),
          _buildMessageInputField(),
        ],
      ),
    );
  }

  void _updateMessages(List<Map<String, dynamic>> newMessages) {
    setState(() {
      _messages.clear();
      _messages.addAll(newMessages);
    });
    _scrollToBottom();
  }

  Widget _buildChatList() {
    print("ChatPage: _buildChatList called, message count = ${_messages.length}");
    return ListView.builder(
      controller: _scrollController,
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        print("ChatPage: _buildChatBubble called, message = ${_messages[index]['message']}");
        return _buildChatBubble(
          message: _messages[index]['message'],
          isSender: _messages[index]['isSender'],
        );
      },
    );
  }

  Widget _buildMessageInputField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(),
                filled: true,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              final message = _messageController.text.trim();
              print("ChatPage: Send button pressed, message = $message");
              if (message.isNotEmpty) {
                _chatBloc.add(SendMessage(message: message));
                _messageController.clear();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Message cannot be empty')),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble({required String message, required bool isSender}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Row(
        mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSender ? Colors.deepPurpleAccent : Colors.grey[300],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              message,
              style: TextStyle(
                color: isSender ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _scrollToBottom() {
    print("ChatPage: _scrollToBottom called");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
        print("ChatPage: Scrolling to bottom completed");
      }
    });
  }
}
