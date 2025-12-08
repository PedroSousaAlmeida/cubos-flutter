import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Carregar variáveis de ambiente
  await dotenv.load(fileName: ".env");
  
  // Debug: Verificar se carregou
  final apiKey = dotenv.env['TMDB_API_KEY'] ?? '';
  print('🔑 API Key carregada: ${apiKey.isNotEmpty ? "✅ SIM" : "❌ NÃO"}');
  if (apiKey.isNotEmpty) {
    print('🔑 Primeiros 10 caracteres: ${apiKey.substring(0, apiKey.length > 10 ? 10 : apiKey.length)}...');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cubos Desafio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cubos Desafio'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.movie_outlined,
              size: 100,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            const Text(
              'App de Filmes',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '🎬 Pronto para começar!',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                final apiKey = dotenv.env['TMDB_API_KEY'] ?? '';
                print('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
                print('🔍 Testando API Key...');
                print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
                
                if (apiKey.isEmpty) {
                  print('❌ API Key NÃO encontrada!');
                  print('📝 Verifique o arquivo .env');
                } else {
                  print('✅ API Key encontrada!');
                  print('📏 Tamanho: ${apiKey.length} caracteres');
                  print('🔑 Preview: ${apiKey.substring(0, apiKey.length > 10 ? 10 : apiKey.length)}...');
                }
                print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
              },
              icon: const Icon(Icons.bug_report),
              label: const Text('Testar API Key (ver console)'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}