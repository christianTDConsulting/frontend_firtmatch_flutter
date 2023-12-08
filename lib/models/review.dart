class Review {
  final num reviewId;
  final num clientId;
  final num rating;
  final String reviewContent;
  final DateTime timestamp;
  String username;
  Review({
    required this.reviewId,
    required this.clientId,
    required this.rating,
    required this.reviewContent,
    required this.timestamp,
    required this.username,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      reviewId: json['review_id'] as num,
      clientId: json['client_id'] as num,
      rating: json['rating'] as num,
      reviewContent: json['review_content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      username: json['username'] as String,
    );
  }
}
