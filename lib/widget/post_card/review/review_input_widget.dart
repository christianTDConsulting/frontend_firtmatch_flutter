import 'package:fit_match/widget/text_field_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewInputWidget extends StatefulWidget {
  final Future<void> Function(double rating, String reviewText) onReviewSubmit;

  ReviewInputWidget({Key? key, required this.onReviewSubmit}) : super(key: key);

  @override
  _ReviewInputWidgetState createState() => _ReviewInputWidgetState();
}

class _ReviewInputWidgetState extends State<ReviewInputWidget> {
  final TextEditingController _textController = TextEditingController();
  double _currentRating = 3; // Valor inicial de la calificación

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(children: [
          const SizedBox(width: 8),
          const Text(
            "Calificación: ",
          ),
          const SizedBox(width: 8),
          RatingBar.builder(
            initialRating: _currentRating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) =>
                const Icon(Icons.star, color: Colors.amber),
            onRatingUpdate: (rating) {
              setState(() {
                _currentRating = rating;
              });
            },
          ),
        ]),
        const SizedBox(height: 8),
        Flexible(
          child: TextFieldInput(
            textEditingController: _textController,
            hintText: 'Escribe tu reseña aquí',
            textInputType: TextInputType.multiline,
            isPsw: false,
            maxLine: true,
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () async {
            // Espera a que la función asincrónica se complete
            await widget.onReviewSubmit(_currentRating, _textController.text);
          },
          child: const Text('Enviar Reseña'),
        ),
      ],
    );
  }
}
