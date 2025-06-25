import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FullTextformfieldComponent extends StatelessWidget {
  final TextEditingController valor;
  final String label;
  final Icon prefixIcon;
  final List<TextInputFormatter> inputFormater;
  final TextInputType textInputType;
  final Function(dynamic)? onChanged;
  final FormFieldValidator? validator;

  const FullTextformfieldComponent({
    super.key,
    required this.valor,
    required this.label,
    required this.prefixIcon,
    required this.inputFormater,
    required this.textInputType,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: TextFormField(
        controller: valor,
        style: TextStyle(fontSize: 22),
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          labelText: label,
          prefixIcon: prefixIcon,
          suffix: Padding(padding: const EdgeInsets.symmetric(horizontal: 10.0), child: Text("reais", style: TextStyle(fontSize: 14))),
        ),
        keyboardType: textInputType,
        inputFormatters: inputFormater,
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }
}
