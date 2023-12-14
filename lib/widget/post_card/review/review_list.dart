//WIDGET LISTA REVIEWS
import 'package:fit_match/models/review.dart';
import 'package:fit_match/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fit_match/utils/utils.dart';
import 'package:fit_match/services/review_service.dart';
import '../start.dart';
import 'package:like_button/like_button.dart';

class ReviewListWidget extends StatefulWidget {
  final List<Review> reviews;
  final int userId;
  ReviewListWidget({Key? key, required this.reviews, required this.userId})
      : super(key: key);

  @override
  _ReviewListWidgetState createState() => _ReviewListWidgetState();
}

class _ReviewListWidgetState extends State<ReviewListWidget> {
  Map<num, bool> commentsVisibility = {};

  Widget usernameWidget(String username) {
    return Text(username,
        style: const TextStyle(
            fontSize: 16, color: primaryColor, fontWeight: FontWeight.bold));
  }

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

    return Column(children: [
      ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            review.username.isNotEmpty
                ? usernameWidget(review.username)
                : const Text('Cargando...', style: TextStyle(fontSize: 12)),
            Row(
              children: [
                StarDisplay(
                  value: review.rating,
                  size: 20,
                ),
                const SizedBox(width: 5),
                Text('$formattedRating/5.0',
                    style: const TextStyle(fontSize: 12)),
                const SizedBox(width: 5),
                Text('- $timeAgo', style: const TextStyle(fontSize: 12)),
              ],
            )
          ],
        ),
        subtitle: Text(review.reviewContent),
      ),
      if (commentsVisibility[review.reviewId]!)
        _buildCommentsSection(review.comentarios),
      const SizedBox(height: 8),
      Row(
        children: [
          const SizedBox(width: 8),
          _likeButton(review),
          //Text('${review.meGusta.length} Me gusta'),
          const SizedBox(width: 8),
          if (review.comentarios.isNotEmpty)
            TextButton(
              onPressed: () => toggleCommentsVisibility(review.reviewId),
              child: Text(
                commentsVisibility[review.reviewId]!
                    ? "Ocultar Respuestas"
                    : "Ver ${review.comentarios.length} Respuestas",
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
    if (comentarios == null || comentarios.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(left: 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: comentarios.map((comentario) {
          final timeAgo = formatTimeAgo(comentario.timestamp);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                usernameWidget(comentario.username),
                const SizedBox(width: 4),
                Text(
                  "-$timeAgo",
                  style: const TextStyle(fontSize: 12, color: primaryColor),
                ),
              ]),
              const SizedBox(height: 4),
              Text(
                comentario.content,
                style: const TextStyle(fontSize: 14, color: primaryColor),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _likeButton(Review review) {
    bool isLiked = review.meGusta.any((item) => item.userId == widget.userId);

    return LikeButton(
      size: 25,
      isLiked: isLiked,
      likeCount: review.meGusta.length,
      onTap: (bool isLiked) async {
        return handleLikeButtonPress(review, isLiked);
      },
    );
  }

  Future<bool> handleLikeButtonPress(Review review, bool isLiked) async {
    try {
      if (isLiked) {
        // Llamar al backend para quitar el 'me gusta'
        MeGusta likeToDelete = await likeReview(widget.userId, review.reviewId);

        // Actualizar el estado con los nuevos 'me gusta' una vez confirmado
        setState(() {
          review.meGusta
              .removeWhere((item) => item.likedId == likeToDelete.likedId);
        });
      } else {
        // Llamar al backend para dar 'me gusta'
        MeGusta like = await likeReview(widget.userId, review.reviewId);

        // Añadir el 'me gusta' a la lista localmente
        setState(() {
          review.meGusta.add(like);
        });
      }
      return true;
    } catch (e) {
      // Mostrar un error o manejarlo adecuadamente
      print('Error al dar o quitar me gusta: $e');
      return false;
    }
  }
}
