class Reviews {
  final num review_id;
  final num client_id;
  final num rating;
  final String review_content;
  final DateTime timestamp;

  Reviews({
    required this.review_id,
    required this.client_id,
    required this.rating,
    required this.review_content,
    required this.timestamp,
  });
}
