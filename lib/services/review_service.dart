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
    return MeGusta.fromJson(jsonDecode(response.body));
  } else {
    throw Exception(
        'Error al dar Like Código de estado: ${response.statusCode}');
  }
}

Future<Review> addReview(
    num clientId, num trainerId, num rating, String reviewContent) async {
  final response = await http.post(
    Uri.parse(reviewsUrl),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'userId': clientId,
      'trainerId': trainerId,
      'rating': rating,
      'reviewContent': reviewContent
    }),
  );

  if (response.statusCode == 200) {
    print(jsonDecode(response.body));
    return Review.fromJson(jsonDecode(response.body));
  } else {
    throw Exception(
        'Error al crear la review. Código de estado: ${response.statusCode}');
  }
}

Future<Review> deleteReview(num reviewId) async {
  final response = await http.delete(
    Uri.parse('$reviewsUrl/$reviewId'),
    headers: {
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    return Review.fromJson(jsonDecode(response.body));
  } else {
    throw Exception(
        'Error al eliminar el review. Código de estado: ${response.statusCode}');
  }
}

Future<ComentarioReview> addComent(
    num userId, num reviewId, String answer) async {
  final response = await http.post(
    Uri.parse(likeReviewUrl),
    headers: {
      'Content-Type': 'application/json',
    },
    body:
        jsonEncode({'userId': userId, 'reviewId': reviewId, 'answer': answer}),
  );

  if (response.statusCode == 200) {
    return ComentarioReview.fromJson(jsonDecode(response.body));
  } else {
    throw Exception(
        'Error al obtener los posts. Código de estado: ${response.statusCode}');
  }
}

Future<ComentarioReview> deleteComment(num commentId) async {
  final response = await http.delete(
    Uri.parse('$commentUrl/$commentId'),
    headers: {
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    return ComentarioReview.fromJson(jsonDecode(response.body));
  } else {
    throw Exception(
        'Error al eliminar el review. Código de estado: ${response.statusCode}');
  }
}
