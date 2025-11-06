import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MudarCor extends StatefulWidget {
  const MudarCor({super.key});

  @override
  State<MudarCor> createState() => _MudarCorState();
}

class _MudarCorState extends State<MudarCor> {
  Color corAtual = Colors.black;

  final List<Color> coresDisponiveis = [
    Colors.black,
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.teal,
  ];

  @override
  void initState() {
    super.initState();
    carregarCor();
  }

  void carregarCor() async {
    try {
      debugPrint('🎨 MudarCor: Carregando cor...');
      final prefs = await SharedPreferences.getInstance();
      int corIndex = prefs.getInt('cor_contador') ?? 0;

      debugPrint('📊 MudarCor: Cor index carregado: $corIndex');

      setState(() {
        corAtual =
            coresDisponiveis[corIndex.clamp(0, coresDisponiveis.length - 1)];
      });

      debugPrint('MudarCor: Cor carregada com sucesso!');
    } catch (e) {
      debugPrint('MudarCor: Erro ao carregar cor: $e');
    }
  }

  void salvarCor(int corIndex) async {
    try {
      debugPrint('💾 MudarCor: Salvando cor index: $corIndex');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('cor_contador', corIndex);

      // Verificação
      int verificacao = prefs.getInt('cor_contador') ?? -1;
      debugPrint('MudarCor: Cor salva - index: $verificacao');
    } catch (e) {
      debugPrint('MudarCor: Erro ao salvar cor: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mudar Cor'),
        backgroundColor: const Color.fromARGB(255, 56, 147, 35),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Escolha a cor do contador:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text('Cor atual', style: TextStyle(fontSize: 48, color: corAtual)),
            const SizedBox(height: 30),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: coresDisponiveis.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        corAtual = coresDisponiveis[index];
                      });
                      salvarCor(index);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Cor salva com sucesso!'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: coresDisponiveis[index],
                        borderRadius: BorderRadius.circular(10),
                        border: corAtual == coresDisponiveis[index]
                            ? Border.all(color: Colors.grey, width: 3)
                            : Border.all(color: Colors.grey.shade300),
                      ),
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
