import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextForm extends StatelessWidget {
  final String hinttext;
  final double width;

  final TextEditingController mycontroller;

  final String? Function(String?)? validator;

  const CustomTextForm(
      {super.key,
      required this.hinttext,
      required this.mycontroller,
      required this.validator,
      required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 24, top: 4),
      width: width,
      child: TextFormField(
        validator: validator,
        controller: mycontroller,
        decoration: InputDecoration(
            hintText: hinttext,
            hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: const BorderSide(
                    color: Color.fromARGB(255, 184, 184, 184))),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: const BorderSide(color: Colors.grey))),
      ),
    );
  }
}

class CustomPhoneTextForm extends StatelessWidget {
  final String hinttext;
  final TextEditingController mycontroller;
  final String? Function(String?)? validator;

  const CustomPhoneTextForm({
    super.key,
    required this.hinttext,
    required this.mycontroller,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: mycontroller,
      keyboardType: TextInputType.phone,
      // Set keyboard type to phone
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly, // Only allow digits
      ],
      decoration: InputDecoration(
        hintText: hinttext,
        hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide:
              const BorderSide(color: Color.fromARGB(255, 184, 184, 184)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}
