import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  List<String> messages = [];
  ChatBloc() : super(ChatInitial());

  @override
  Stream<ChatState> mapEventToState(
    ChatEvent event,
  ) async* {
    if (event is OnServerDeliveredMessage) {
      messages.add(event.message);
      yield ServerDeliveredMessageSuccess(message: messages);
    } else if (event is ClearChatOnClientDisconnect) {
      messages.clear();
    } else if (event is UserSendMessage) {
      messages.add(event.userMessage);
      yield ServerDeliveredMessageSuccess(message: messages);
    }
  }
}
