import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightmode = ThemeData(
    colorScheme: ColorScheme.light(
      brightness: Brightness.light,
      primary: Color(0xFFEB2F3D),
      surface: Colors.grey[400]!,
      onSurface: Colors.black,
      secondary: Colors.white,
    ),
    textTheme: TextTheme(
      bodyLarge: GoogleFonts.poppins(
        color: Colors.black,
        fontSize: 19,
        fontWeight: FontWeight.bold,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 14,
        color: Colors.black,
        fontWeight: FontWeight.w500,

        height: 1.43,
      ), // ignore_for_file: public_member_api_docs, sort_constructors_first

      bodySmall: GoogleFonts.poppins(
        fontSize: 12,
        color: Colors.black,
        fontWeight: FontWeight.w400,
        height: 1.33,
      ),
      labelSmall: GoogleFonts.poppins(
        fontSize: 11,
        color: Colors.black,
        fontWeight: FontWeight.w400,
        height: 1.45,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFEB2F3D),
        foregroundColor: Colors.white,
        textStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        // padding: EdgeInsets.symmetric(vertical: 3 , horizontal: 4 ),
      ),
    ),
  );

  static ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: Color(0xFFEB2F3D),
      surface: Colors.black54,
      onSurface: Colors.white,
      secondary: Colors.black,
    ),
    textTheme: TextTheme(
      bodyLarge: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: GoogleFonts.poppins(
        // locale: DevicePreview.locale(context),
        // builder: DevicePreview.appBuilder,
        fontSize: 14,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
      bodySmall: GoogleFonts.poppins(
        fontSize: 12,
        color: Colors.white,
        fontWeight: FontWeight.w400,
      ),
    ),
  );
}
