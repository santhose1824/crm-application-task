import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/message_model.dart';

class ChatRepository {
  final _firestore = FirebaseFirestore.instance;

  Stream<List<MessageModel>> getMessages(String senderId, String receiverId) {
    return _firestore
        .collection('chats')
        .doc(_getChatId(senderId, receiverId))
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => MessageModel.fromMap(doc.id, doc.data()))
        .toList());
  }

  Future<void> sendMessage(MessageModel message) async {
    final chatId = _getChatId(message.senderId, message.receiverId);
    await _firestore.collection('chats').doc(chatId).collection('messages').add(message.toMap());
  }

  String _getChatId(String senderId, String receiverId) {
    return senderId.hashCode <= receiverId.hashCode
        ? '$senderId\_$receiverId'
        : '$receiverId\_$senderId';
  }
}
