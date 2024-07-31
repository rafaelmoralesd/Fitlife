// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CuntomInput extends StatelessWidget {
   const CuntomInput({
    super.key,
    required this.controller,
    required this.label,
    this.icon = Icons.person,
    this.obscureText = false,
    this.maxLength = 20,
    this.minLength = 2,
    this.errorText,
    this.keyboardType = TextInputType.text,
    required this.validator,
    
  });

  final String label;
  final IconData icon;
  final bool obscureText;
  final int maxLength;
  final int minLength;
  final String? errorText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      
      decoration: InputDecoration(
        
        hintText: '$label',
        
       
       
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
             filled: true,
             fillColor: const Color.fromARGB(90, 158, 158, 158),
      ),
     

     
    );
  }
}