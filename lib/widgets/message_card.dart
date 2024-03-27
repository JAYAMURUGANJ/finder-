import 'package:flutter/material.dart';

import '../constant.dart';

class Messages extends StatelessWidget {
  final bool isUser;
  final String message;
  final String date;

  const Messages(
      {super.key,
      required this.isUser,
      required this.message,
      required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 15)
          .copyWith(left: isUser ? 100 : 10, right: isUser ? 10 : 100),
      decoration: BoxDecoration(
          color: isUser
              ? const Color.fromARGB(255, 99, 179, 233)
              : Colors.grey.shade400,
          borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(10),
              bottomLeft: isUser ? const Radius.circular(10) : Radius.zero,
              topRight: const Radius.circular(10),
              bottomRight: isUser ? Radius.zero : const Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            !isUser ? finder_emoji : "You",
            style: TextStyle(
                fontSize: 14, color: !isUser ? Colors.white : Colors.black),
          ),
          Text(
            message,
            style: TextStyle(
                fontSize: 16, color: isUser ? Colors.white : Colors.black),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              date,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 12,
                color: isUser ? Colors.white : Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }
}
