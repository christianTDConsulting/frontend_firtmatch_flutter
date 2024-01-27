import 'package:fit_match/models/ejercicios.dart';
import 'package:fit_match/utils/colors.dart';
import 'package:flutter/material.dart';

class ExecriseSelectionScreen extends StatefulWidget {
  @override
  _ExecriseSelectionScreen createState() => _ExecriseSelectionScreen();
}

class _ExecriseSelectionScreen extends State<ExecriseSelectionScreen> {
  List<Ejercicios> exercises = [];
  String muscleGroupFilter = 'Todos los grupos musculares';
  String equipmentFilter = 'Todo el equipamiento';

  void _navigateBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
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
      body: Column(
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
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              // Agrega como super set
            },
            child: Icon(Icons.add),
            tooltip: 'Añadir como super set',
          ),
          SizedBox(width: 8),
          FloatingActionButton(
            onPressed: () {
              // Agrega individualmente
            },
            child: Icon(Icons.add),
            tooltip: 'Añadir individualmente',
          ),
        ],
      ),
    );
  }
}
