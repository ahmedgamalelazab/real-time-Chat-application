part of 'chat_bloc.dart';

@immutable
abstract class ChatEvent {}

class OnServerDeliveredMessage extends ChatEvent {
  final ChatCordMessageModel message;

  OnServerDeliveredMessage({@required this.message});
}

class ClearChatOnClientDisconnect extends ChatEvent {}

class UserSendMessage extends ChatEvent {
  final ChatCordMessageModel message;

  UserSendMessage({@required this.message});
}
