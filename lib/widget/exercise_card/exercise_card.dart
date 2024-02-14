import 'package:fit_match/models/ejercicios.dart';
import 'package:fit_match/widget/dialog.dart';

// import 'package:fit_match/widget/exercise_card/sets_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExerciseCard extends StatefulWidget {
  final EjerciciosDetalladosAgrupados ejercicioDetalladoAgrupado;
  final List<TipoDeRegistro> registerTypes;
  final int index;
  final Function(int, int) onAddSet;
  final Function(int, int) onDeleteSet;
  final Function(int, int) onDeleteEjercicioDetalladoAgrupado;

  const ExerciseCard({
    Key? key,
    required this.ejercicioDetalladoAgrupado,
    required this.registerTypes,
    required this.index,
    required this.onDeleteEjercicioDetalladoAgrupado,
    required this.onAddSet,
    required this.onDeleteSet,
  }) : super(key: key);

  @override
  _ExerciseCard createState() => _ExerciseCard();
}

class _ExerciseCard extends State<ExerciseCard> {
  int selectedRegisterType = 1;

  void _handleMenuItemSelected(
      String value, int groupIndex, int exerciseIndex) {
    switch (value) {
      case 'reordenar':
        break;
      case 'nota':
        break;
      case 'eliminar':
        widget.onDeleteEjercicioDetalladoAgrupado(groupIndex, exerciseIndex);
        break;
    }
  }

  String _getExerciseLetter(int index) {
    return String.fromCharCode('A'.codeUnitAt(0) + index);
  }

  void _showDialog(String description, BuildContext context) async {
    CustomDialog.show(
      context,
      Text(description),
      () {
        print('Diálogo cerrado');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          ...List.generate(
              widget.ejercicioDetalladoAgrupado.ejerciciosDetallados.length,
              (i) {
            String? ordenDentroDeSet;
            if (widget.ejercicioDetalladoAgrupado.ejerciciosDetallados.length >
                1) {
              ordenDentroDeSet = _getExerciseLetter(i);
            }

            return Column(
              children: [
                _buildListItem(
                    context,
                    widget.index,
                    widget.ejercicioDetalladoAgrupado.ejerciciosDetallados[i],
                    i,
                    ordenDentroDeSet),
                if (i <
                    widget.ejercicioDetalladoAgrupado.ejerciciosDetallados
                            .length -
                        1)
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
          'group_${widget.ejercicioDetalladoAgrupado.groupedDetailedExercisedId}_exercise_${ejercicioAgrupado.detailedExerciseId}'),
      onDismissed: (_) {
        widget.onDeleteEjercicioDetalladoAgrupado(groupIndex, exerciseIndex);
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
              title: Row(
                children: [
                  Flexible(
                    child: Text(
                      ejercicioAgrupado.ejercicio?.name ??
                          'Ejercicio no especificado',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.info_outline),
                    onPressed: () {
                      _showDialog(
                          ejercicioAgrupado.ejercicio!.description ??
                              'Sin descripción',
                          context);
                    },
                    constraints:
                        BoxConstraints(), // Remove padding around the icon
                    alignment: Alignment.centerRight,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Set',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: _buildRegisterTypeDropdown(),
                  ),
                ],
              ),
            ),
            ...List.generate(
                widget.ejercicioDetalladoAgrupado.ejerciciosDetallados.length,
                (i) {
              return SetRow(
                groupOrder: groupIndex,
                exerciseOrder: i,
                onDeleteSet: widget.onDeleteSet,
                setNumber: i + 1,
                selectedRegisterType: selectedRegisterType,
                onFieldSubmitted: (value) {},
              );
            }),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => widget.onAddSet(widget.index, exerciseIndex),
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

  Widget _buildRegisterTypeDropdown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton<int>(
        isExpanded: true,
        menuMaxHeight: 300,
        value: selectedRegisterType,
        icon: const Icon(
          Icons.arrow_drop_down,
        ),
        onChanged: (newValue) {
          setState(() {
            selectedRegisterType = newValue!;
          });
        },
        items: [
          ...widget.registerTypes.map((typeRegister) {
            return DropdownMenuItem<int>(
              value: typeRegister.registerTypeId,
              child: Text(
                typeRegister.name ?? "Sin nombre",
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

class NumberInputField extends StatelessWidget {
  final Function(String) onFieldSubmitted;
  final String? hintText;
  final TextEditingController? controller;

  const NumberInputField({
    Key? key,
    required this.onFieldSubmitted,
    this.hintText,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Estilo personalizado para el borde del campo de texto
    OutlineInputBorder borderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8), // Bordes redondeados
      borderSide: BorderSide(
        color: Colors.grey.shade300, // Color del borde
      ),
    );

    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        border: borderStyle,
        enabledBorder: borderStyle,
        focusedBorder: borderStyle.copyWith(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
        errorBorder: borderStyle.copyWith(
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),
        hintText: hintText,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
        filled: true,
        fillColor: Theme.of(context).colorScheme.background,
      ),
      textAlign: TextAlign.center,
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}

class SetRow extends StatelessWidget {
  final int setNumber;
  final int selectedRegisterType;
  final int groupOrder;
  final int exerciseOrder;
  final Function(String) onFieldSubmitted;
  final Function(int, int) onDeleteSet;

  const SetRow(
      {Key? key,
      required this.setNumber,
      required this.selectedRegisterType,
      required this.onFieldSubmitted,
      required this.onDeleteSet,
      required this.groupOrder,
      required this.exerciseOrder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> children;

    Widget dash = const SizedBox(
      width: 12,
      child: Text(
        '-',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16),
      ),
    );

    Widget minText = const SizedBox(
      width: 36,
      child: Text(
        'min',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 16), // Ajusta el tamaño de la fuente según sea necesario
      ),
    );

    switch (selectedRegisterType) {
      case 1:
        children = [
          const SizedBox(width: 8),
          Expanded(child: NumberInputField(onFieldSubmitted: onFieldSubmitted)),
          dash,
          Expanded(child: NumberInputField(onFieldSubmitted: onFieldSubmitted)),
        ];
        break;
      case 4: // Caso para el tipo de registro 4
        children = [
          const Expanded(child: Text('AMRAP', style: TextStyle(fontSize: 16))),
        ];
        break;
      case 5: // Caso para el tipo de registro 5
        children = [
          Expanded(child: NumberInputField(onFieldSubmitted: onFieldSubmitted)),
          minText
        ];
        break;
      case 6: // Caso para el tipo de registro 6
        children = [
          Expanded(child: NumberInputField(onFieldSubmitted: onFieldSubmitted)),
          dash,
          Expanded(child: NumberInputField(onFieldSubmitted: onFieldSubmitted)),
          minText
        ];
        break;
      default: // Caso por defecto
        children = [
          Expanded(child: NumberInputField(onFieldSubmitted: onFieldSubmitted)),
        ];
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: Dismissible(
        key: Key('$setNumber'),
        onDismissed: onDeleteSet(groupOrder, exerciseOrder),
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20.0),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        direction: DismissDirection.endToStart,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('$setNumber', style: const TextStyle(fontSize: 16)),
          Container(
              constraints: const BoxConstraints(maxWidth: 250),
              child: Row(children: children)),
          IconButton(
              onPressed: onDeleteSet(groupOrder, exerciseOrder),
              icon: const Icon(Icons.delete),
              color: Colors.red),
        ]),
      ),
    );
  }
}
