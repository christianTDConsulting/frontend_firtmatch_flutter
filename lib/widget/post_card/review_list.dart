//WIDGET LISTA REVIEWS
import 'package:fit_match/models/review.dart';
import 'package:fit_match/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fit_match/utils/utils.dart';
import 'start.dart';

Widget buildReviewList(List<Review> reviews) {
  return Column(children: [
    const Text('Reseñas',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
    const Text('Ordenar por',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
    const SizedBox(height: 8),
    ...reviews.map((review) => _buildReviewItem(review)).toList(),
  ]);
}

//WIDGET REVIEW ITEM
Widget _buildReviewItem(Review review) {
  final formattedRating = NumberFormat("0.00").format(review.rating);
  final timeAgo = formatTimeAgo(review.timestamp);

  Widget usernameWidget;
  if (review.username != null) {
    usernameWidget = Text(review.username!,
        style: const TextStyle(
            fontSize: 12, color: primaryColor, fontWeight: FontWeight.bold));
  } else {
    usernameWidget = const Text('Cargando...', style: TextStyle(fontSize: 12));
  }

  return Column(children: [
    ListTile(
      title: Row(
        children: [
          usernameWidget,
          const SizedBox(width: 8),
          StarDisplay(
            value: review.rating,
            size: 20,
          ),
          const SizedBox(width: 5),
          Text('$formattedRating/5.0', style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 8),
          Text('- $timeAgo'),
        ],
      ),
      subtitle: Text(review.reviewContent),
    ),
    const SizedBox(height: 8),
    TextButton(
        onPressed: () => "",
        child: const Text("Responder", style: TextStyle(color: blueColor))),
  ]);
}
