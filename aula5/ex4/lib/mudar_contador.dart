import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MudarContador extends StatefulWidget {
  const MudarContador({super.key});

  @override
  State<MudarContador> createState() => _MudarContadorState();
}

class _MudarContadorState extends State<MudarContador> {
  int contador = 0;
  TextEditingController controlador = TextEditingController();

  @override
  void initState() {
    debugPrint('iniciando');
    super.initState();
    carregaContador();
  }

  void carregaContador() async {
    try {
      debugPrint('MudarContador: Carregando...');
      final prefs = await SharedPreferences.getInstance();

      setState(() {
        contador = prefs.getInt('contador') ?? 0;
      });
      debugPrint('MudarContador: Valor carregado: $contador');
    } catch (e) {
      debugPrint('MudarContador: Erro ao carregar: $e');
    }
  }

  void salvaContador(int valor) async {
    try {
      debugPrint('MudarContador: Salvando: $valor');
      final prefs = await SharedPreferences.getInstance();

      await prefs.setInt('contador', valor);

      // Verificar se foi salvo
      int verificacao = prefs.getInt('contador') ?? -1;
      debugPrint('MudarContador: Verificação - valor salvo: $verificacao');
    } catch (e) {
      debugPrint('MudarContador: Erro ao salvar: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mudar Contador'),
        backgroundColor: Color.fromARGB(255, 56, 147, 35),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Valor atual: $contador',
              style: const TextStyle(fontSize: 32),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: controlador,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Digite o novo valor',
                  hintText: 'Ex: 10',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                String valorTxt = controlador.text;
                debugPrint(valorTxt);
                if (valorTxt != '') {
                  int valor = int.parse(valorTxt);
                  setState(() {
                    contador = valor;
                  });
                  salvaContador(valor);
                  Navigator.pop(context, valor);
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
