class Review {
  final num reviewId;
  final num clientId;
  final num rating;
  final String reviewContent;
  final DateTime timestamp;
  final String username;
  List<ComentarioReview>? comentarios;
  List<MeGusta>? meGusta;
  Review({
    required this.reviewId,
    required this.clientId,
    required this.rating,
    required this.reviewContent,
    required this.timestamp,
    required this.username,
    this.comentarios,
    this.meGusta,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      reviewId: json['review_id'] as num,
      clientId: json['client_id'] as num,
      rating: json['rating'] as num,
      reviewContent: json['review_content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      username: json['username'] as String,
      comentarios: json['comentario_review'] != null
          ? (json['comentario_review'] as List<dynamic>)
              .map((comentario) => ComentarioReview.fromJson(comentario))
              .toList()
          : null,
      meGusta: json['me_gusta'] != null
          ? (json['me_gusta'] as List<dynamic>)
              .map((meGusta) => MeGusta.fromJson(meGusta))
              .toList()
          : null,
    );
  }
}

//COMENTARIO
class ComentarioReview {
  final num commentId;
  final num reviewId;
  final num userId;
  final String username;
  final String content;
  final DateTime timestamp;

  ComentarioReview({
    required this.commentId,
    required this.reviewId,
    required this.userId,
    required this.content,
    required this.timestamp,
    required this.username,
  });

  factory ComentarioReview.fromJson(Map<String, dynamic> json) {
    return ComentarioReview(
      commentId: json['comment_id'] as num,
      reviewId: json['review_id'] as num,
      userId: json['user_id'] as num,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      username: json['username'] as String,
    );
  }
}

//ME GUSTA

class MeGusta {
  final num likedId;
  final num reviewId;
  final num userId;

  MeGusta({
    required this.likedId,
    required this.reviewId,
    required this.userId,
  });

  factory MeGusta.fromJson(Map<String, dynamic> json) {
    return MeGusta(
      likedId: json['liked_id'] as num,
      reviewId: json['review_id'] as num,
      userId: json['user_id'] as num,
    );
  }
}
