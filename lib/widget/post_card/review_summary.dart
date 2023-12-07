import 'package:fit_match/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:fit_match/utils/utils.dart';
import 'package:fit_match/models/review.dart';
import 'start.dart';

class ReviewSummaryWidget extends StatelessWidget {
  final List<Review> reviews;

  ReviewSummaryWidget({Key? key, required this.reviews}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        ...ratingCount.entries.map((entry) {
          int flexValue = maxCount > 0 ? (entry.value * 75) ~/ maxCount : 0;
          return Row(
            children: [
              Text('${entry.key}'),
              const SizedBox(width: 8),
              Flexible(
                flex:
                    flexValue, // Ajusta este valor para controlar el ancho de la barra
                child: Container(
                  height: 8,
                  color: Colors.grey[300],
                ),
              ),
              Flexible(
                flex:
                    25 - flexValue, // Asegura que la suma total de flex sea 25
                child: Container(),
              ),
            ],
          );
        }).toList(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              flex: 18, // 3/4 del espacio para el texto y las estrellas
              child: Row(
                children: [
                  Text(
                    averageRating.toStringAsFixed(1),
                    style: const TextStyle(
                        fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  StarDisplay(
                    value: averageRating,
                    size: 32,
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 6, // 1/4 del espacio para el número de reseñas
              child: Text(
                '(${reviews.length} reseñas)',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        Center(
            child: ElevatedButton.icon(
          onPressed: () {
            // Acción para escribir una reseña
          },
          icon: const Icon(Icons.edit, color: blueColor),
          label: const Text(
            'Escribir una reseña',
            style: TextStyle(color: blueColor),
          ),
        )),
      ],
    );
  }
}
