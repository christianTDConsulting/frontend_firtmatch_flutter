import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:fit_match/models/user.dart';
import 'package:fit_match/providers/get_jwt_token.dart';
import 'package:fit_match/responsive/mobile_layout.dart';
import 'package:fit_match/responsive/web_layout.dart';
import 'package:fit_match/utils/dimensions.dart';

class ResponsiveLayout extends StatefulWidget {
  final int initialPage;

  const ResponsiveLayout({Key? key, this.initialPage = 0}) : super(key: key);

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  Future<User?> _initializeUser() async {
    try {
      String? token = await getToken();
      if (token != null) {
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        if (decodedToken.containsKey('user')) {
          return User.fromJson(decodedToken['user']);
        }
      }
      return null;
    } catch (e) {
      print("Error al inicializar el usuario: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: _initializeUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return const Text('Error al cargar los datos del usuario.');
        }
        User user = snapshot.data!;

        return LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth > webScreenSize) {
            return WebLayout(user: user, initialPage: widget.initialPage);
          }
          return mobileLayout(user: user, initialPage: widget.initialPage);
        });
      },
    );
  }
}
