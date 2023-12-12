import 'dart:convert';
import 'package:fit_match/models/review.dart';
import 'package:fit_match/utils/backendUrls.dart';
import 'package:http/http.dart' as http;

Future<MeGusta> likeReview(num userId, num reviewId) async {
  final response = await http.post(
    Uri.parse(likeReviewUrl),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({'userId': userId, 'reviewId': reviewId}),
  );

  if (response.statusCode == 200) {
    print(response.statusCode.toString() + " " + response.body);
    return MeGusta.fromJson(jsonDecode(response.body));
  } else {
    throw Exception(
        'Error al obtener los posts. Código de estado: ${response.statusCode}');
  }
}
