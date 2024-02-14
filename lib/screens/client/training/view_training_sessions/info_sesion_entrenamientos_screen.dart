import 'package:fit_match/models/ejercicios.dart';
import 'package:fit_match/models/sesion_entrenamiento.dart';
import 'package:fit_match/models/user.dart';
import 'package:fit_match/screens/client/training/view_training_sessions/exercise/exercise_selection_screen.dart';
import 'package:fit_match/services/sesion_entrenamientos_service.dart';
import 'package:fit_match/utils/utils.dart';
import 'package:fit_match/widget/custom_button.dart';
import 'package:fit_match/widget/exercise_card/exercise_card.dart';
import 'package:flutter/material.dart';

class InfoSesionEntrenamientoScreen extends StatefulWidget {
  final int templateId;
  final User user;
  final int sessionId;

  const InfoSesionEntrenamientoScreen({
    super.key,
    required this.sessionId,
    required this.templateId,
    required this.user,
  });
  @override
  _InfoSesionEntrenamientoScreen createState() =>
      _InfoSesionEntrenamientoScreen();
}

class _InfoSesionEntrenamientoScreen
    extends State<InfoSesionEntrenamientoScreen> {
  SesionEntrenamiento editingSesion = SesionEntrenamiento(
    sessionId: 0,
    templateId: 0,
    sessionName: '',
    order: 0,
    sessionDate: DateTime.now(),
  );

  List<EjerciciosDetalladosAgrupados> _exercises = [];
  List<TipoDeRegistro> _registerTypes = [];

  bool isLoading = true;
  final TextEditingController _tituloContoller = TextEditingController();
  final TextEditingController _instruccionesContoller = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _tituloContoller.dispose();
    _instruccionesContoller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initData();
    _initRegisterType();
  }

  void _setLoadingState(bool loading) {
    setState(() => isLoading = loading);
  }

  void _initRegisterType() async {
    List<TipoDeRegistro> groups =
        await EjerciciosMethods().getTiposDeRegistro();
    setState(() {
      _registerTypes = groups;
    });
  }

  Future<void> initData() async {
    try {
      _setLoadingState(true);
      SesionEntrenamiento editingSesion = await SesionEntrenamientoMethods()
          .getSesionesEntrenamientoBySessionId(widget.sessionId);
      setState(() {
        this.editingSesion = editingSesion;
      });

      _initExercises();

      _tituloContoller.text = editingSesion.sessionName;
      _instruccionesContoller.text = editingSesion.notes ?? '';
    } catch (e) {
      print(e);
    } finally {
      _setLoadingState(false);
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

  void _initExercises() async {
    try {
      List<EjerciciosDetalladosAgrupados> exercises =
          await EjercicioDetalladosAgrupadoMethods()
              .getEjerciciosDetalladosAgrupadosBySesionId(widget.sessionId);

      if (exercises.isNotEmpty) {
        setState(() {
          _exercises = exercises;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _addExercise() async {
    // Ajusta el tipo esperado de result para que coincida con lo que se devuelve desde ExerciseSelectionScreen
    final List<EjerciciosDetalladosAgrupados>? result =
        await Navigator.of(context).push<List<EjerciciosDetalladosAgrupados>>(
      MaterialPageRoute(
        builder: (context) => ExecriseSelectionScreen(
          user: widget.user,
          sessionId: widget.sessionId,
          GroupedDetailedExerciseOrder: _exercises.length,
        ),
      ),
    );

    // Comprobar si el resultado no es nulo y tiene elementos
    if (result != null && result.isNotEmpty) {
      setState(() {
        // Añade todos los EjerciciosDetalladosAgrupados obtenidos al estado actual de _exercises
        _exercises.addAll(result);
      });
    }
  }

  // Future<void> _addExercise() async {
  //   Navigator.of(context)
  //       .push(
  //     MaterialPageRoute(
  //       builder: (context) => ExecriseSelectionScreen(
  //           user: widget.user,
  //           sessionId: widget.sessionId,
  //           GroupedDetailedExerciseOrder: _exercises.length),
  //     ),
  //   )
  //       .then((result) {
  //     if (result == true) {
  //       try {
  //         _setLoadingState(true);
  //         _initExercises();
  //       } catch (e) {
  //         print(e);
  //       } finally {
  //         _setLoadingState(false);
  //       }
  //     }
  //   });
  // }

  void _saveEntrenamiento() async {
    if (_formKey.currentState!.validate()) {
      try {
        SesionEntrenamiento sesion = SesionEntrenamiento(
          sessionId: editingSesion.sessionId,
          templateId: editingSesion.templateId,
          sessionName: _tituloContoller.text,
          notes: _instruccionesContoller.text,
          sessionDate: editingSesion.sessionDate,
          order: editingSesion.order,
          ejerciciosDetalladosAgrupados: _exercises,
        );

        int response =
            await SesionEntrenamientoMethods().editSesionEntrenamiento(sesion);

        if (response == 200) {
          showToast(
              context, 'Sesión de Entrenamiento actualizada correctamente');
          _navigateBack(context, reload: true);
        }
      } catch (e) {
        showToast(context, e.toString(), exitoso: false);
      }
    }
  }

  void _navigateBack(BuildContext context, {bool reload = false}) {
    Navigator.pop(context, reload);
  }

  _onAddSet(int index) {
    print("add set " + index.toString());
  }

  _onDeleteEjercicioDetalladoAgrupado(int groupIndex, int exerciseIndex) {
    int? deleteId =
        _exercises[groupIndex].ejerciciosDetallados[exerciseIndex].exerciseId;
    if (deleteId != null) {
      setState(() {
        // Eliminar el ejercicio detallado del grupo
        _exercises[groupIndex].ejerciciosDetallados.removeAt(exerciseIndex);

        // Corregir el orden de los ejercicios
        for (int i = 0;
            i < _exercises[groupIndex].ejerciciosDetallados.length;
            i++) {
          _exercises[groupIndex].ejerciciosDetallados[i].order = i + 1;
        }
        // Eliminar el grupo si no hay ejercicios
        if (_exercises[groupIndex].ejerciciosDetallados.isEmpty) {
          _exercises.removeAt(groupIndex);
          // Corregir el orden de los grupos
          for (int i = 0; i < _exercises.length; i++) {
            _exercises[i].order = i + 1;
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Sesión de Entrenamiento'),
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
                                _buildTitle(context),
                                const SizedBox(height: 16),
                                _buildInstructions(context),
                                const SizedBox(height: 16),
                                _buildEntrenamientosList(context),
                                const SizedBox(height: 16),
                                _buildNewExerciseButton(context),
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
            return ExerciseCard(
              ejercicioDetalladoAgrupado: _exercises[index],
              registerTypes: _registerTypes,
              index: index,
              onAddSet: ((index) => _onAddSet(index)),
              onDeleteEjercicioDetalladoAgrupado:
                  ((groupIndex, exerciseIndex) =>
                      _onDeleteEjercicioDetalladoAgrupado(
                          groupIndex, exerciseIndex)),
            );
          });
    }
  }

  Widget _buildTitle(BuildContext context) {
    return TextFormField(
      controller: _tituloContoller,
      decoration: const InputDecoration(
        labelText: 'Nombre de la sesión de entrenamiento',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, escribe el nombre de tu sesión de entrenamiento';
        }
        return null;
      },
    );
  }

  Widget _buildInstructions(BuildContext context) {
    return TextFormField(
      controller: _instruccionesContoller,
      decoration: const InputDecoration(
        labelText: 'Instrucciones de la sesión de entrenamiento',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildNewExerciseButton(BuildContext context) {
    return CustomButton(onTap: _addExercise, text: 'Añadir Ejercicio');
  }

  Widget _buildSaveButton(BuildContext context) {
    return CustomButton(
        onTap: _saveEntrenamiento, text: 'Guardar sesión de entrenamiento');
  }
}
