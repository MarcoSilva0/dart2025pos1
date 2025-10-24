import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cotação do Dólar',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const CotacaoPage(),
    );
  }
}

class CotacaoPage extends StatefulWidget {
  const CotacaoPage({super.key});

  @override
  State<CotacaoPage> createState() => _CotacaoPageState();
}

class _CotacaoPageState extends State<CotacaoPage> {
  String? _maior;
  String? _menor;
  String? _erro;
  bool _carregando = false;

  Future<void> _buscarCotacao() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      final uri = Uri.parse('https://economia.awesomeapi.com.br/last/USD-BRL');
      final response = await http.get(uri);

      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}');
      }

      final Map<String, dynamic> data = jsonDecode(response.body);
      final Map<String, dynamic> usdbrl =
          data['USDBRL'] as Map<String, dynamic>;

      setState(() {
        _maior = usdbrl['high']?.toString();
        _menor = usdbrl['low']?.toString();
      });
    } catch (e) {
      setState(() {
        _erro = 'Erro ao buscar cotação: $e';
      });
    } finally {
      setState(() {
        _carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cotação do Dólar')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: _carregando ? null : _buscarCotacao,
                child: const Text('Verificar'),
              ),
              const SizedBox(height: 16),
              if (_carregando) const CircularProgressIndicator(),
              if (_erro != null) ...[
                Text(
                  _erro!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
              ],
              Card(
                elevation: 2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.arrow_upward,
                        color: Colors.red,
                      ),
                      title: const Text('Maior cotação (high)'),
                      subtitle: Text(_maior ?? '--'),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(
                        Icons.arrow_downward,
                        color: Colors.blue,
                      ),
                      title: const Text('Menor cotação (low)'),
                      subtitle: Text(_menor ?? '--'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
