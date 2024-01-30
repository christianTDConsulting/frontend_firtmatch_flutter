import 'dart:typed_data';
import 'package:fit_match/models/post.dart';
import 'package:fit_match/models/user.dart';
import 'package:fit_match/responsive/responsive_layout_screen.dart';
import 'package:fit_match/screens/client/training/view_training_sessions/view_sesion_entrenamientos_screen.dart';
import 'package:fit_match/services/plantilla_posts_service.dart';
import 'package:fit_match/utils/utils.dart';
import 'package:fit_match/widget/custom_button.dart';

import 'package:fit_match/widget/preferences.dart';
import 'package:fit_match/widget/preferences_section.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class CreateProgramScreen extends StatefulWidget {
  final User user;
  final PlantillaPost? editingTemplate; //editar
  const CreateProgramScreen(
      {super.key, required this.user, this.editingTemplate});

  @override
  _CreateProgramScreenState createState() => _CreateProgramScreenState();
}

class _CreateProgramScreenState extends State<CreateProgramScreen> {
  final _formKey = GlobalKey<FormState>();
  final _programNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  // Etiquetas
  Map<String, bool> selectedObjectives = {};
  Map<String, bool> selectedInterests = {};
  String selectedExperience = 'Principiante';
  String selectedEquipment = 'Gimnasio completo';
  String selectedDuration = '30 minutos';

  Uint8List? _thumbnailImage;

  @override
  void dispose() {
    _programNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (widget.editingTemplate != null) {
      // Inicializar los controladores de texto
      _programNameController.text = widget.editingTemplate!.templateName;
      _descriptionController.text = widget.editingTemplate!.description ?? '';

      // Cargar imagen desde Cloudinary
      _loadImage(widget.editingTemplate!.picture);

      // Inicializar preferencias
      _initializePreferences(widget.editingTemplate!);
    }
  }

  Future<void> _loadImage(String? imageUrl) async {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      try {
        final response = await http.get(Uri.parse(imageUrl));
        if (response.statusCode == 200) {
          setState(() {
            _thumbnailImage = response.bodyBytes;
          });
        } else {
          // Manejar el caso en que la imagen no se pudo cargar (p.ej. mostrar un error)
        }
      } catch (e) {
        // Manejar excepciones
      }
    }
  }

  void _initializePreferences(PlantillaPost template) {
    var sectionsMap = template.getSectionsMap();

    // Reconstruir CheckboxPreference para Objetivos
    objetivosOptions = objetivosOptions.map((option) {
      return CheckboxPreference(
        title: option.title,
        value: sectionsMap['Objetivos'].contains(option.title),
      );
    }).toList();

    // Reconstruir CheckboxPreference para Intereses
    interesesOptions = interesesOptions.map((option) {
      return CheckboxPreference(
        title: option.title,
        value: sectionsMap['Disciplinas'].contains(option.title),
      );
    }).toList();

    // Reconstruir RadioPreference para Experiencia
    experienciaOptions = experienciaOptions.map((option) {
      return RadioPreference(
        title: option.title,
        value: option.value,
      );
    }).toList();

    // Reconstruir RadioPreference para Equipamiento
    equipmentOptions = equipmentOptions.map((option) {
      return RadioPreference(
        title: option.title,
        value: option.value,
      ); // Igual que con experiencia
    }).toList();

    // Reconstruir RadioPreference para Duración
    durationOptions = durationOptions.map((option) {
      return RadioPreference(
        title: option.title,
        value: option.value,
      ); // Igual que con experiencia
    }).toList();

    // Actualizar el valor inicial para los grupos de RadioPreference
    selectedExperience = sectionsMap['Experiencia'].isNotEmpty
        ? sectionsMap['Experiencia'][0]
        : experienciaOptions[0].value;
    selectedEquipment = sectionsMap['Equipamiento'].isNotEmpty
        ? sectionsMap['Equipamiento'][0]
        : equipmentOptions[0].value;
    selectedDuration = sectionsMap['Duración'].isNotEmpty
        ? sectionsMap['Duración'][0]
        : durationOptions[0].value;

    // Para Objetivos
    selectedObjectives = {
      for (var option in objetivosOptions)
        option.title: sectionsMap['Objetivos'].contains(option.title)
    };

    // Para Intereses
    selectedInterests = {
      for (var option in interesesOptions)
        option.title: sectionsMap['Disciplinas'].contains(option.title)
    };

    // Para Experiencia
    if (sectionsMap['Experiencia'].isNotEmpty) {
      selectedExperience = sectionsMap['Experiencia'][0];
    } else {
      selectedExperience =
          experienciaOptions[0].value; // O un valor por defecto
    }

    // Para Equipamiento
    if (sectionsMap['Equipamiento'].isNotEmpty) {
      selectedEquipment = sectionsMap['Equipamiento'][0];
    } else {
      selectedEquipment = equipmentOptions[0].value; // O un valor por defecto
    }

    // Para Duración
    if (sectionsMap['Duración'].isNotEmpty) {
      selectedDuration = sectionsMap['Duración'][0];
    } else {
      selectedDuration = durationOptions[0].value; // O un valor por defecto
    }
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Estás seguro?'),
            content: const Text('Perderás todo el progreso.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => navigateBack(),
                child: const Text('Sí'),
              ),
            ],
          ),
        )) ??
        false;
  }

  Future<void> _selectImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      Uint8List im = await image.readAsBytes();
      setState(() {
        _thumbnailImage = im;
      });
    }
  }

  void _submitForm() async {
    _setLoadingState(true);

    try {
      if (_isFormValid()) {
        await _processFormSubmission();
      }
    } catch (e) {
      print(e);
      showToast(context, 'Ha ocurrido un error. Por favor, intenta de nuevo.',
          exitoso: false);
    } finally {
      _setLoadingState(false);
    }
  }

  bool _isFormValid() {
    if (!_formKey.currentState!.validate()) {
      return false;
    }

    bool hasSelectedObjective = selectedObjectives.containsValue(true);
    bool hasSelectedInterest = selectedInterests.containsValue(true);

    if (!hasSelectedObjective || !hasSelectedInterest) {
      showToast(
          context, 'Por favor, selecciona al menos un objetivo y un interés.');
      return false;
    }

    return true;
  }

  Future<void> _processFormSubmission() async {
    final programName = _programNameController.text;
    final description = _descriptionController.text;
    final thumbnailImage = _thumbnailImage;

    List<Etiqueta> etiquetas = _createEtiquetas();

    if (widget.editingTemplate != null) {
      //if (_hasChanges()) {
      await _updateTemplate(
          programName, description, thumbnailImage, etiquetas);
      //}
    } else {
      await _createTemplate(
          programName, description, thumbnailImage, etiquetas);
    }
  }

  /*bool _hasChanges() {
    bool hasChanges = _programNameController.text !=
            widget.editingTemplate?.templateName ||
        _descriptionController.text != widget.editingTemplate?.description ||
        _thumbnailImage != null;

    hasChanges = hasChanges || _hasEtiquetasChanged();

    return hasChanges;
  }*/

  //bool _hasEtiquetasChanged() {}

  List<Etiqueta> _createEtiquetas() {
    List<Etiqueta> etiquetas = [];

    etiquetas.addAll(_createEtiquetasFromMap(selectedObjectives, 'objectives'));
    etiquetas.addAll(_createEtiquetasFromMap(selectedInterests, 'interests'));

    etiquetas.add(Etiqueta(experience: selectedExperience));
    etiquetas.add(Etiqueta(equipment: selectedEquipment));

    return etiquetas;
  }

  Future<void> _updateTemplate(String programName, String description,
      dynamic thumbnailImage, List<Etiqueta> etiquetas) async {
    PlantillaPost plantillaActualizada = PlantillaPost(
        templateId: widget.editingTemplate!.templateId,
        userId: widget.editingTemplate!.userId,
        templateName: programName,
        description: description,
        public: false,
        hidden: false,
        etiquetas: etiquetas);

    int templateId = widget.editingTemplate!.templateId;
    if (plantillaActualizada != widget.editingTemplate) {
      templateId = await PlantillaPostsMethods()
          .updatePlantilla(plantillaActualizada, thumbnailImage);
    }

    navigateNext(templateId);
  }

  Future<void> _createTemplate(String programName, String description,
      dynamic thumbnailImage, List<Etiqueta> etiquetas) async {
    int templateId = await PlantillaPostsMethods().postPlantilla(
        userId: widget.user.user_id,
        templateName: programName,
        description: description,
        picture: thumbnailImage,
        etiquetas: etiquetas);

    navigateNext(templateId);
  }

  List<Etiqueta> _createEtiquetasFromMap(Map map, String type) {
    return map.entries
        .where((element) => element.value)
        .map((e) => type == 'objectives'
            ? Etiqueta(objectives: e.key)
            : Etiqueta(interests: e.key))
        .toList();
  }

  void _setLoadingState(bool loading) {
    //print("loading: " + loading.toString());
    setState(() => _isLoading = loading);
  }

  void navigateBack() {
    //Navigator.of(context).pop();

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ResponsiveLayout(
        user: widget.user,
        initialPage: 3,
      ),
    ));
  }

  void navigateNext(int templateId) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ViewSesionEntrenamientoScreen(
        user: widget.user,
        templateId: templateId,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Nuevo Programa'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              if (await _onWillPop()) {
                navigateBack();
              }
            },
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildNameField(),
                const SizedBox(height: 16),
                buildDescriptionField(),
                const SizedBox(height: 16),
                buildImagePicker(),
                const SizedBox(height: 16),
                buildObjectivesSection(),
                buildInterestsSection(),
                buildExperienceSection(),
                buildEquipmentSection(),
                buildDurationSection(),
                buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildNameField() {
    return TextFormField(
      controller: _programNameController,
      decoration: const InputDecoration(
        labelText: '¿Cuál es el nombre de tu programa?',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, escribe el nombre de tu programa';
        }
        return null;
      },
    );
  }

  Widget buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      decoration: const InputDecoration(
        labelText: 'Escribe una descripción para tu programa*',
        border: OutlineInputBorder(),
      ),
      maxLines: 5,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor escribe una descripción*';
        }
        return null;
      },
    );
  }

  Widget buildImagePicker() {
    return Column(children: [
      const Text(
        'Selecciona una miniatura para la plantilla',
      ),
      const SizedBox(height: 8),
      Stack(
        children: [
          CircleAvatar(
            radius: 64,
            backgroundImage: _thumbnailImage != null
                ? MemoryImage(_thumbnailImage!)
                : Image.asset('assets/images/template_placeholder.png').image,
            backgroundColor: Colors.red,
          ),
          Positioned(
            left: 80,
            child: IconButton(
                onPressed: _selectImage, icon: const Icon(Icons.add_a_photo)),
          ),
        ],
      ),
    ]);
  }

  Widget buildObjectivesSection() {
    return SectionContainer(
      title: 'Objetivos del programa',
      child: PreferencesCheckboxesWidget(
        options: objetivosOptions,
        onSelectionChanged: (selection) {
          setState(() {
            selectedObjectives = selection;
          });
        },
      ),
    );
  }

  Widget buildInterestsSection() {
    return SectionContainer(
      title: 'Deportes o disciplinas usadas en la plantilla',
      child: PreferencesCheckboxesWidget(
        options: interesesOptions,
        onSelectionChanged: (selection) {
          setState(() {
            selectedInterests = selection;
          });
        },
      ),
    );
  }

  Widget buildExperienceSection() {
    return SectionContainer(
      title: 'Nivel recomendado para rutina de entrenamiento',
      child: PreferencesRadioButtonsWidget<String>(
        options: experienciaOptions,
        initialValue: selectedExperience,
        onSelectionChanged: (selection) {
          setState(() {
            selectedExperience = selection;
          });
        },
      ),
    );
  }

  Widget buildEquipmentSection() {
    return SectionContainer(
      title: 'Equipo que será necesario para realizar la rutina',
      child: PreferencesRadioButtonsWidget<String>(
        options: equipmentOptions,
        initialValue: selectedEquipment,
        onSelectionChanged: (selection) {
          setState(() {
            selectedEquipment = selection;
          });
        },
      ),
    );
  }

  Widget buildDurationSection() {
    return SectionContainer(
        title: 'Duración aproximada de las sesiones de entrenamiento',
        child: PreferencesRadioButtonsWidget<String>(
            options: durationOptions,
            initialValue: selectedDuration,
            onSelectionChanged: (selection) {
              setState(() {
                selectedDuration = selection;
              });
            }));
  }

  Widget buildSubmitButton() {
    return CustomButton(
      onTap: _submitForm,
      isLoading: _isLoading,
      text: 'Siguiente',
    );
  }
}
