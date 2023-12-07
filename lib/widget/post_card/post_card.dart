import 'package:fit_match/utils/dimensions.dart';
import 'package:fit_match/utils/utils.dart';
import 'package:fit_match/widget/expandable_text.dart';
import 'package:flutter/material.dart';
import 'review_list.dart';
import 'review_summary.dart';
import 'start.dart';
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
  String _selectedOption = 'general';

  //WIDGET PRINCIPAL
  @override
  Widget build(BuildContext context) {
    final formattedAverage =
        NumberFormat("0.0").format(calculateAverageRating(widget.post.reviews));
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SizedBox(
      width: 400,
      height: height / 1.25,
      child: Card(
        color:
            width > webScreenSize ? webBackgroundColor : mobileBackgroundColor,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 12),
            ListTile(
              title: Text(widget.post.username),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(formattedAverage, style: const TextStyle(fontSize: 32)),
                  StarDisplay(
                      value: calculateAverageRating(widget.post.reviews),
                      size: width > webScreenSize ? 48 : 32),
                  const SizedBox(width: 5),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: width > webScreenSize ? 500 : 250,
              height: width > webScreenSize ? 500 : 250,
              decoration: BoxDecoration(
                border: Border.all(color: primaryColor, width: 2),
                image: DecorationImage(
                  image: NetworkImage(widget.post.picture),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            _buildSelectButtons(),
            const SizedBox(
              height: 12,
            ),
            _selectedOption == 'general'
                ? Flexible(child: ExpandableText(text: widget.post.description))
                : Container(),
            widget.post.reviews.isNotEmpty && _selectedOption == 'reviews'
                ? Column(
                    children: [
                      ReviewSummaryWidget(reviews: widget.post.reviews),
                      TextButton(
                          onPressed: () => _showDialog(),
                          child: const Text("Ver todas las reseñas")),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

//SELECT BUTTONS
  Widget _buildSelectButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: ['general', 'reviews', 'información'].map((option) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: _selectedOption == option ? Colors.blue : Colors.grey,
              onPrimary: Colors.white,
            ),
            onPressed: () => _onSelectOption(option),
            child: Text(option),
          ),
        );
      }).toList(),
    );
  }

  void _onSelectOption(String option) {
    setState(() {
      _selectedOption = option;
    });
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topRight,
            children: [
              if (_selectedOption == 'reviews')
                buildReviewList(widget.post.reviews),
              if (_selectedOption == 'información') const Text("Contenedor"),
              Positioned(
                right: -10.0,
                top: -10.0,
                child: IconButton(
                  icon: Icon(Icons.close, size: 30.0), // Icono de cierre grande
                  onPressed: () =>
                      Navigator.of(context).pop(), // Cierra el diálogo
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
