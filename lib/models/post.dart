import 'package:fit_match/models/review.dart';

class PlantillaPost {
  final int templateId;
  final int userId;
  final String templateName;
  final String? description;
  final String? picture;
  final List<Review> reviews;
  final List<Etiqueta> etiquetas;

  PlantillaPost({
    required this.templateId,
    required this.userId,
    required this.templateName,
    this.description,
    this.picture,
    required this.reviews,
    required this.etiquetas,
  });

  factory PlantillaPost.fromJson(Map<String, dynamic> json) {
    return PlantillaPost(
      templateId: json['template_id'] as int,
      userId: json['user_id'] as int,
      templateName: json['template_name'] as String,
      description: json['description'] as String?,
      picture: json['picture'] as String?,
      reviews: (json['reviews'] as List)
          .map((reviewJson) => Review.fromJson(reviewJson))
          .toList(),
      etiquetas: (json['etiquetas'] as List)
          .map((etiquetaJson) => Etiqueta.fromJson(etiquetaJson))
          .toList(),
    );
  }
}

class Etiqueta {
  String? objetivos;
  String? experiencia;
  String? intereses;

  Etiqueta({this.objetivos, this.experiencia, this.intereses});

  factory Etiqueta.fromJson(Map<String, dynamic> json) {
    return Etiqueta(
      objetivos: json['objetivos'],
      experiencia: json['experiencia'],
      intereses: json['intereses'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'objetivos': objetivos,
      'experiencia': experiencia,
      'intereses': intereses,
    };
  }
}
