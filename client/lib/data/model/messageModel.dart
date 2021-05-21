import 'package:flutter/foundation.dart';

enum MessageType { USER, SERVER }

class ChatCordMessageModel {
  final String content; // the content of the message
  final MessageType
      messageType; //the container of the message will change it's color depends on the the type of the message
  final String messageFrom; // the owner of the message name
  final String messageTo;

  ChatCordMessageModel(
      {@required this.content,
      @required this.messageType,
      @required this.messageFrom,
      @required this.messageTo}); // destination of the message heding to
}
