import 'package:flutter/material.dart';
class MenuButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  MenuButton({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(16.0),
          textStyle: TextStyle(fontSize: 18),
        ),
        onPressed: onTap,
        child: Text(title),
      ),
    );
  }
}