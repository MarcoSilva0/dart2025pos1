import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mudar_contador.dart';
import 'mudar_cor.dart';
import 'mudar_font.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int contador = 0;
  Color corContador = Colors.black;
  double tamanhoFonte = 48.0;

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
    debugPrint('iniciando');
    super.initState();
    carregaPreferencias();
  }

  void carregaPreferencias() async {
    try {
      debugPrint('Carregando preferências...');
      final prefs = await SharedPreferences.getInstance();

      // Debug: mostrar todas as chaves salvas
      Set<String> keys = prefs.getKeys();
      debugPrint('Chaves disponíveis: $keys');

      int contadorSalvo = prefs.getInt('contador') ?? 0;
      int corIndex = prefs.getInt('cor_contador') ?? 0;
      double tamanhoSalvo = prefs.getDouble('tamanho_fonte') ?? 48.0;

      debugPrint('Valores carregados:');
      debugPrint('Contador: $contadorSalvo');
      debugPrint('Cor index: $corIndex');
      debugPrint('Tamanho fonte: $tamanhoSalvo');

      setState(() {
        contador = contadorSalvo;
        corContador =
            coresDisponiveis[corIndex.clamp(0, coresDisponiveis.length - 1)];
        tamanhoFonte = tamanhoSalvo;
      });

      debugPrint('Preferências carregadas com sucesso!');
    } catch (e) {
      debugPrint('Erro ao carregar preferências: $e');
    }
  }

  void carregaContador() async {
    debugPrint('carregando');
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      contador = prefs.getInt('contador') ?? 0; // valor armazenado ou 0
    });
  }

  void salvaContador(int valor) async {
    try {
      debugPrint('Salvando contador: $valor');
      final prefs = await SharedPreferences.getInstance();

      await prefs.setInt('contador', valor);

      // Verificar se foi salvo corretamente
      int valorSalvo = prefs.getInt('contador') ?? -1;
      debugPrint('Contador salvo: $valorSalvo');
    } catch (e) {
      debugPrint('Erro ao salvar contador: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Color.fromARGB(255, 56, 147, 35),
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 56, 147, 35),
              ),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Mudar Contador'),
              onTap: () async {
                Navigator.pop(context);
                final resultado = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MudarContador(),
                  ),
                );
                if (resultado != null) {
                  carregaPreferencias();
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.color_lens),
              title: const Text('Mudar Cor'),
              onTap: () async {
                Navigator.pop(context);
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MudarCor()),
                );
                carregaPreferencias();
              },
            ),
            ListTile(
              leading: const Icon(Icons.font_download),
              title: const Text('Mudar Fonte'),
              onTap: () async {
                Navigator.pop(context);
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MudarFont()),
                );
                carregaPreferencias();
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Contagem: $contador',
              style: TextStyle(
                fontSize: tamanhoFonte,
                color: corContador,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      contador--;
                      salvaContador(contador);
                    });
                  },
                  child: const Text('Reduzir'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      contador++;
                      salvaContador(contador);
                    });
                  },
                  child: const Text('Aumentar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
