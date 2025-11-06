import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MudarFont extends StatefulWidget {
  const MudarFont({super.key});

  @override
  State<MudarFont> createState() => _MudarFontState();
}

class _MudarFontState extends State<MudarFont> {
  double tamanhoFonte = 48.0;

  final List<double> tamanhosDisponiveis = [
    24.0,
    32.0,
    40.0,
    48.0,
    56.0,
    64.0,
    72.0,
    80.0,
  ];

  @override
  void initState() {
    super.initState();
    carregarTamanhoFonte();
  }

  void carregarTamanhoFonte() async {
    try {
      debugPrint('MudarFont: Carregando tamanho...');
      final prefs = await SharedPreferences.getInstance();
      double tamanho = prefs.getDouble('tamanho_fonte') ?? 48.0;

      debugPrint('MudarFont: Tamanho carregado: $tamanho');

      setState(() {
        tamanhoFonte = tamanho;
      });

      debugPrint('MudarFont: Tamanho carregado com sucesso!');
    } catch (e) {
      debugPrint('MudarFont: Erro ao carregar tamanho: $e');
    }
  }

  void salvarTamanhoFonte(double tamanho) async {
    try {
      debugPrint('MudarFont: Salvando tamanho: $tamanho');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('tamanho_fonte', tamanho);

      // Verificação
      double verificacao = prefs.getDouble('tamanho_fonte') ?? -1;
      debugPrint('MudarFont: Tamanho salvo: $verificacao');
    } catch (e) {
      debugPrint('MudarFont: Erro ao salvar tamanho: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mudar Fonte'),
        backgroundColor: const Color.fromARGB(255, 56, 147, 35),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Escolha o tamanho da fonte:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Exemplo: ${tamanhoFonte.toInt()}',
              style: TextStyle(fontSize: tamanhoFonte),
            ),
            const SizedBox(height: 30),
            const Text('Tamanhos disponíveis:', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: tamanhosDisponiveis.length,
                itemBuilder: (context, index) {
                  double tamanho = tamanhosDisponiveis[index];
                  return Card(
                    color: tamanhoFonte == tamanho
                        ? Colors.green.shade100
                        : Colors.white,
                    child: ListTile(
                      title: Text(
                        'Tamanho ${tamanho.toInt()}',
                        style: TextStyle(fontSize: tamanho * 0.5),
                      ),
                      subtitle: Text('${tamanho.toInt()}px'),
                      trailing: tamanhoFonte == tamanho
                          ? const Icon(Icons.check, color: Colors.green)
                          : null,
                      onTap: () {
                        setState(() {
                          tamanhoFonte = tamanho;
                        });
                        salvarTamanhoFonte(tamanho);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Tamanho ${tamanho.toInt()} salvo!'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }
}
