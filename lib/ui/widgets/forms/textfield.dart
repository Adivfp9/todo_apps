import 'package:flutter/material.dart';

class TxtField extends StatefulWidget {
  final String label;
  final String? value;
  final String? hint;
  final String? Function(String?)? validator;
  final bool obscure;
  final Function(String) onChanged;
  final IconData iconField;
  final TextEditingController? controller;

  const TxtField(
      {Key? key,
      required this.label,
      this.value,
      this.validator,
      this.hint,
      required this.onChanged,
      this.obscure = false,
      required this.iconField,
      this.controller})
      : super(key: key);

  @override
  State<TxtField> createState() => _TxtFieldState();
}

class _TxtFieldState extends State<TxtField> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      initialValue: widget.value,
      validator: widget.validator,
      maxLength: 50,
      obscureText: widget.obscure,
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: const TextStyle(
          color: Colors.blueGrey,
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blueGrey,
          ),
        ),
        suffixIcon: Icon(
            // Icons.text_format,
            widget.iconField),
        helperText: widget.hint,
      ),
      onChanged: widget.onChanged,
    );
  }
}
