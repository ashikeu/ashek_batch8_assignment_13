
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({super.key, required this.controller, this.hintText, required this.labelText});
final TextEditingController controller;
final String? hintText;
final String labelText;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
            controller: controller,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                hintText: hintText??'',
                labelText: labelText),
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Enter $labelText';
              }
              return null;
            },
          );
  }
}