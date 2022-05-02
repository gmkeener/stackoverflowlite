import 'package:flutter/material.dart';

import 'package:genopets/Core/Extensions/color_to_hex.dart';
import 'package:genopets/Core/Helpers/ScreenHelper.dart';

class CustomTextFormField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextNode;
  final bool isPassword;
  final String? forcedErrorMessage;
  final TextInputType? keyboardType;

  CustomTextFormField({
    Key? key,
    required this.hintText,
    required this.controller,
    required this.focusNode,
    this.nextNode,
    required this.isPassword,
    this.forcedErrorMessage,
    this.keyboardType,
  }) : super(key: key);

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  String? defaultValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mandatory field';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: TextFormField(
        keyboardType: widget.keyboardType != null
            ? widget.keyboardType
            : TextInputType.text,
        obscureText: widget.isPassword,
        controller: widget.controller,
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(widget.nextNode);
        },
        validator: defaultValidator,
        decoration: InputDecoration(
          isDense: true,
          errorText: widget.forcedErrorMessage,
          hintText: widget.hintText.toUpperCase(),
          hintStyle: TextStyle(
              fontFamily: 'Acumin Pro',
              fontWeight: FontWeight.w700,
              fontSize: 15,
              height: 1.2,
              letterSpacing: 0.15,
              color: Colors.grey[600]),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 11),
          filled: true,
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.purple),
            borderRadius: BorderRadius.circular(5),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(5),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: HexColor.fromHex('E9A339'),
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          errorStyle: TextStyle(
            color: HexColor.fromHex('E9A339'),
          ),
        ),
      ),
    );
  }
}
