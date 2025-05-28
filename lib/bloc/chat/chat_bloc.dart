import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repository/chat_repository.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;

  ChatBloc({required this.chatRepository}) : super(ChatInitial()) {
    on<LoadMessages>((event, emit) async {
      emit(ChatLoading());
      try {
        await emit.forEach(
          chatRepository.getMessages(event.senderId, event.receiverId),
          onData: (messages) => ChatLoaded(messages),
        );
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });

    on<SendMessage>((event, emit) async {
      await chatRepository.sendMessage(event.message);
    });
  }
}
