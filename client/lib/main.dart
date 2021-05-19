import 'package:client/presentation/screens/homePage.dart';
import 'package:client/routes/applicationRoutes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'logic/ChatBloc/chat_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ChatBloc(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Color(0xff02475e),
          primaryColorDark: Color(0xff687980),
          primaryColorLight: Color(0xfff3bda1),
          accentColor: Color(0xfffefecc),
        ),
        routes: ApplicationRoutes.routes(),
        initialRoute: ApplicationRoutes.initialRoute(),
      ),
    );
  }
}
