import 'package:fit_match/models/review.dart';

class Post {
  final num trainerId;
  final num userId;
  final String email;
  final String username;
  final String profilePicture;
  final String description;
  final String picture;
  final num price;
  final List<Review> reviews;
  final DateTime birth;

  Post({
    required this.trainerId,
    required this.userId,
    required this.email,
    required this.username,
    required this.profilePicture,
    required this.description,
    required this.picture,
    required this.price,
    required this.reviews,
    required this.birth,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    List<Review> reviews = (json['reviews'] as List?)
            ?.map((reviewJson) =>
                Review.fromJson(reviewJson as Map<String, dynamic>))
            .toList() ??
        [];

    return Post(
      trainerId: json['trainer_id'] as num,
      userId: json['user_id'] as num,
      email: json['email'] as String? ?? 'default@email.com',
      username: json['username'] as String? ?? 'defaultUsername',
      profilePicture:
          json['profile_picture'] as String? ?? 'defaultProfilePicture',
      description: json['description'] as String? ?? 'defaultDescription',
      picture: json['picture'] as String? ?? 'defaultPicture',
      price: json['price'] as num,
      birth: json['birth'] != null
          ? DateTime.parse(json['birth'])
          : DateTime.now(),
      reviews: reviews,
    );
  }
}
