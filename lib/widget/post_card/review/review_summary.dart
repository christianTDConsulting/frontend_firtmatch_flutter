import 'package:fit_match/services/review_service.dart';
import 'package:fit_match/utils/colors.dart';
import 'package:fit_match/utils/dimensions.dart';
import 'package:fit_match/widget/post_card/review/review_input_widget.dart';
import 'package:fit_match/widget/post_card/review/review_list.dart';
import 'package:flutter/material.dart';
import 'package:fit_match/utils/utils.dart';
import 'package:fit_match/models/review.dart';
import '../start.dart';

class ReviewSummaryWidget extends StatefulWidget {
  final List<Review> reviews;
  final int userId;
  final int trainerId;

  const ReviewSummaryWidget(
      {Key? key,
      required this.reviews,
      required this.userId,
      required this.trainerId})
      : super(key: key);

  @override
  _ReviewSummaryWidgetState createState() => _ReviewSummaryWidgetState();
}

class _ReviewSummaryWidgetState extends State<ReviewSummaryWidget> {
  List<Review> get reviews => widget.reviews;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    num averageRating = calculateAverageRating(reviews);
    Map<int, int> ratingCount = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    reviews.forEach((review) {
      int roundedRating = review.rating.round();

      if (ratingCount.containsKey(roundedRating)) {
        ratingCount[roundedRating] = (ratingCount[roundedRating] ?? 0) + 1;
      }
    });

    int maxCount = ratingCount.values
        .fold(0, (prev, element) => element > prev ? element : prev);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Resumen de reseñas',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),

        // Fila para histograma y estrellas
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Sección para el histograma
            Flexible(
              flex: 3, // Ajusta el espacio para el histograma
              child: Column(
                children: ratingCount.entries.map((entry) {
                  int flexValue =
                      maxCount > 0 ? (entry.value * 75) ~/ maxCount : 0;
                  return Row(
                    children: [
                      Text('${entry.key}'),
                      const SizedBox(width: 8),
                      Flexible(
                        flex: flexValue, // Ancho de la barra
                        child: Container(
                          height: 8,
                          color: Colors.grey[300],
                        ),
                      ),
                      Flexible(
                        flex: 25 - flexValue,
                        child: Container(),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),

            // Sección para la calificación promedio y estrellas
            Flexible(
              flex:
                  2, // Ajusta el espacio para la calificación promedio y estrellas
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    averageRating.toStringAsFixed(1),
                    style: const TextStyle(
                        fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                  StarDisplay(
                    value: averageRating,
                    size: width > webScreenSize ? 32 : 16,
                  ),
                  Text(
                    '(${reviews.length} reseñas)',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
        Center(
          child: ElevatedButton.icon(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return FractionallySizedBox(
                    heightFactor: 0.6,
                    child: Column(
                      children: [
                        // Indicador de arrastre
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Container(
                            width: 40,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),

                        // Contenido del BottomSheet
                        Expanded(
                          child: ReviewInputWidget(
                            onReviewSubmit:
                                (double rating, String reviewText) async {
                              onReviewSubmit(widget.userId, widget.trainerId,
                                  rating, reviewText);
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            icon: const Icon(Icons.edit, color: blueColor),
            label: const Text(
              'Escribir una reseña',
              style: TextStyle(color: blueColor),
            ),
          ),
        ),
        const SizedBox(height: 16),

        reviews.isNotEmpty
            ? ReviewListWidget(reviews: [reviews.first], userId: widget.userId)
            : Container(),
      ],
    );
  }

  Future onReviewSubmit(
      num userId, num trainerId, double rating, String reviewText) async {
    try {
      Review review =
          addReview(userId, trainerId, rating, reviewText) as Review;

      setState(() {
        reviews.add(review);
        // close showModalBottomSheet
        showSuccessToast(msg: "Reseña anadida", context: context);
      });
    } catch (e) {
      print('Error al añadir el post: $e');
    }
  }
}
