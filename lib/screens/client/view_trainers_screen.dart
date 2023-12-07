import 'package:fit_match/models/post.dart';
import 'package:fit_match/providers/get_jwt_token.dart';
import 'package:fit_match/services/usuario_service.dart';
import 'package:fit_match/utils/colors.dart';
import 'package:fit_match/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:fit_match/services/trainer_posts_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:fit_match/widget/post_card/post_card.dart';

class ViewTrainersScreen extends StatefulWidget {
  const ViewTrainersScreen({Key? key}) : super(key: key);

  @override
  State<ViewTrainersScreen> createState() => _ViewTrainersScreenState();
}

class _ViewTrainersScreenState extends State<ViewTrainersScreen> {
  List<Post> posts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    initializePosts();
  }

  void initializePosts() async {
    setState(() {
      isLoading = true; // Comienza a mostrar el indicador de carga
    });

    try {
      String? token = await getToken();
      if (token != null) {
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        var newPosts = await getAllPosts(decodedToken['user']['user_id']);

        // Cargar los nombres de usuario para cada review
        for (var post in newPosts) {
          for (var review in post.reviews) {
            String username = await getUsernameByClientId(review.clientId);
            review.username =
                username; // Asumiendo que tienes un campo para almacenar el nombre de usuario en Review
          }
        }

        setState(() {
          posts = newPosts;
          isLoading = false; // Oculta el indicador de carga
        });
      } else {
        print('No se encontró el token');
      }
    } catch (e) {
      print('Error al cargar los posts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (isLoading) {
      // Muestra un indicador de carga mientras los datos están cargando
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      backgroundColor:
          width > webScreenSize ? webBackgroundColor : mobileBackgroundColor,
      appBar: AppBar(
          backgroundColor: width > webScreenSize
              ? webBackgroundColor
              : mobileBackgroundColor),
      body: Container(
        color:
            width > webScreenSize ? webBackgroundColor : mobileBackgroundColor,
        child: Padding(
          padding:
              const EdgeInsets.only(top: 8.0), // Espacio entre AppBar y el Body
          child: ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0), // Espacio entre las tarjetas
                child: PostCard(post: posts[index]),
              );
            },
          ),
        ),
      ),
    );
  }
}
