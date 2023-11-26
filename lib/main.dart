import 'package:fit_match/responsive/mobile_screen_layout.dart';
import 'package:fit_match/responsive/responsive_layout_screen.dart';
import 'package:fit_match/responsive/web_screen_layout.dart';
import 'package:fit_match/screens/shared/login_screen.dart';
import 'package:fit_match/screens/shared/register_screen.dart';
import 'package:fit_match/utils/colors.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fit-Match',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark()
          .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
      /*home: const ResponsiveLayoutScreen(
        movileScreenLayout: MobileScreenLayout(),
        webScreenLayout: WebScreenLayout(),
      ),*/
      home: RegisterScreen(),
    );
  }
}
