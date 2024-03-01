import 'dart:async';
import 'package:fit_match/models/ejercicios.dart';
import 'package:fit_match/models/registros.dart';
import 'package:fit_match/utils/utils.dart';
import 'package:fit_match/widget/dialog.dart';
import 'package:fit_match/widget/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterCard extends StatefulWidget {
  final EjerciciosDetalladosAgrupados ejercicioDetalladoAgrupado;
  final int index;
  // final Function(SetsEjerciciosEntrada) initSet;
  // final Function(int, int) onAddSet;
  // final Function(int, int, int) onDeleteSet;
  // final Function(int, int, int, SetsEjerciciosEntrada) onUpdateSet;

  const RegisterCard({
    Key? key,
    required this.ejercicioDetalladoAgrupado,
    required this.index,
    // required this.onAddSet,
    // required this.onDeleteSet,
    // required this.onUpdateSet,
    // required this.initSet,
  }) : super(key: key);

  @override
  _RegisterCard createState() => _RegisterCard();
}

class _RegisterCard extends State<RegisterCard> {
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    initControladores();
  }

  void initControladores() {
    widget.ejercicioDetalladoAgrupado.ejerciciosDetallados
        .asMap()
        .forEach((index, ejercicio) {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _handleMenuItemSelected(
      String value, int groupIndex, int exerciseIndex) {
    switch (value) {
      case 'video':
        print('Video');
        break;
    }
  }

  void _showDialog(String description, BuildContext context) async {
    CustomDialog.show(
      context,
      Text(description),
      () {},
    );
  }

  _getSetWithRegistro(SetsEjerciciosEntrada setsEjerciciosEntrada) {
    // return widget.initSet(setsEjerciciosEntrada);
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
              ordenDentroDeSet = getExerciseLetter(i);
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
      EjercicioDetallado ejercicioDetallado,
      int exerciseIndex,
      String? ordenDentroDeSet) {
    return Padding(
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
            trailing: _buildPopupMenuButton(context, groupIndex, exerciseIndex),
            title: Row(
              children: [
                Flexible(
                  child: Text(
                    ejercicioDetallado.ejercicio?.name ??
                        'Ejercicio no especificado',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.info_outline),
                  onPressed: () {
                    _showDialog(
                        ejercicioDetallado.ejercicio!.description ??
                            'Sin descripción',
                        context);
                  },
                  constraints: const BoxConstraints(),
                  alignment: Alignment.centerRight,
                ),
              ],
            ),
          ),
          //se muestra el textArea si hay texto o si se le ha dado a "nota"
          ...[
            if (ejercicioDetallado.notes != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 8.0),
                  child: ExpandableText(
                    text: ejercicioDetallado.notes!,
                  ),
                ),
              ),
          ],

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
              ],
            ),
          ),
          ...List.generate(ejercicioDetallado.setsEntrada?.length ?? 0, (i) {
            if (i < 0 || i >= ejercicioDetallado.setsEntrada!.length) {
              return const SizedBox.shrink();
            }

            return SetRow(
                set: _getSetWithRegistro(ejercicioDetallado.setsEntrada![i]),
                onDeleteSet: () => {},
                // {widget.onDeleteSet(groupIndex, exerciseIndex, i)},
                selectedRegisterType: ejercicioDetallado.registerTypeId,
                onUpdateSet: (updatedSet) => {}
                // (updatedSet) {
                //   widget.onUpdateSet(groupIndex, exerciseIndex, i, updatedSet);
                // },
                );
          }),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => {}, //widget.onAddSet(widget.index, exerciseIndex),
            child: const Text("+ añadir set"),
          ),
        ],
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
      ],
      onSelected: (value) =>
          _handleMenuItemSelected(value, groupIndex, exerciseIndex),
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
      onChanged: onFieldSubmitted,
    );
  }
}

class SetRow extends StatefulWidget {
  final SetsEjerciciosEntrada set;
  final int selectedRegisterType;

  final Function(SetsEjerciciosEntrada) onUpdateSet;
  final Function() onDeleteSet;

  const SetRow({
    Key? key,
    required this.set,
    required this.selectedRegisterType,
    required this.onUpdateSet,
    required this.onDeleteSet,
  }) : super(key: key);

  @override
  _SetRowState createState() => _SetRowState();
}

class _SetRowState extends State<SetRow> {
  late TextEditingController repsController;
  late TextEditingController weightController;
  Timer? _debounce;

  @override
  void initState() {
    repsController = TextEditingController();
    weightController = TextEditingController();
    _initRegisterSet();
    super.initState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  _initRegisterSet() {}

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
      style: TextStyle(fontSize: 16),
    ),
  );

  void _updateSet(String value, String field) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      RegistroSet updatedSet = widget.set.registroSet!
          .last; //debo asegurarme que el set siempra tenga un registro
      int? intValue = int.tryParse(value);
      double? doubleValue = double.tryParse(value);

      switch (field) {
        case 'reps':
          updatedSet.reps = intValue;
          break;
        case 'weight':
          updatedSet.weight = doubleValue;
          break;
        case 'time':
          updatedSet.time = doubleValue;
          break;
      }
      SetsEjerciciosEntrada updatedEjercicio = widget.set;
      updatedEjercicio.registroSet!.add(updatedSet);
      widget.onUpdateSet(updatedEjercicio);
    });
  }

  List<Widget> _buildInputFields() {
    switch (widget.selectedRegisterType) {
      case 1: // Rango de repeticiones

        repsController.text =
            widget.set.registroSet!.last.reps?.toString() ?? '';
        weightController.text =
            widget.set.registroSet!.last.weight?.toString() ?? '';
        return [
          Expanded(
            child: NumberInputField(
              controller: repsController,
              onFieldSubmitted: (value) => _updateSet(value, 'reps'),
            ),
          ),
          dash,
          Expanded(
            child: NumberInputField(
              controller: weightController,
              onFieldSubmitted: (value) => _updateSet(value, 'weight'),
            ),
          ),
        ];
      case 4: // AMRAP
        return [
          const Expanded(child: Text('AMRAP', style: TextStyle(fontSize: 16))),
        ];
      case 5: // Tiempo
        weightController.text =
            widget.set.registroSet!.last.time?.toString() ?? '';
        return [
          Expanded(
            child: NumberInputField(
              controller: weightController,
              onFieldSubmitted: (value) => _updateSet(value, 'time'),
            ),
          ),
          minText,
        ];
      case 6: // Rango de tiempo
        repsController.text =
            widget.set.registroSet!.last.time?.toString() ?? '';
        weightController.text =
            widget.set.registroSet!.last.weight?.toString() ?? '';
        return [
          Expanded(
            child: NumberInputField(
              controller: repsController,
              onFieldSubmitted: (value) => _updateSet(value, 'minTime'),
            ),
          ),
          dash,
          Expanded(
            child: NumberInputField(
              controller: weightController,
              onFieldSubmitted: (value) => _updateSet(value, 'maxTime'),
            ),
          ),
          minText,
        ];
      default: // Por defecto, solo repeticiones
        repsController.text =
            widget.set.registroSet!.last.reps?.toString() ?? '';
        weightController.text =
            widget.set.registroSet!.last.weight?.toString() ?? '';

        return [
          Expanded(
            child: NumberInputField(
              controller: repsController,
              onFieldSubmitted: (value) => _updateSet(value, 'reps'),
            ),
          ),
          dash,
          Expanded(
              child: NumberInputField(
            controller: weightController,
            onFieldSubmitted: (value) => _updateSet(value, 'weight'),
          ))
        ];
    }
  }

  Widget _buildSetRowItem() {
    List<Widget> inputFields = _buildInputFields();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: Text('${widget.set.setOrder}',
                style: const TextStyle(fontSize: 16))),
        Expanded(
          child: Row(children: inputFields),
        ),
        Expanded(
          child: IconButton(
            onPressed:
                widget.set.setOrder == 1 ? null : () => widget.onDeleteSet(),
            icon: Icon(
                widget.set.setOrder == 1 ? Icons.delete_outline : Icons.delete),
            color: widget.set.setOrder == 1 ? Colors.grey : Colors.red,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.set.setOrder == 1) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
        child: _buildSetRowItem(),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
        child: Dismissible(
          key: ValueKey('set_$widget.set.setId}_${DateTime.now()}'),
          onDismissed: (_) => widget.onDeleteSet(),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20.0),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          direction: DismissDirection.endToStart,
          child: _buildSetRowItem(),
        ),
      );
    }
  }
}
