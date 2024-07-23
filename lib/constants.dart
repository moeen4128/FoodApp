import 'package:flutter/material.dart';

class ReusableTextField extends StatefulWidget {
  const ReusableTextField({
    super.key,
    required this.title,
    required this.hint,
    this.isNumber,
    required this.controller,
    required this.formKey,
    this.readOnly = false, // Add a new parameter for read-only status
  });

  final String title, hint;
  final bool? isNumber;
  final TextEditingController controller;
  final Key formKey;
  final bool readOnly; // New parameter to determine if the field is read-only

  @override
  State<ReusableTextField> createState() => _ReusableTextFieldState();
}

class _ReusableTextFieldState extends State<ReusableTextField> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: TextFormField(
        enabled: !widget.readOnly, // Disable the field if it's read-only
        readOnly: widget.readOnly, // Set read-only mode
        keyboardType: widget.isNumber == null
            ? TextInputType.text
            : TextInputType.number,
        decoration: InputDecoration(
          labelText: widget.title,
          hintText: widget.hint,
        ),
        validator: (value) =>
        value!.isEmpty ? "Cannot be empty" : null,
        controller: widget.controller,
      ),
    );
  }
}
