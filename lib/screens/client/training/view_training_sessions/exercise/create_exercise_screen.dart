import 'package:fit_match/models/ejercicios.dart';
import 'package:fit_match/models/user.dart';
import 'package:fit_match/services/sesion_entrenamientos_service.dart';
import 'package:fit_match/widget/my_youtube_player.dart';
import 'package:flutter/material.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CreateExerciseScreen extends StatefulWidget {
  final User user;
  const CreateExerciseScreen({
    super.key,
    required this.user,
  });
  @override
  CreateExerciseState createState() => CreateExerciseState();
}

class CreateExerciseState extends State<CreateExerciseScreen> {
  final _formKey = GlobalKey<FormState>(); // Para validaciones de formulario
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();

  List<GrupoMuscular> muscleGroups = [];
  GrupoMuscular? selectedMuscleGroup;

  List<Equipment> equipment = [];
  Equipment? selectedEquipment;

  String? _previewImageUrl;
  // YoutubePlayerController? _youtubePlayerController;

  @override
  void initState() {
    super.initState();
    _initMuscleGroups();
    _initEquipment();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _urlController.dispose();
    // _youtubePlayerController?.dispose();

    super.dispose();
  }

  // void _updateYoutubePlayerController(String url) {
  //   final videoId = YoutubePlayer.convertUrlToId(url);
  //   if (videoId != null) {
  //     _youtubePlayerController?.dispose();
  //     _youtubePlayerController = YoutubePlayerController(
  //       initialVideoId: videoId,
  //       flags: const YoutubePlayerFlags(
  //         autoPlay: false,
  //         mute: false,
  //       ),
  //     );
  //     setState(() {});
  //   }
  // }

  void _initMuscleGroups() async {
    List<GrupoMuscular> groups =
        await EjerciciosMethods().getGruposMusculares();
    setState(() {
      muscleGroups = groups;
    });
  }

  void _initEquipment() async {
    List<Equipment> mats = await EjerciciosMethods().getMaterial();
    setState(() {
      equipment = mats;
    });
  }

  Future<void> _createExercise() async {
    if (_formKey.currentState!.validate()) {}

    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear ejercicio'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration:
                    const InputDecoration(labelText: 'Nombre del ejercicio'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el nombre del ejercicio';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                maxLines: 3,
              ),
              DropdownButtonFormField<GrupoMuscular>(
                decoration: const InputDecoration(labelText: 'Grupo Muscular'),
                items: muscleGroups
                    .map((group) => DropdownMenuItem(
                          value: group,
                          child: Text(group.name ?? ''),
                        ))
                    .toList(),
                onChanged: (GrupoMuscular? newValue) {
                  if (newValue != null &&
                      newValue.iconName != null &&
                      newValue.iconName!.isNotEmpty) {
                    setState(() {
                      selectedMuscleGroup = newValue;
                      _previewImageUrl = newValue.iconName != null
                          ? 'assets/images/muscle_groups/${newValue.iconName}.png'
                          : null;
                    });
                  }
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor selecciona un grupo muscular';
                  }
                  return null;
                },
              ),
              if (_previewImageUrl != null) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Image.asset(_previewImageUrl!, height: 100),
                ),
              ],
              DropdownButtonFormField<Equipment>(
                decoration: const InputDecoration(labelText: 'Material'),
                items: equipment
                    .map((mat) => DropdownMenuItem(
                          value: mat,
                          child: Text(mat.name),
                        ))
                    .toList(),
                onChanged: (Equipment? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedEquipment = newValue;
                    });
                  }
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor selecciona el material usado';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _urlController,
                decoration:
                    const InputDecoration(labelText: 'URL del Video (YouTube)'),
                onChanged: (value) {
                  setState(() {
                    // Esto fuerza a que el widget se reconstruya y revise la condición de si mostrar o no el reproductor.
                  });
                },
                validator: (value) {
                  if (value != null &&
                      value.isNotEmpty &&
                      !Uri.parse(value).isAbsolute) {
                    return 'Por favor ingresa una URL válida';
                  }
                  return null;
                },
              ),
              if (_urlController.text.isNotEmpty &&
                  _urlController.text.contains("youtube.com/watch?v=")) ...[
                Center(child: MyYoutubePlayer(uri: _urlController.text)),
              ],
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _createExercise();
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Guardado'),
                        content:
                            Text('Ejercicio ${_nameController.text} guardado.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: const Center(child: Text('Guardar')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
