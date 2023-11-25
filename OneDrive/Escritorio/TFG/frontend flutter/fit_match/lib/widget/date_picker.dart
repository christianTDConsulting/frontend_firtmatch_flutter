import 'package:fit_match/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePicker extends StatelessWidget {
  final TextEditingController dateController;
  const DatePicker({Key? key, required this.dateController}) : super(key: key);

  void selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != DateTime.now()) {
      // Formatea la fecha y actualiza el controlador de texto
      final formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      dateController.text = formattedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: () => selectDate(context),
              color: blueColor,
              child: const Text(
                "Selecciona una fecha de nacimiento",
                style:
                    TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
              ),
            ),
            // Puedes agregar un TextField para mostrar la fecha seleccionada
            TextField(
              controller: dateController,
              decoration:
                  const InputDecoration(labelText: 'Fecha de nacimiento'),
            ),
          ],
        ),
      ),
    );
  }
}
