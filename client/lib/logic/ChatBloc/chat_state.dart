part of 'chat_bloc.dart';

@immutable
abstract class ChatState {}

class ChatInitial extends ChatState {}

class ServerDeliveredMessageSuccess extends ChatState {
  final List<ChatCordMessageModel> message;

  ServerDeliveredMessageSuccess({@required this.message});
}
