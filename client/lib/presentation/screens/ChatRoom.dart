import 'dart:convert';

import 'package:client/config/fonts.dart';
import 'package:client/config/size.dart';
import 'package:client/data/model/messageModel.dart';
import 'package:client/logic/ChatBloc/chat_bloc.dart';
import 'package:client/presentation/screens/homePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatRoom extends StatefulWidget {
  static const String PAGE_ROUTE = "/ChatRoom";
  const ChatRoom({Key key}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  IO.Socket socket = IO.io('http://192.168.1.4:3000', {
    "transports": ['websocket'],
    "autoConnect": false
  });

  final formKey = GlobalKey<FormState>();
  String userMessage = '';
  @override
  void initState() {
    socket.connect();
    super.initState();
  }

  ScrollController _scrollController = new ScrollController();

  @override
  void didChangeDependencies() {
    // print(socket.connected);
    socket.onConnect((_) {
      print(socket.connected);
      print(socket.id);
      socket.emit(
          'userEnterRoom',
          json.encode({
            //some info about the user chat room
            "room": (ModalRoute.of(context).settings.arguments
                    as Map<String, dynamic>)['RoomTitle']
                .toString(),
            "userName": (ModalRoute.of(context).settings.arguments
                    as Map<String, dynamic>)['userName']
                .toString()
          }));
      socket.on('message', (message) {
        _scrollController.animateTo(
            //! get the height of the componet now !
            _scrollController.position.maxScrollExtent +
                DeviceSizeUtils.getDeviceHieghtWithoutNotificationBar(
                        context: context) *
                    0.1,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut);
        BlocProvider.of<ChatBloc>(context).add(OnServerDeliveredMessage(
            message: ChatCordMessageModel(
                content: message,
                messageType: MessageType.SERVER,
                messageFrom: "server",
                messageTo: "user")));
      });
      socket.on('serverMessage', (msg) {
        _scrollController.animateTo(
            //! get the height of the componet now !
            _scrollController.position.maxScrollExtent +
                DeviceSizeUtils.getDeviceHieghtWithoutNotificationBar(
                        context: context) *
                    0.1,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut);
        // print('catched it ');
        final msgParser = json.decode(msg) as Map<String, dynamic>;
        print(msgParser);
        BlocProvider.of<ChatBloc>(context).add(OnServerDeliveredMessage(
            message: ChatCordMessageModel(
                content: msgParser['userMessage'],
                messageType: MessageType.SERVER,
                messageFrom: msgParser['messageFrom'],
                messageTo: msgParser['messageTo'])));
      });

      return print('connected');
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    socket.on('message', (message) => print(message));
    final arguments =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    print('user : ${arguments["userName"]}');
    print('room : ${arguments['RoomTitle'].toString()}');

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          DeviceSizeUtils.getDeviceWidth(context: context) > 480
              ? DeviceSizeUtils.getDeviceHieghtWithoutNotificationBar(
                      context: context) *
                  0.12
              : DeviceSizeUtils.getDeviceHieghtWithoutNotificationBar(
                      context: context) *
                  0.088,
        ),
        child: AppBar(
          title: Text(
            '${arguments['RoomTitle'].toString()} Chat Room',
            style: ApplicationFonts.getHeaderFont(
                context: context,
                color: Colors.white,
                fontSize: DeviceSizeUtils.getDeviceHieghtWithoutNotificationBar(
                        context: context) *
                    0.035,
                fontWeight: FontWeight.w600),
          ),
          actions: [
            IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  BlocProvider.of<ChatBloc>(context)
                      .add(ClearChatOnClientDisconnect());
                  socket.dispose();
                  Navigator.of(context)
                      .pushReplacementNamed(HomeScreen.PAGE_ROUTE);
                })
          ],
        ),
      ),
      body: Container(
        width: DeviceSizeUtils.getDeviceWidth(context: context),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(
                    DeviceSizeUtils.getDeviceWidth(context: context) > 480
                        ? DeviceSizeUtils.getDeviceHieghtWithoutNotificationBar(
                                context: context) *
                            0.020
                        : DeviceSizeUtils.getDeviceHieghtWithoutNotificationBar(
                                context: context) *
                            0.012,
                  ),
                  child: BlocConsumer<ChatBloc, ChatState>(
                      builder: (context, state) {
                        if (state is ServerDeliveredMessageSuccess) {
                          return ListView.builder(
                            controller: _scrollController,
                            shrinkWrap: true,
                            reverse: false,
                            itemCount: state.message.length,
                            itemBuilder: (context, index) => Container(
                              // height: DeviceSizeUtils.getDeviceWidth(
                              //             context: context) >
                              //         480
                              //     ? DeviceSizeUtils
                              //             .getDeviceHieghtWithoutNotificationBar(
                              //                 context: context) *
                              //         0.15
                              //     : DeviceSizeUtils
                              //             .getDeviceHieghtWithoutNotificationBar(
                              //                 context: context) *
                              //         0.088,
                              child: Card(
                                color: (state.message[index].messageFrom
                                            .toString() ==
                                        arguments['userName'].toString())
                                    ? Theme.of(context).primaryColor
                                    : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    DeviceSizeUtils
                                            .getDeviceHieghtWithoutNotificationBar(
                                                context: context) *
                                        0.060,
                                  ),
                                ),
                                child: Container(
                                    padding: EdgeInsets.all(
                                      DeviceSizeUtils.getDeviceWidth(
                                                  context: context) >
                                              480
                                          ? DeviceSizeUtils
                                                  .getDeviceHieghtWithoutNotificationBar(
                                                      context: context) *
                                              0.040
                                          : DeviceSizeUtils
                                                  .getDeviceHieghtWithoutNotificationBar(
                                                      context: context) *
                                              0.025,
                                    ),
                                    alignment: Alignment.centerLeft,
                                    // color: Colors.green,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          //!danger area fix it pleas
                                          padding: EdgeInsets.only(
                                            bottom: DeviceSizeUtils
                                                        .getDeviceWidth(
                                                            context: context) >
                                                    480
                                                ? DeviceSizeUtils
                                                        .getDeviceHieghtWithoutNotificationBar(
                                                            context: context) *
                                                    0.025
                                                : DeviceSizeUtils
                                                        .getDeviceHieghtWithoutNotificationBar(
                                                            context: context) *
                                                    0.010,
                                          ),
                                          child: Container(
                                            padding: EdgeInsets.only(
                                              top: DeviceSizeUtils
                                                          .getDeviceWidth(
                                                              context:
                                                                  context) >
                                                      480
                                                  ? DeviceSizeUtils
                                                          .getDeviceHieghtWithoutNotificationBar(
                                                              context:
                                                                  context) *
                                                      0.025
                                                  : DeviceSizeUtils
                                                          .getDeviceHieghtWithoutNotificationBar(
                                                              context:
                                                                  context) *
                                                      0.010,
                                            ),
                                            child: Text(
                                              state.message[index].messageFrom,
                                              style: ApplicationFonts.getHeaderFont(
                                                  context: context,
                                                  color: (state.message[index]
                                                              .messageFrom
                                                              .toString() ==
                                                          arguments['userName']
                                                              .toString())
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: DeviceSizeUtils.getDeviceWidth(
                                                              context:
                                                                  context) >
                                                          480
                                                      ? DeviceSizeUtils.getDeviceHieghtWithoutNotificationBar(
                                                              context:
                                                                  context) *
                                                          0.040
                                                      : DeviceSizeUtils.getDeviceHieghtWithoutNotificationBar(
                                                              context: context) *
                                                          0.020,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          state.message[index].content,
                                          style: ApplicationFonts.getHeaderFont(
                                              context: context,
                                              color: (state.message[index]
                                                          .messageFrom
                                                          .toString() ==
                                                      arguments['userName']
                                                          .toString())
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: DeviceSizeUtils.getDeviceWidth(
                                                          context: context) >
                                                      480
                                                  ? DeviceSizeUtils.getDeviceHieghtWithoutNotificationBar(
                                                          context: context) *
                                                      0.040
                                                  : DeviceSizeUtils
                                                          .getDeviceHieghtWithoutNotificationBar(
                                                              context: context) *
                                                      0.020,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                          );
                        }
                        return Container();
                      },
                      listener: (context, state) {}),
                ),
              ),
              Container(
                height: DeviceSizeUtils.getDeviceWidth(context: context) > 480
                    ? DeviceSizeUtils.getDeviceHieghtWithoutNotificationBar(
                            context: context) *
                        0.15
                    : DeviceSizeUtils.getDeviceHieghtWithoutNotificationBar(
                            context: context) *
                        0.1,
                color: Theme.of(context).primaryColor,
                padding: EdgeInsets.all(
                  DeviceSizeUtils.getDeviceWidth(context: context) > 480
                      ? DeviceSizeUtils.getDeviceHieghtWithoutNotificationBar(
                              context: context) *
                          0.010
                      : DeviceSizeUtils.getDeviceHieghtWithoutNotificationBar(
                              context: context) *
                          0.015,
                ),
                width: DeviceSizeUtils.getDeviceWidth(context: context),
                child: Row(
                  children: [
                    Container(
                      width: DeviceSizeUtils.getDeviceWidth(
                                  context: context) >
                              480
                          ? DeviceSizeUtils.getDeviceWidth(context: context) *
                              0.90
                          : DeviceSizeUtils.getDeviceWidth(context: context) *
                              0.80,
                      height:
                          DeviceSizeUtils.getDeviceWidth(context: context) > 480
                              ? DeviceSizeUtils
                                      .getDeviceHieghtWithoutNotificationBar(
                                          context: context) *
                                  0.12
                              : DeviceSizeUtils
                                      .getDeviceHieghtWithoutNotificationBar(
                                          context: context) *
                                  0.1,
                      child: TextFormField(
                        onSaved: (value) {
                          userMessage = value;
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'message',
                          contentPadding: EdgeInsets.only(
                            right: DeviceSizeUtils.getDeviceWidth(
                                    context: context) *
                                0.080,
                            left: DeviceSizeUtils.getDeviceWidth(
                                    context: context) *
                                0.080,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColorDark,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(
                                DeviceSizeUtils.getDeviceWidth(
                                    context: context)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColorDark,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(
                                DeviceSizeUtils.getDeviceWidth(
                                    context: context)),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColorDark,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(
                                DeviceSizeUtils.getDeviceWidth(
                                    context: context)),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(
                                DeviceSizeUtils.getDeviceWidth(
                                    context: context)),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 1.6,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(
                                DeviceSizeUtils.getDeviceWidth(
                                    context: context)),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: DeviceSizeUtils.getDeviceWidth(
                                    context: context) >
                                480
                            ? DeviceSizeUtils
                                    .getDeviceHieghtWithoutNotificationBar(
                                        context: context) *
                                0.13
                            : DeviceSizeUtils
                                    .getDeviceHieghtWithoutNotificationBar(
                                        context: context) *
                                0.13,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            formKey.currentState.save();
                            print(userMessage);

                            socket.emit(
                                'userMessage',
                                json.encode({
                                  "userMessage": userMessage,
                                  "messageType": "user",
                                  "messageFrom":
                                      arguments['userName'].toString(),
                                  "messageTo":
                                      arguments['RoomTitle'].toString(),
                                }));
                            // _scrollController.animateTo(0.0,
                            //     curve: Curves.easeOut,
                            //     duration: const Duration(milliseconds: 300));
                            _scrollController.animateTo(
                                //! get the height of the componet now !
                                _scrollController.position.maxScrollExtent +
                                    DeviceSizeUtils
                                            .getDeviceHieghtWithoutNotificationBar(
                                                context: context) *
                                        0.1,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeOut);
                            // _scrollController.jumpTo(
                            //     _scrollController.position.maxScrollExtent);
                          },
                          child: Icon(Icons.send,
                              color: Theme.of(context).primaryColorLight),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    socket.disconnect();
    socket.close();
    super.dispose();
  }
}
