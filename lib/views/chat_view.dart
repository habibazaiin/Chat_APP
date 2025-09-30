import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/constants.dart';
import 'package:myapp/models/message.dart';
import 'package:myapp/views/cubits/chat_cubit/chat_cubit.dart';
import 'package:myapp/widgets/chat_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class ChatView extends StatelessWidget {
  ChatView({super.key});
  static String id = 'ChatPage';

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)!.settings.arguments as String;

    context.read<ChatCubit>().getMessage();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackGroundColor,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(kLogo, height: 50, width: 50),
            Text('ChatTalk', style: TextStyle(color: kPrimaryColor)),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                if (state is ChatSuccess) {
                  return ListView.builder(
                    reverse: true,
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      return state.messages[index].id == email
                          ? ChatBubble(message: state.messages[index].message)
                          : ChatBubbleForFriend(
                              message: state.messages[index].message,
                            );
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: controller,
              onSubmitted: (value) {
                context.read<ChatCubit>().sendMessage(
                      message: value,
                      email: email,
                    );
                controller.clear();
              },
              decoration: InputDecoration(
                suffixIcon: const Icon(Icons.send),
                hintText: 'Send Message',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: kPrimaryColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
