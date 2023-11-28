import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class ViewTrainers extends StatefulWidget {
  final String token;
  const ViewTrainers({required this.token, Key? key}) : super(key: key);

  @override
  _ViewTrainersState createState() => _ViewTrainersState();
}

class _ViewTrainersState extends State<ViewTrainers> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
