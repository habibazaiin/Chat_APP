import 'package:myapp/constants.dart';

class Message {
  final String message;
  final String id;

  Message({required this.id, required this.message});

  factory Message.fromJson(Map<String, dynamic> jsonData) {
    return Message(id: jsonData['id'], message: jsonData[kMessage] ?? '');
  }
}
