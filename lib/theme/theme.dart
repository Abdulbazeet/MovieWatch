import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();
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
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 12.sp,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
      bodySmall: GoogleFonts.poppins(
        fontSize: 10.sp,
        color: Colors.black,
        fontWeight: FontWeight.w400,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFEB2F3D),
        foregroundColor: Colors.white,
        textStyle: GoogleFonts.poppins(
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
        ),
        fixedSize: Size(1.sw, 6.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        // padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 4.w),
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
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: GoogleFonts.poppins(
        // locale: DevicePreview.locale(context),
        // builder: DevicePreview.appBuilder,
        fontSize: 14.sp,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
      bodySmall: GoogleFonts.poppins(
        fontSize: 12.sp,
        color: Colors.white,
        fontWeight: FontWeight.w400,
      ),
    ),
  );
}
