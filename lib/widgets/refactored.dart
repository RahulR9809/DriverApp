
import 'package:employerapp/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


// Custom-styled button function with icon intro
Widget actionButton(BuildContext context, String text, VoidCallback onPressed, Color color) {
  return ElevatedButton.icon(
    onPressed: onPressed,
    label: Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: CustomColors.black,
      ),
    ),
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40.0),
      backgroundColor: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      elevation: 8,
    ),
  );
}


void showSnackBar(BuildContext context, String message,Color color) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor:color,
      behavior: SnackBarBehavior.floating,
    ),
  );
}



class ReusableButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ReusableButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.greenAccent,
        padding: const EdgeInsets.symmetric(vertical: 5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 8,
      ),
      child: SizedBox(
        height: 40,
        width: 100,
        child: Center(
          child: Text(
            text,
            style: const TextStyle(fontSize: 18,color: Colors.black),
          ),
        ),
      ),
    );
  }
}



class ReusableTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool isPassword;
final String? Function(String?)? validator; 
  const ReusableTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.isPassword = false,
    this.validator
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          validator: validator,
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: CustomColors.deepPurple),
            prefixIcon: Icon(icon, color:CustomColors.deepPurple),
            border: InputBorder.none,
            
          ),
          style: const TextStyle(color:CustomColors.black),
        ),
      ),
    );
  }
}


class ConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: const Text('Cancel', style: TextStyle(color: CustomColors.red)),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor:CustomColors.green,
          ),
          child: const Text('Confirm',style: TextStyle(color: CustomColors.white),),
        ),
      ],
    );
  }
}



void showLoadingDialog(BuildContext context) {
  // Show the dialog
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent dismissing by tapping outside
    builder: (BuildContext context) {
      // Start a 3-second timer to automatically dismiss the dialog
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.of(context).pop(); // Dismiss the dialog
      });

      return Dialog(
        backgroundColor: Colors.transparent, // Transparent background
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(30),
            child: const SpinKitWave(
              color: Colors.blueAccent,
              size: 50.0,
            ),
          ),
        ),
      );
    },
  );
}
