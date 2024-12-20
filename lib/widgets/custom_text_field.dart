import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final String? obscureCharacter;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final FormFieldValidator<String>? validator;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.keyboardType,
    this.obscureText = false,
    this.obscureCharacter = '*',
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0),
      child: SizedBox(
        width: width,
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText!,
          obscuringCharacter: obscureCharacter!,
          style: TextStyle(
            fontSize: 12,
            color: Colors.black,
          ),
          validator: validator, // Use the validated function
          decoration: InputDecoration(
            fillColor: Color(0xFF4C53A5),
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: const BorderSide(
                color: Color(0xFF4C53A5),
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: const BorderSide(
                color: Color(0xFF4C53A5),
                width: 1.0,
              ),
            ),
            contentPadding: const EdgeInsets.all(2),
            isDense: true,  
          ),
        ),
      ),
    );
  }
}
