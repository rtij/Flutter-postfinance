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
        Beamer.of(context).beamToNamed('/home/dashboard');
      },
      child: const Text("Envoyer"),
    );
  }
}
