import 'package:flutter/material.dart';

class DatepickerWidget extends StatefulWidget {
  final TextEditingController controller;

  DatepickerWidget({Key? key, required this.controller}) : super(key: key);

  @override
  _DatepickerWidgetState createState() => _DatepickerWidgetState();
}

class _DatepickerWidgetState extends State<DatepickerWidget> {
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        widget.controller.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _selectDate(context),
      child: Container(
        padding: EdgeInsets.all(12.0),
        child: Row(
          children: [
            const Icon(Icons.calendar_today),
            const SizedBox(width: 8.0),
            Expanded(
              child: TextFormField(
                controller: widget.controller,
                enabled: false,
                decoration: const InputDecoration(
                  hintText: "Seleccione tu fecha de nacimiento",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
