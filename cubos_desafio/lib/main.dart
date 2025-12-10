import 'package:cubos_desafio/features/movies/presentation/pages/movie_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'features/movies/presentation/stores/movie_list_store.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await di.init();

  print('🚀 App iniciado!');
  print(
    '🔑 Bearer Token configurado: ${dotenv.env['TMDB_BEARER_TOKEN']?.isNotEmpty ?? false}',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cubos Desafio - Filmes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      ),
      home: Provider<MovieListStore>(
        create: (_) => di.sl<MovieListStore>(),
        dispose: (_, __) {},
        child: const MovieListPage(),
      ),
    );
  }
}
