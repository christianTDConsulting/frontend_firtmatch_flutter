//WIDGET LISTA REVIEWS
import 'package:fit_match/models/review.dart';
import 'package:fit_match/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fit_match/utils/utils.dart';
import 'start.dart';

class ReviewListWidget extends StatefulWidget {
  final List<Review> reviews;

  ReviewListWidget({Key? key, required this.reviews}) : super(key: key);

  @override
  _ReviewListWidgetState createState() => _ReviewListWidgetState();
}

class _ReviewListWidgetState extends State<ReviewListWidget> {
  Map<num, bool> commentsVisibility = {};

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text('Reseñas',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
      const Text('Ordenar por',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      const SizedBox(height: 8),
      ...widget.reviews.map((review) => _buildReviewItem(review)).toList(),
    ]);
  }

//WIDGET REVIEW ITEM
  Widget _buildReviewItem(Review review) {
    final formattedRating = NumberFormat("0.00").format(review.rating);
    final timeAgo = formatTimeAgo(review.timestamp);
    commentsVisibility.putIfAbsent(review.reviewId, () => false);

    Widget usernameWidget;
    if (review.username.isNotEmpty) {
      usernameWidget = Text(review.username,
          style: const TextStyle(
              fontSize: 12, color: primaryColor, fontWeight: FontWeight.bold));
    } else {
      usernameWidget =
          const Text('Cargando...', style: TextStyle(fontSize: 12));
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
            const SizedBox(width: 5),
            Text('- $timeAgo', style: const TextStyle(fontSize: 12)),
          ],
        ),
        subtitle: Text(review.reviewContent),
      ),
      if (commentsVisibility[review.reviewId]!)
        _buildCommentsSection(review.comentarios),
      const SizedBox(height: 8),
      Row(
        children: [
          if (review.comentarios != null && review.comentarios!.isNotEmpty)
            TextButton(
              onPressed: () => toggleCommentsVisibility(review.reviewId),
              child: Text(
                commentsVisibility[review.reviewId]!
                    ? "Ocultar Respuestas"
                    : "Ver ${review.comentarios!.length} Respuestas",
                style: const TextStyle(color: blueColor),
              ),
            ),
          TextButton(
            onPressed: () =>
                onResponderPressed(), // Suponiendo que tienes una función onResponderPressed para manejar esta acción
            child: const Text("Responder", style: TextStyle(color: blueColor)),
          ),
        ],
      ),
    ]);
  }

  onResponderPressed() {}

  void toggleCommentsVisibility(num reviewId) {
    setState(() {
      // Cambiar el estado de visibilidad para la reseña específica
      commentsVisibility[reviewId] = !commentsVisibility[reviewId]!;
    });
  }

  Widget _buildCommentsSection(List<ComentarioReview>? comentarios) {
    // Si no hay comentarios, no mostrar nada
    if (comentarios == null || comentarios.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: comentarios.map((comentario) {
        final timeAgo = formatTimeAgo(comentario
            .timestamp); // Asumiendo que tienes una función similar para formatear el tiempo

        return Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                comentario.username,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                comentario.content,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                timeAgo,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
