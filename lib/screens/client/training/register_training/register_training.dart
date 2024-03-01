import 'package:fit_match/models/ejercicios.dart';
import 'package:fit_match/models/sesion_entrenamiento.dart';
import 'package:fit_match/models/user.dart';
import 'package:fit_match/services/registro_service.dart';
import 'package:fit_match/services/sesion_entrenamientos_service.dart';
import 'package:fit_match/widget/custom_button.dart';
import 'package:fit_match/widget/exercise_card/register_card.dart';
import 'package:fit_match/widget/expandable_text.dart';
import 'package:flutter/material.dart';

class RegisterTrainingScreen extends StatefulWidget {
  final User user;
  final int sessionId;

  const RegisterTrainingScreen({
    super.key,
    required this.sessionId,
    required this.user,
  });
  @override
  _RegisterTrainingScreen createState() => _RegisterTrainingScreen();
}

class _RegisterTrainingScreen extends State<RegisterTrainingScreen> {
  SesionEntrenamiento existingSession = SesionEntrenamiento(
    sessionId: 0,
    templateId: 0,
    sessionName: 'Nueva sesión de entrenamiento',
    order: 0,
    sessionDate: DateTime.now(),
  );

  void _saveEntrenamiento() {}

  List<EjerciciosDetalladosAgrupados> _exercises = [];

  bool isLoading = true;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _setLoadingState(bool loading) {
    setState(() => isLoading = loading);
  }

  Widget _buildSectionContent(String content) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
      child: ExpandableText(text: content),
    );
  }

  bool _existeRegistroActivo(SesionEntrenamiento session) {
    if (session.registros == null || session.registros!.isEmpty) {
      return false;
    }

    return session.registros!.any((element) => !element.finished);
  }

  _initSet(SetsEjerciciosEntrada setsEjerciciosEntrada) {}

  Future<void> _initData() async {
    setState(() => isLoading = true);
    SesionEntrenamiento session;
    try {
      session = await RegistroMethods().getSessionEntrenamientoWithRegistros(
          widget.user.user_id as int, widget.sessionId);
    } catch (e) {
      print("Error en getSessionEntrenamientoWithRegistros: $e");
      setState(() => isLoading = false);
      return;
    }

    try {
      if (!_existeRegistroActivo(session)) {
        var newRegistro = await RegistroMethods().createRegisterSession(
            widget.user.user_id as int, session.sessionId);
        session.registros ??= [];
        session.registros!.add(newRegistro);
      }
    } catch (e) {
      print("Error en createRegisterSession: $e");
      setState(() => isLoading = false);
      return;
    }
    _initExercises();

    setState(() {
      existingSession = session;
      isLoading = false;
    });
  }

  Future<void> _initExercises() async {
    try {
      var exercises = await EjercicioDetalladosAgrupadoMethods()
          .getEjerciciosDetalladosAgrupadosBySesionId(widget.sessionId);
      setState(() => _exercises = exercises);
    } catch (e) {
      print(e);
    }
  }

  Future<bool> _onWillPop() async {
    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Estás seguro?'),
        content: const Text('Perderás todo el progreso.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(
                false), // Esto cierra el cuadro de diálogo devolviendo 'false'.
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(
                  true); // Esto cierra el cuadro de diálogo devolviendo 'true'.
            },
            child: const Text('Sí'),
          ),
        ],
      ),
    );

    // Si shouldPop es true, entonces navega hacia atrás.
    if (shouldPop ?? false) {
      _navigateBack(context);
    }

    return Future.value(
        false); // Evita que el botón de retroceso cierre la pantalla automáticamente.
  }

  void _navigateBack(BuildContext context, {bool reload = false}) {
    Navigator.pop(context, reload);
  }

  void _onAddSet(int groupIndex, int exerciseIndex) {}

  void _onDeleteSet(int groupIndex, int exerciseIndex, int setIndex) {}

  void _updateSet(int groupIndex, int exerciseIndex, int setIndex,
      SetsEjerciciosEntrada set) {}

  void _onEditNote(int groupIndex, int exerciseIndex, String note) {}

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Scaffold(
          appBar: AppBar(
            title: Text(existingSession.sessionName),
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () async {
                await _onWillPop();
              },
            ),
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Center(
                  child: Container(
                    alignment: Alignment.topCenter,
                    constraints: const BoxConstraints(maxWidth: 1000),
                    child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(height: 16),
                                _buildInstructionsField(context),
                                const SizedBox(height: 16),
                                _buildEntrenamientosList(context),
                                const SizedBox(height: 16),
                                _buildSaveButton(context),
                              ]),
                        )),
                  ),
                )),
    );
  }

  Widget _buildEntrenamientosList(BuildContext context) {
    if (_exercises.isEmpty) {
      return const Text(
        'No hay ejercicios todavía',
        style: TextStyle(fontSize: 18),
      );
    } else {
      return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _exercises.length,
          itemBuilder: (context, index) {
            return RegisterCard(
              ejercicioDetalladoAgrupado: _exercises[index],
              index: index,
              // onAddSet: (groupIndex, exerciseIndex) =>
              //     _onAddSet(groupIndex, exerciseIndex),
              // onDeleteSet: (groupIndex, exerciseIndex, setIndex) =>
              //     _onDeleteSet(groupIndex, exerciseIndex, setIndex),
              // onUpdateSet: (groupIndex, exerciseIndex, setIndex, set) =>
              //     _updateSet(groupIndex, exerciseIndex, setIndex, set),
              // initSet: (setsEjerciciosEntrada) =>
              //     _initSet(setsEjerciciosEntrada),
            );
          });
    }
  }

  Widget _buildInstructionsField(BuildContext context) {
    return _buildSectionContent(existingSession.notes ?? '');
  }

  Widget _buildSaveButton(BuildContext context) {
    return CustomButton(onTap: _saveEntrenamiento, text: 'Terminar');
  }
}
