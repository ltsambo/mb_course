import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final bool isEnabled;
  final String label;
  final IconData? icon;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;

  const CustomTextFormField({
    super.key,
    this.isEnabled = true,
    required this.label,
    this.icon,
    this.validator,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      enabled: isEnabled,
      decoration: _inputDecoration(label, icon!),
      validator: validator,
      onSaved: onSaved,
    );
  }
}

 InputDecoration _inputDecoration(String label, IconData? icon) {
    return InputDecoration(
      labelText: label,     
      labelStyle: TextStyle(color: Colors.white),
      prefixIcon: icon != null ? Icon(icon, color: Colors.white) : null,
      // enabledBorder: UnderlineInputBorder(
      //     borderSide: BorderSide(color: Colors.white),
      //   ),      
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),      
    );
  }