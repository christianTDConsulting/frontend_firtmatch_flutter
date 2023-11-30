import 'package:fit_match/models/review.dart';

class Post {
  final String email;
  final num user_id;
  final String username;
  final String profile_picture;
  final String description;
  final String picture;
  final List<Reviews> reviews;
  Post({
    required this.email,
    required this.user_id,
    required this.username,
    required this.profile_picture,
    required this.description,
    required this.picture,
    required this.reviews,
  });
}
