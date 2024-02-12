import 'package:fit_match/models/ejercicios.dart';
import 'package:fit_match/utils/dimensions.dart';

// import 'package:fit_match/widget/exercise_card/sets_list.dart';
import 'package:flutter/material.dart';

class ExerciseCard extends StatelessWidget {
  final EjerciciosDetalladosAgrupados ejercicioDetalladoAgrupado;
  final List<TipoDeRegistro> registerTypes;
  final int index;
  final Function(int) onAddSet;
  final Function(int, int) onDeleteEjercicioDetalladoAgrupado;

  const ExerciseCard({
    Key? key,
    required this.ejercicioDetalladoAgrupado,
    required this.registerTypes,
    required this.index,
    required this.onDeleteEjercicioDetalladoAgrupado,
    required this.onAddSet,
  }) : super(key: key);

  void _handleMenuItemSelected(
      String value, int groupIndex, int exerciseIndex) {
    switch (value) {
      case 'reordenar':
        break;
      case 'nota':
        break;
      case 'eliminar':
        onDeleteEjercicioDetalladoAgrupado(groupIndex, exerciseIndex);
        break;
    }
  }

  String _getExerciseLetter(int index) {
    return String.fromCharCode('A'.codeUnitAt(0) + index);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          ...List.generate(
              ejercicioDetalladoAgrupado.ejerciciosDetallados.length, (i) {
            String? ordenDentroDeSet;
            if (ejercicioDetalladoAgrupado.ejerciciosDetallados.length > 1) {
              ordenDentroDeSet = _getExerciseLetter(i);
            }

            return Column(
              children: [
                _buildListItem(
                    context,
                    index,
                    ejercicioDetalladoAgrupado.ejerciciosDetallados[i],
                    i,
                    ordenDentroDeSet),
                if (i <
                    ejercicioDetalladoAgrupado.ejerciciosDetallados.length - 1)
                  const Divider(),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildListItem(
      BuildContext context,
      int groupIndex,
      EjercicioDetallado ejercicioAgrupado,
      int exerciseIndex,
      String? ordenDentroDeSet) {
    return Dismissible(
      key: Key(
          'group_${ejercicioDetalladoAgrupado.groupedDetailedExercisedId}/exercise_$exerciseIndex'),
      onDismissed: (_) {
        onDeleteEjercicioDetalladoAgrupado(groupIndex, exerciseIndex);
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              leading: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${groupIndex + 1} ',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    if (ordenDentroDeSet != null)
                      TextSpan(
                        text: '$ordenDentroDeSet ',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      )
                  ],
                ),
              ),
              trailing:
                  _buildPopupMenuButton(context, groupIndex, exerciseIndex),
              title: Text(ejercicioAgrupado.ejercicio?.name ??
                  'Ejercicio no especificado'),
            ),
            OutlinedButton(
              onPressed: () => onAddSet(index),
              child: const Text("+ añadir set"),
            ),
          ],
        ),
      ),
    );
  }

  _buildPopupMenuButton(
      BuildContext context, int groupIndex, int exerciseIndex) {
    return PopupMenuButton(
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'eliminar',
          child: Text('Eliminar'),
        ),
        const PopupMenuItem(
          value: 'reordenar',
          child: Text('Reordenar'),
        ),
        const PopupMenuItem(
          value: 'nota',
          child: Text('Escribir nota'),
        ),
      ],
      onSelected: (value) =>
          _handleMenuItemSelected(value, groupIndex, exerciseIndex),
    );
  }
}
