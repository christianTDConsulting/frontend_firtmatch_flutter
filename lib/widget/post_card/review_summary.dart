import 'package:flutter/material.dart';
import 'package:fit_match/utils/utils.dart';
import 'package:fit_match/models/review.dart';
import 'start.dart';

class ReviewSummaryWidget extends StatelessWidget {
  final List<Review> reviews;

  ReviewSummaryWidget({Key? key, required this.reviews}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calcular el promedio de reseñas
    num averageRating = calculateAverageRating(reviews);

    // Contar las reseñas por calificación
    Map<int, int> ratingCount = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    reviews.forEach((review) {
      int roundedRating = review.rating.round();
      if (ratingCount.containsKey(roundedRating)) {
        ratingCount[roundedRating] = (ratingCount[roundedRating] ?? 0) + 1;
      }
    });

    // Encontrar el máximo número de reseñas para una calificación para escalar las barras del histograma
    int maxCount = ratingCount.values
        .fold(0, (prev, element) => element > prev ? element : prev);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Resumen de reseñas',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        ...ratingCount.entries.map((entry) {
          return Row(
            children: [
              Text('${entry.key}'),
              const SizedBox(width: 8),
              Expanded(
                flex: maxCount > 0 ? (entry.value * 100) ~/ maxCount : 0,
                child: Container(
                  height: 8,
                  color: Colors.grey[300],
                ),
              ),
              const SizedBox(width: 8),
            ],
          );
        }).toList(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              averageRating.toStringAsFixed(1),
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              width: 8,
            ),
            StarDisplay(
              value: averageRating,
              size: 32,
            ),
            Text(
              '(${reviews.length} reseñas)',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Center(
            child: ElevatedButton.icon(
          onPressed: () {
            // Acción para escribir una reseña
          },
          icon: const Icon(Icons.edit),
          label: const Text('Escribir una reseña'),
        )),
      ],
    );
  }
}
