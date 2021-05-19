import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ApplicationFonts {
  static TextStyle getHeaderFont(
      {@required BuildContext context,
      @required Color color,
      @required double fontSize,
      @required FontWeight fontWeight}) {
    return GoogleFonts.montserrat(
      color: color,
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
    );
  }
}
