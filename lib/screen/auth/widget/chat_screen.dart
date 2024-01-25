import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/profile_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ProfileController profileController = Get.put(ProfileController());
  final TextEditingController _messageController = TextEditingController();
  String username = '';
  
  List<Map<String, dynamic>> messages = [];
  var url = Uri.parse("https://tanya-chat-production.up.railway.app/api/messages");
  String searchTerm = '';

  @override
  void initState() {
    super.initState();
    fetchMessages();
    Timer.periodic(Duration(seconds: 5), (timer) {
      fetchMessages();
    });
  }

  List<Map<String, dynamic>> filteredContacts = [];

  Future<void> fetchMessages() async {
  try {
    final response = await http.get(
      url
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      for (var message in data) {
        print('Message Content: ${message['content']}');
      }

      setState(() {
        messages = List<Map<String, dynamic>>.from(data);
      });
    } else {
      print('Error fetching messages: ${response.statusCode}');
    }
  } catch (error) {
    print('Error fetching messages: $error');
  }
}


  Future<void> sendMessage() async {
    try {
      if (_messageController.text.isEmpty) {
        return;
      }
      
      final response = await http.post(
        url,
        body: json.encode({
          'sender': profileController.username.value,
          'content': _messageController.text,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('Message sent: ${response.body}');
        _messageController.clear();
        fetchMessages();
      } else {
        print('Error sending message: ${response.statusCode}');
      }
    } catch (error) {
      print('Error sending message: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat App'),
      ),
      body: Row(
        children: [
          // Main Chat Area
          Expanded(
            child: Column(
              children: [
                // Chat Header
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
                    
                    color: Color.fromARGB(255, 255, 254, 254),
                  ),
                  child: Row(
                    children: [
                      Text(
                        profileController.username.value,
                        style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                // Chat Messages
                Expanded(
                  child: ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> message = messages[index];
                      bool isMyMessage = message['sender'] == profileController.username.value;

                      return Align(
                        alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.all(8.0),
                          padding: EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: isMyMessage ? Colors.blue : Colors.green,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Text(
                            message['content'] ?? '', // Use the message content
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Chat Input
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.grey[300]!)),
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.0),
                      ElevatedButton(
                        onPressed: sendMessage,
                        child: Text('Send'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
