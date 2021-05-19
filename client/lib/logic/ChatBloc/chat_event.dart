part of 'chat_bloc.dart';

@immutable
abstract class ChatEvent {}

class OnServerDeliveredMessage extends ChatEvent {
  final String message;

  OnServerDeliveredMessage({@required this.message});
}

class ClearChatOnClientDisconnect extends ChatEvent {}

class UserSendMessage extends ChatEvent {
  final String userMessage;

  UserSendMessage({@required this.userMessage});
}
