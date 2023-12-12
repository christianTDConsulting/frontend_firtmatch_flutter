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
  final int userId;
  PostCard({Key? key, required this.post, required this.userId})
      : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  String _selectedOption = 'General';
  bool showExtraContent = false;

  //WIDGET PRINCIPAL
  @override
  Widget build(BuildContext context) {
    final formattedAverage =
        NumberFormat("0.0").format(calculateAverageRating(widget.post.reviews));
    final width = MediaQuery.of(context).size.width;
    //final height = MediaQuery.of(context).size.height;
    return SizedBox(
      width: 400,
      child: Card(
        color:
            width > webScreenSize ? webBackgroundColor : mobileBackgroundColor,
        surfaceTintColor:
            width > webScreenSize ? webBackgroundColor : mobileBackgroundColor,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 12),
            ListTile(
              title: Text(widget.post.username,
                  style: TextStyle(fontSize: width > webScreenSize ? 24 : 16)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(formattedAverage, style: const TextStyle(fontSize: 32)),
                  StarDisplay(
                      value: calculateAverageRating(widget.post.reviews),
                      size: width > webScreenSize ? 48 : 16),
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
                /*image: DecorationImage(
                  image: NetworkImage(widget.post.picture),
                  fit: BoxFit.cover,
                ),*/
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            _buildSelectButtons(),
            const SizedBox(
              height: 12,
            ),
            _selectedOption == 'General'
                ? Column(
                    children: [
                      const Text('Sobre mí',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24)),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: ExpandableText(text: widget.post.description),
                      ),
                    ],
                  )
                : Container(),
            widget.post.reviews.isNotEmpty && _selectedOption == 'Reviews'
                ? Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 30.0),
                        child:
                            ReviewSummaryWidget(reviews: widget.post.reviews),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: blueColor,
                          ),
                          onPressed: () => _showDialog(),
                          child: const Text("Ver todas las reseñas"),
                        ),
                      )
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
      children: ['General', 'Reviews', 'Información'].map((option) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: _selectedOption == option ? blueColor : Colors.grey,
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
    final width = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topRight,
            children: [
              if (_selectedOption == 'Reviews')
                ReviewListWidget(
                    reviews: widget.post.reviews, userId: widget.userId),
              if (_selectedOption == 'Información') const Text("Informacion"),
              Positioned(
                right: -10.0,
                top: -10.0,
                child: IconButton(
                  icon: const Icon(Icons.close,
                      size: 30.0), // Icono de cierre grande
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
