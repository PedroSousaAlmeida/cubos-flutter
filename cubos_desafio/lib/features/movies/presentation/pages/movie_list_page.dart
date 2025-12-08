import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import '../stores/movie_list_store.dart';
import '../widgets/genre_tabs.dart';
import '../widgets/movie_card.dart';

class MovieListPage extends StatefulWidget {
  const MovieListPage({super.key});

  @override
  State<MovieListPage> createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieListStore>().loadInitialData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = context.read<MovieListStore>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Filmes'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar filmes...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: Observer(
                  builder: (_) {
                    if (store.searchQuery.isNotEmpty) {
                      return IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          store.loadPopularMovies();
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (query) => store.searchMoviesByQuery(query),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Tabs de Gêneros
              GenreTabs(store: store),

              const SizedBox(height: 8),

              // Lista de Filmes
              Expanded(
                child: Observer(
                  builder: (_) {
                    // Loading inicial (sem filmes)
                    if (store.isLoading && !store.hasMovies) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // Erro
                    if (store.hasError && !store.hasMovies) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              store.errorMessage ?? 'Erro desconhecido',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => store.loadPopularMovies(),
                              child: const Text('Tentar Novamente'),
                            ),
                          ],
                        ),
                      );
                    }

                    // Vazio
                    if (!store.hasMovies) {
                      return const Center(
                        child: Text('Nenhum filme encontrado'),
                      );
                    }

                    // Grid de Filmes
                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.6,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                      itemCount: store.movies.length,
                      itemBuilder: (context, index) {
                        final movie = store.movies[index];
                        return MovieCard(
                          movie: movie,
                          genres: store.genres,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(movie.title)),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),

          // ⏳ LOADING GLOBAL OVERLAY
          Observer(
            builder: (_) {
              if (store.isLoading && store.hasMovies) {
                return Container(
                  color: Colors.black54,
                  child: const Center(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text(
                              'Filtrando filmes...',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
