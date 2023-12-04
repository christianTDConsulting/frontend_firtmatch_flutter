import 'package:fit_match/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:fit_match/models/review.dart';
import 'package:fit_match/models/post.dart';
import 'package:fit_match/utils/colors.dart';
import 'package:intl/intl.dart';

class PostCard extends StatefulWidget {
  final Post post;

  PostCard({Key? key, required this.post}) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _showReviews = false;

  void _onShowReviewsPressed() {
    final width = MediaQuery.of(context).size.width;
    if (width <= webScreenSize) {
      // En dispositivos móviles, muestra un diálogo con botón de cierre
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topRight,
              children: [
                _buildReviewList(widget.post.reviews),
                Positioned(
                  right: -10.0,
                  top: -10.0,
                  child: IconButton(
                    icon:
                        Icon(Icons.close, size: 30.0), // Icono de cierre grande
                    onPressed: () =>
                        Navigator.of(context).pop(), // Cierra el diálogo
                  ),
                ),
              ],
            ),
          );
        },
      );
    } else {
      // En dispositivos de escritorio, usa el desplegable
      setState(() => _showReviews = !_showReviews);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedAverage = NumberFormat("0.0")
        .format(_calculateAverageRating(widget.post.reviews));
    return Container(
      width: 400,
      height: 400,
      child: Card(
        color: webBackgroundColor,
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(widget.post.username),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  StarDisplay(
                      value: _calculateAverageRating(widget.post.reviews)),
                  SizedBox(width: 5),
                  Text("$formattedAverage/5.0"),
                ],
              ),
            ),
            Container(
              width: 250, // Fija el ancho del contenedor
              height: 250, // Fija la altura del contenedor
              decoration: BoxDecoration(
                border:
                    Border.all(color: primaryColor, width: 2), // Borde visible
                image: DecorationImage(
                  image: NetworkImage(widget.post.picture),
                  fit: BoxFit
                      .cover, // Asegura que la imagen cubra todo el contenedor
                ),
              ),
            ),
            TextButton(
              onPressed: _onShowReviewsPressed,
              child: Text(_showReviews ? 'Ocultar Reviews' : 'Ver Reviews'),
            ),
            _showReviews ? _buildReviewList(widget.post.reviews) : Container(),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewList(List<Review> reviews) {
    return Column(
      children: reviews.map((review) => _buildReviewItem(review)).toList(),
    );
  }

  Widget _buildReviewItem(Review review) {
    final formattedRating = NumberFormat("0.00").format(review.rating);
    final timeAgo = _formatTimeAgo(review.timestamp);

    Widget usernameWidget;
    if (review.username != null) {
      usernameWidget = Text(review.username!,
          style: const TextStyle(
              fontSize: 12, color: primaryColor, fontWeight: FontWeight.bold));
    } else {
      usernameWidget =
          const Text('Cargando...', style: TextStyle(fontSize: 12));
    }

    return ListTile(
      title: Row(
        children: [
          usernameWidget,
          const SizedBox(width: 8),
          StarDisplay(value: review.rating),
          const SizedBox(width: 5),
          Text('$formattedRating/5.0', style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 8),
          Text('- $timeAgo'),
        ],
      ),
      subtitle: Text(review.reviewContent),
    );
  }

  num _calculateAverageRating(List<Review> reviews) {
    if (reviews.isEmpty) return 0;
    return reviews.map((r) => r.rating).reduce((a, b) => a + b) ~/
        reviews.length;
  }
}

String _formatTimeAgo(DateTime timestamp) {
  final now = DateTime.now();
  final difference = now.difference(timestamp);

  if (difference.inDays >= 365) {
    final int years = (difference.inDays / 365).floor();
    return 'hace $years ${years == 1 ? 'año' : 'años'}';
  } else if (difference.inDays >= 30) {
    final int months = (difference.inDays / 30).floor();
    return 'hace $months ${months == 1 ? 'mes' : 'meses'}';
  } else if (difference.inDays >= 7) {
    final int weeks = (difference.inDays / 7).floor();
    return 'hace $weeks ${weeks == 1 ? 'semana' : 'semanas'}';
  } else if (difference.inDays == 1) {
    return 'hace 1 día';
  } else if (difference.inDays > 0) {
    return 'hace ${difference.inDays} días';
  } else if (difference.inHours == 1) {
    return 'hace 1 hora';
  } else if (difference.inHours > 0) {
    return 'hace ${difference.inHours} horas';
  } else if (difference.inMinutes == 1) {
    return 'hace 1 minuto';
  } else if (difference.inMinutes > 0) {
    return 'hace ${difference.inMinutes} minutos';
  } else {
    return 'Justo ahora';
  }
}

class StarDisplay extends StatelessWidget {
  final num value;
  const StarDisplay({Key? key, this.value = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < value ? Icons.star : Icons.star_border,
        );
      }),
    );
  }
}
