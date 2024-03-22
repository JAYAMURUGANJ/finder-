import 'package:finder_chatbot/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';

import '../constant.dart';
import '../models/message.dart';
import '../widgets/message_card.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isTextFieldEmpty = true;
  final TextEditingController _userInput = TextEditingController();
  static const apiKey = key;

  final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);

  final List<Message> _messages = [];

  bool _isLoading = false;

  Future<void> sendMessage() async {
    final message = _userInput.text;
    _userInput.clear();

    setState(() {
      _messages
          .add(Message(isUser: true, message: message, date: DateTime.now()));
      _isLoading = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });

    final content = [Content.text(message)];
    final response = await model.generateContent(content);

    setState(() {
      _isLoading = false;
      _messages.add(Message(
          isUser: false, message: response.text ?? "", date: DateTime.now()));
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: _messages.isNotEmpty
                ? ListView.builder(
                    controller: _scrollController,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return Messages(
                        isUser: message.isUser,
                        message: message.message,
                        date: DateFormat('HH:mm').format(message.date),
                      );
                    },
                  )
                : const Center(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          "$finder_emoji \nStart a Converstaion here...",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
          ),
          _isLoading
              ? const Center(
                  child: SizedBox(
                  child: SpinKitThreeBounce(
                    color: Colors.white,
                    size: 20.0,
                  ),
                ))
              : const SizedBox(),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 15,
                    child: TextFormField(
                      style: const TextStyle(color: Colors.white),
                      controller: _userInput,
                      onChanged: (text) {
                        setState(() {
                          _isTextFieldEmpty = text.trim().isEmpty;
                        });
                      },
                      // onTap: () {
                      //   WidgetsBinding.instance.addPostFrameCallback((_) {
                      //     _scrollController.animateTo(
                      //       _scrollController.position.maxScrollExtent - 1,
                      //       duration: const Duration(milliseconds: 300),
                      //       curve: Curves.easeOut,
                      //     );
                      //   });
                      // },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          label: const Text('Search Here...')),
                    ),
                  ),
                  Visibility(
                      visible: !_isTextFieldEmpty, child: const Spacer()),
                  Visibility(
                    visible: !_isTextFieldEmpty,
                    child: IconButton(
                        padding: const EdgeInsets.all(12),
                        iconSize: 30,
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.black),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white),
                            shape: MaterialStateProperty.all(
                                const CircleBorder())),
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          setState(() {
                            _isTextFieldEmpty = true;
                          });
                          sendMessage();
                        },
                        icon: const Icon(Icons.send)),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
