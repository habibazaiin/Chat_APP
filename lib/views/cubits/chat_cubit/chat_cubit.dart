import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:myapp/constants.dart';
import 'package:myapp/models/message.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());
  List<Message> messageList = [];

  CollectionReference messages = FirebaseFirestore.instance.collection(
    kMessagesCollection,
  );

  void sendMessage({required String message, required String email}) {
    try {
      messages.add({
        kMessage: message,
        kCreatedAt: DateTime.now(),
        'id': email ?? "unknown",
      });
    } on Exception catch (e) {
      // TODO
    }
  }

 void getMessage() {
  messages.orderBy(kCreatedAt).snapshots().listen((snapshot) {
    messageList = [];
    for (var doc in snapshot.docs) {
      messageList.add(Message.fromJson(doc.data() as Map<String, dynamic>));
    }
    messageList = messageList.reversed.toList();
    emit(ChatSuccess(messages: messageList));
  });
}

}
