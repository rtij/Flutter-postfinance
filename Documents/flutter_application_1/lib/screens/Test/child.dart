// Widget enfant
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
class EnfantWidget extends StatelessWidget {
  final Function(String) onMessageSent;

  const EnfantWidget({Key? key, required this.onMessageSent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Beamer.of(context, root: true).beamToNamed('/login');
        onMessageSent("Message depuis l'enfant !");
      },
      child: const Text("Envoyer"),
    );
  }
}
