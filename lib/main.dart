//import 'package:fit_match/responsive/mobile_screen_layout.dart';
//import 'package:fit_match/responsive/responsive_layout_screen.dart';
//import 'package:fit_match/responsive/web_screen_layout.dart';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fit_match/screens/shared/login_screen.dart';
import 'package:fit_match/screens/client/mobile_screen_layout/view_trainers_screen.dart';
import 'package:fit_match/utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(
    token: prefs.getString('token'),
  ));
}

class MyApp extends StatelessWidget {
  final token;
  const MyApp({super.key, @required this.token});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fit-Match',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark()
          .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
      /*home: const ResponsiveLayoutScreen(
        mobileScreenLayout: MobileScreenLayout(),
        webScreenLayout: WebScreenLayout(),
      ),*/
      home: (token != null && JwtDecoder.isExpired(token) == false)
          ? ViewTrainers(token: token)
          : LoginScreen(),
    );
  }
}
