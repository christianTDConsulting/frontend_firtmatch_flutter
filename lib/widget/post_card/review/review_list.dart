import 'package:fit_match/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:fit_match/models/review.dart';
import 'package:fit_match/utils/colors.dart';
import 'package:fit_match/utils/utils.dart';
import 'package:fit_match/services/review_service.dart';
import '../start.dart';

class ReviewListWidget extends StatefulWidget {
  final List<Review> reviews;
  final int userId;
  final int clientId;
  final Function onReviewDeleted; // Callback

  const ReviewListWidget(
      {Key? key,
      required this.reviews,
      required this.userId,
      required this.clientId,
      required this.onReviewDeleted})
      : super(key: key);

  @override
  _ReviewListWidgetState createState() => _ReviewListWidgetState();
}

class _ReviewListWidgetState extends State<ReviewListWidget> {
  Map<num, bool> commentsVisibility = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Reseñas',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        const Text('Ordenar por',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        ...widget.reviews.map(_buildReviewItem).toList(),
      ],
    );
  }

  Widget _buildReviewItem(Review review) {
    commentsVisibility.putIfAbsent(review.reviewId, () => false);

    return Column(
      children: [
        ListTile(
          title: _buildReviewTitle(review),
          subtitle: Text(review.reviewContent),
        ),
        _buildReviewActions(review),
        if (commentsVisibility[review.reviewId] ?? false)
          _buildCommentsSection(review.comentarios),
      ],
    );
  }

  Widget _buildReviewTitle(Review review) {
    final formattedRating = NumberFormat("0.00").format(review.rating);
    final timeAgo = formatTimeAgo(review.timestamp);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        review.username.isNotEmpty
            ? Text(review.username,
                style: const TextStyle(
                    fontSize: 16,
                    color: primaryColor,
                    fontWeight: FontWeight.bold))
            : const Text('Cargando...', style: TextStyle(fontSize: 12)),
        Row(
          children: [
            StarDisplay(value: review.rating, size: 20),
            const SizedBox(width: 5),
            Text('$formattedRating/5.0', style: const TextStyle(fontSize: 12)),
            Text(' - $timeAgo', style: const TextStyle(fontSize: 12)),
          ],
        )
      ],
    );
  }

  Widget _buildReviewActions(Review review) {
    final width = MediaQuery.of(context).size.width;
    return Row(
      children: [
        const SizedBox(width: 8),
        _likeButton(review),
        if (review.comentarios.isNotEmpty)
          TextButton(
            onPressed: () => toggleCommentsVisibility(review.reviewId),
            child: Text(
                commentsVisibility[review.reviewId]!
                    ? "Ocultar Respuestas"
                    : "Ver ${review.comentarios.length} Respuestas",
                style: const TextStyle(color: blueColor)),
          ),
        TextButton(
          onPressed: () => onResponderPressed(context, width),
          child: const Text("Responder", style: TextStyle(color: blueColor)),
        ),
        if (review.clientId == widget.clientId)
          IconButton(
            icon: const Icon(Icons.delete),
            color: Colors.red,
            onPressed: () => _deleteReview(review),
          ),
      ],
    );
  }

  void toggleCommentsVisibility(num reviewId) {
    setState(() {
      commentsVisibility[reviewId] = !(commentsVisibility[reviewId] ?? false);
    });
  }

  Widget _buildCommentsSection(List<ComentarioReview>? comentarios) {
    return comentarios?.isEmpty ?? true
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.only(left: 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: comentarios!.map(_buildCommentItem).toList(),
            ),
          );
  }

  Widget _buildCommentItem(ComentarioReview comentario) {
    final timeAgo = formatTimeAgo(comentario.timestamp);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(comentario.username,
              style: const TextStyle(
                  fontSize: 16,
                  color: primaryColor,
                  fontWeight: FontWeight.bold)),
          const SizedBox(width: 4),
          Text("-$timeAgo",
              style: const TextStyle(fontSize: 12, color: primaryColor)),
          Expanded(
            child: Text(comentario.content,
                style: const TextStyle(fontSize: 14, color: primaryColor)),
          ),
        ],
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
        return await handleLikeButtonPress(review, isLiked);
      },
    );
  }

  void onResponderPressed(BuildContext context, double width) {
    if (width < webScreenSize) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return _buildMobileReviewInput();
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return _buildWebReviewInput(context);
        },
      );
    }
  }

  Widget _buildMobileReviewInput() {
    return Container();
  }

  Widget _buildWebReviewInput(BuildContext context) {
    return Container();
  }

  Future<void> _deleteReview(Review review) async {
    try {
      await deleteReview(review.reviewId);

      setState(() {
        widget.reviews.removeWhere((item) => item.reviewId == review.reviewId);
        showToast(context, 'Reseña elimianda con éxito');
      });
      widget.onReviewDeleted(review.reviewId); //Notifica a review summary
    } catch (e) {
      print('Error al eliminar la reseña: $e');
    }
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
      print('Error al dar o quitar me gusta: $e');
      return false;
    }
  }
}
