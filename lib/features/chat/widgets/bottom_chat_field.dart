import 'package:flutter/material.dart';

import '../../../colors.dart';

class BottomChatField extends StatelessWidget {
  const BottomChatField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //to take max available space for TextField
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              filled: true,
              fillColor: mobileChatBoxColor,
              prefixIcon: const Padding(
                padding: EdgeInsets.symmetric(horizontal:20.0),
                child: SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      Icon(
                        Icons.emoji_emotions,
                        color: Colors.grey,
                      ),
                      Icon(
                        Icons.gif,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
              suffixIcon: const SizedBox(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.camera_alt,
                      color: Colors.grey,
                    ),
                    Icon(
                      Icons.attach_file,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
              hintText: 'Type a message!',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              contentPadding: const EdgeInsets.all(10),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 8, right: 2, left: 2),
          child: CircleAvatar(
            backgroundColor: Color(0xff128C7E),
            radius: 25,
            child: Icon(
              Icons.mic,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }
}
