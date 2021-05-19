import 'package:flutter/cupertino.dart';

class DeviceSizeUtils {
  static double getDeviceHieghtWithoutNotificationBar(
      {@required BuildContext context}) {
    return MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top;
  }

  static double getDeviceWidth({@required BuildContext context}) {
    return MediaQuery.of(context).size.width;
  }
}
