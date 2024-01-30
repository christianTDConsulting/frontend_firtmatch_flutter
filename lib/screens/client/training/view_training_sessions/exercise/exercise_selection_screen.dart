import 'package:fit_match/models/ejercicios.dart';
import 'package:fit_match/models/user.dart';
import 'package:fit_match/services/sesion_entrenamientos_service.dart';
import 'package:fit_match/utils/colors.dart';
import 'package:fit_match/utils/dimensions.dart';
import 'package:flutter/material.dart';

class ExecriseSelectionScreen extends StatefulWidget {
  final User user;

  const ExecriseSelectionScreen({super.key, required this.user});
  @override
  _ExecriseSelectionScreen createState() => _ExecriseSelectionScreen();
}

class _ExecriseSelectionScreen extends State<ExecriseSelectionScreen> {
  bool _isLoading = false;
  int _currentPage = 1;
  bool _hasMore = true;
  int _pageSize = 20;

  final ScrollController _scrollController = ScrollController();

  List<Ejercicios> exercises = [];
  List<GrupoMuscular> muscleGroups = [];
  List<Equipment> equipment = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMoreExercisesOnScroll);
    _loadExercises();
    _initMuscleGroups();
    _initEquipment();
  }

  void _loadMoreExercisesOnScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (_hasMore && !_isLoading) {
        _loadExercises();
      }
    }
  }

  void _loadExercises() async {
    // Si no hay más posts o ya está cargando, retorna.
    if (!_hasMore || _isLoading) return;

    // Inicia la carga de posts.
    _setLoadingState(true);

    try {
      // Obtener ejercicios.
      List<Ejercicios> exercises = await EjerciciosMethods().getAllEjercicios(
          userId: widget.user.user_id, page: _currentPage, pageSize: _pageSize);
      if (exercises.isEmpty) {
        setState(() {
          _hasMore = false;
        });
      }
      // Actualizar la lista de posts y el estado si el componente sigue montado.
      else if (mounted) {
        _updateExerciseList(exercises);
      }
    } catch (e) {
      print(e);
    } finally {
      // Finalmente, asegura que se actualice el estado de carga.
      if (mounted) {
        _setLoadingState(false);
      }
    }
  }

  void _updateExerciseList(List<Ejercicios> newExecises) {
    setState(() {
      _currentPage++;
      exercises.addAll(newExecises);
    });
  }

  void _initMuscleGroups() async {}

  void _initEquipment() async {}

  void _navigateBack() {
    Navigator.pop(context);
  }

  void _setLoadingState(bool loading) {
    setState(() => _isLoading = loading);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ejercicios'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navega a la pantalla de creación de ejercicios
            },
          )
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding:
                const EdgeInsets.only(bottom: 80.0), // Espacio para los botones
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildFiltros(),
                _buildEjerciciosList(),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildPersistentFooterButtons(width),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltros() {
    return Container();
  }

  Widget _buildEjerciciosList() {
    return ListView.builder(
      shrinkWrap: true,
      controller: _scrollController,
      itemCount: exercises.length + 1,
      itemBuilder: (context, index) {
        if (index < exercises.length) {
          return _buildExerciseItem(exercises[index]);
        } else {
          return _isLoading ? CircularProgressIndicator() : Container();
        }
      },
    );
  }

  Widget _buildExerciseItem(Ejercicios ejercicio) {
    return Card(
      child: ListTile(
        title: Text(ejercicio.name),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                // Acción al presionar el icono de información
              },
            ),
          ],
        ),
        onTap: () {
          // Muestra información sobre el ejercicio o realiza alguna acción
        },
      ),
    );
  }

  Widget _buildPersistentFooterButtons(num width) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () {
              // Agrega como super set
            },
            child: Text(
              'Añadir como super set',
              style: const TextStyle(fontSize: 12),
              textScaler: width < webScreenSize
                  ? const TextScaler.linear(1)
                  : const TextScaler.linear(1.2),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Agrega individualmente
            },
            child: Text(
              'Añadir individualmente',
              style: const TextStyle(fontSize: 12),
              textScaler: width < webScreenSize
                  ? const TextScaler.linear(1)
                  : const TextScaler.linear(1.2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return Container();
  }
}


/*
 return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar por nombre de ejercicio',
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                // Actualiza la lista de ejercicios según la búsqueda
              },
            ),
          ),
          DropdownButton<String>(
            value: muscleGroupFilter,
            onChanged: (String? newValue) {
              setState(() {
                muscleGroupFilter = newValue!;
                // Actualiza la lista de ejercicios según el filtro de grupo muscular
              });
            },
            items: <String>[
              'Todos los grupos musculares',
              'Pecho',
              'Espalda',
              // Añade más grupos musculares aquí
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          DropdownButton<String>(
            value: equipmentFilter,
            onChanged: (String? newValue) {
              setState(() {
                equipmentFilter = newValue!;
                // Actualiza la lista de ejercicios según el filtro de equipamiento
              });
            },
            items: <String>[
              'Todo el equipamiento',
              'Pesas',
              'Máquina',
              // Añade más opciones de equipamiento aquí
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                final exercise = exercises[index];
                return ListTile(
                  title: Text(exercise.name),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.check_circle,
                      color: blueColor,
                    ),
                    onPressed: () {
                      setState(() {
                        //isSelected
                      });
                    },
                  ),
                  onTap: () {
                    // Muestra información sobre el ejercicio o realiza alguna acción
                  },
                );
              },
            ),
          ),
        ],
      ),
      */