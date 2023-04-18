import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  final VoidCallback action;
  final String text;

  const DefaultButton({
    super.key,
    required this.action,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: action,
      style: ElevatedButton.styleFrom(backgroundColor: Colors.indigoAccent),
      child: Text(
        text,
      ),
    );
  }
}
