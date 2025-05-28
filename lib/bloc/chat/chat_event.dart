import 'package:crm_application/data/model/message_model.dart';

abstract class ChatEvent {}

class LoadMessages extends ChatEvent {
  final String senderId;
  final String receiverId;
  LoadMessages(this.senderId, this.receiverId);
}

class SendMessage extends ChatEvent {
  final MessageModel message;
  SendMessage(this.message);
}
