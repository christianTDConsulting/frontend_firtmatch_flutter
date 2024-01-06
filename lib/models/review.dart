class Review {
  final int reviewId;
  final int userId;
  final int templateId;
  final num rating;
  final String reviewContent;
  final DateTime timestamp;
  final String username;
  final List<ComentarioReview> comentarioReview;
  final List<MeGusta> meGusta;

  Review({
    required this.reviewId,
    required this.userId,
    required this.templateId,
    required this.rating,
    required this.reviewContent,
    required this.timestamp,
    required this.username,
    required this.comentarioReview,
    required this.meGusta,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      reviewId: json['review_id'] as int,
      userId: json['user_id'] as int,
      templateId: json['template_id'] as int,
      rating: json['rating'] as num,
      reviewContent: json['review_content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      username: json['usuario']['username'] as String,
      comentarioReview: (json['comentario_review'] as List)
          .map((comentarioJson) => ComentarioReview.fromJson(comentarioJson))
          .toList(),
      meGusta: (json['me_gusta'] as List)
          .map((meGustaJson) => MeGusta.fromJson(meGustaJson))
          .toList(),
    );
  }
}

//COMENTARIO
class ComentarioReview {
  final int commentId;
  final int reviewId;
  final num userId;
  final String username;
  final String content;
  final DateTime timestamp;
  final int? commentResponded;

  ComentarioReview({
    required this.commentId,
    required this.reviewId,
    required this.userId,
    required this.content,
    required this.timestamp,
    required this.username,
    this.commentResponded,
  });

  factory ComentarioReview.fromJson(Map<String, dynamic> json) {
    return ComentarioReview(
      commentId: json['comment_id'] as int,
      reviewId: json['review_id'] as int,
      userId: json['user_id'] as num,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      username: json['username'] as String,
      commentResponded: json['comment_responded'],
    );
  }
}

//ME GUSTA

class MeGusta {
  final int likedId;
  final int reviewId;
  final int userId;

  MeGusta({
    required this.likedId,
    required this.reviewId,
    required this.userId,
  });

  factory MeGusta.fromJson(Map<String, dynamic> json) {
    return MeGusta(
      likedId: json['liked_id'] as int,
      reviewId: json['review_id'] as int,
      userId: json['user_id'] as int,
    );
  }
}
