import 'package:flutter/material.dart';

void main() {
  runApp(const Errada());
}

class Errada extends StatefulWidget {
  const Errada({super.key});

  @override
  State<Errada> createState() => _ErradaState();
}

class _ErradaState extends State<Errada> {
  @override
  Widget build(BuildContext context) {
    String valor = '12';

    double numero = double.parse(valor);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Tela de erro')),
        body: Container(margin: EdgeInsets.all(numero), color: Colors.red),
      ),
    );
  }
}
