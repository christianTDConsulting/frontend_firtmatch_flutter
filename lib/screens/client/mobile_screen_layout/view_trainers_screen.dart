import 'package:fit_match/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fit_match/utils/colors.dart';

import 'package:jwt_decoder/jwt_decoder.dart';

class ViewTrainers extends StatefulWidget {
  final String token;
  const ViewTrainers({required this.token, Key? key}) : super(key: key);

  @override
  _ViewTrainersState createState() => _ViewTrainersState();
}

class _ViewTrainersState extends State<ViewTrainers> {
  late User user;
  @override
  void initState() {
    super.initState();
    initUser();
  }

  void initUser() {
    Map<String, dynamic> userData = JwtDecoder.decode(widget.token)['user'];
    user = User.fromJson(userData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(),
    );
  }
}
