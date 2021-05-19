import 'package:client/config/fonts.dart';
import 'package:client/config/size.dart';
import 'package:client/presentation/screens/ChatRoom.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String PAGE_ROUTE = '/HomeScreen';
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String dropdownValue = 'Node.js';

  @override
  Widget build(BuildContext context) {
    print(dropdownValue);
    print(DeviceSizeUtils.getDeviceWidth(context: context));
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
            "chatting application",
            style: ApplicationFonts.getHeaderFont(
                context: context,
                color: Colors.white,
                fontSize: DeviceSizeUtils.getDeviceHieghtWithoutNotificationBar(
                        context: context) *
                    0.035,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        width: DeviceSizeUtils.getDeviceWidth(context: context),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: DeviceSizeUtils.getDeviceHieghtWithoutNotificationBar(
                        context: context) *
                    0.8,
                width: DeviceSizeUtils.getDeviceWidth(context: context) * 0.85,
                child: Card(
                  color: Theme.of(context).accentColor,
                  child: Form(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              top: DeviceSizeUtils
                                      .getDeviceHieghtWithoutNotificationBar(
                                          context: context) *
                                  0.050),
                          width:
                              DeviceSizeUtils.getDeviceWidth(context: context) *
                                  0.75,
                          height: DeviceSizeUtils.getDeviceWidth(
                                      context: context) >
                                  480
                              ? DeviceSizeUtils
                                      .getDeviceHieghtWithoutNotificationBar(
                                          context: context) *
                                  0.12
                              : DeviceSizeUtils
                                      .getDeviceHieghtWithoutNotificationBar(
                                          context: context) *
                                  0.065,
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'enter your name',
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
                        SizedBox(
                          height: DeviceSizeUtils
                                  .getDeviceHieghtWithoutNotificationBar(
                                      context: context) *
                              0.060,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              child: Text(
                                'Pick Room',
                                style: ApplicationFonts.getHeaderFont(
                                    context: context,
                                    color: Colors.black,
                                    fontSize: DeviceSizeUtils
                                            .getDeviceHieghtWithoutNotificationBar(
                                                context: context) *
                                        0.030,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            DropdownButton<String>(
                              onChanged: (String value) {
                                setState(() {
                                  dropdownValue = value;
                                  //!backend code will reside here
                                  print(value);
                                });
                              },
                              value: dropdownValue,
                              items: <String>[
                                'Node.js',
                                'C++',
                                'JavaScript',
                                'Flutter'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: DeviceSizeUtils.getDeviceWidth(
                                      context: context) >
                                  480
                              ? DeviceSizeUtils
                                      .getDeviceHieghtWithoutNotificationBar(
                                          context: context) *
                                  0.25
                              : DeviceSizeUtils
                                      .getDeviceHieghtWithoutNotificationBar(
                                          context: context) *
                                  0.45,
                        ),
                        Container(
                          child: ElevatedButton(
                            onPressed: () {
                              //!backend Code
                              Navigator.of(context).pushReplacementNamed(
                                ChatRoom.PAGE_ROUTE,
                                arguments: {"RoomTitle": dropdownValue},
                              );
                            },
                            child: Text("Enter the Chat"),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).primaryColor),
                              minimumSize: MaterialStateProperty.all(
                                Size(
                                  DeviceSizeUtils.getDeviceWidth(
                                          context: context) *
                                      0.75,
                                  DeviceSizeUtils.getDeviceWidth(
                                              context: context) >
                                          480
                                      ? DeviceSizeUtils
                                              .getDeviceHieghtWithoutNotificationBar(
                                                  context: context) *
                                          0.12
                                      : DeviceSizeUtils
                                              .getDeviceHieghtWithoutNotificationBar(
                                                  context: context) *
                                          0.065,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
