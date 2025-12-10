// Widget enfant
import 'package:flutter/material.dart';
class EnfantWidget extends StatelessWidget {
  final Function(String) onMessageSent;

  const EnfantWidget({Key? key, required this.onMessageSent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onMessageSent("Message depuis l'enfant !");
      },
      child: const Text("Envoyer"),
    );
  }
}
