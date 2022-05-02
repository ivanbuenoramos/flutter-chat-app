import 'package:flutter/material.dart';

class Labels extends StatelessWidget {

  final String ruta;
  final String textButtonLabel;
  final String textButton;

  const Labels({
    Key? key,
    required this.ruta,
    required this.textButton,
    required this.textButtonLabel,
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(textButtonLabel, style: const TextStyle(color: Colors.black54, fontSize: 15, fontWeight: FontWeight.w300)),
          const SizedBox(height: 10),
          GestureDetector(
            child: Text(textButton, style: TextStyle(color: Colors.blue[600], fontWeight: FontWeight.bold)),
            onTap: () => Navigator.pushReplacementNamed(context, ruta),
          ),
        ],
      )
    );
  }
}