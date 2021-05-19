import 'package:client/config/fonts.dart';
import 'package:client/config/size.dart';
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
  IO.Socket socket = IO.io('http://localhost:3000', {
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

  @override
  void didChangeDependencies() {
    // print(socket.connected);
    socket.onConnect((_) {
      print(socket.connected);
      socket.on(
          'message',
          (message) => BlocProvider.of<ChatBloc>(context)
              .add(OnServerDeliveredMessage(message: message)));

      return print('connected');
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    socket.on('message', (message) => print(message));
    final arguments =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
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
                                    child: Text(
                                      state.message[index],
                                      style: ApplicationFonts.getHeaderFont(
                                          context: context,
                                          color: Colors.black,
                                          fontSize: DeviceSizeUtils
                                                      .getDeviceWidth(
                                                          context: context) >
                                                  480
                                              ? DeviceSizeUtils
                                                      .getDeviceHieghtWithoutNotificationBar(
                                                          context: context) *
                                                  0.040
                                              : DeviceSizeUtils
                                                      .getDeviceHieghtWithoutNotificationBar(
                                                          context: context) *
                                                  0.020,
                                          fontWeight: FontWeight.w600),
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
                            BlocProvider.of<ChatBloc>(context)
                                .add(UserSendMessage(userMessage: userMessage));
                            socket.emit('userMessage', userMessage);
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
