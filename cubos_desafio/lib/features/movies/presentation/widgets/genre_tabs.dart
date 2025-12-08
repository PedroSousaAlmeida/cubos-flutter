import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../stores/movie_list_store.dart';

class GenreTabs extends StatelessWidget {
  final MovieListStore store;

  const GenreTabs({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (!store.hasGenres) {
          return const SizedBox.shrink();
        }

        return SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: store.genres.length + 1, // +1 para "Todos"
            itemBuilder: (context, index) {
              if (index == 0) {
                // Botão "Todos"
                final isSelected = store.selectedGenreId == null;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: const Text('Todos'),
                    selected: isSelected,
                    onSelected: (_) => store.loadPopularMovies(),
                    selectedColor: Theme.of(context).primaryColor,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                );
              }

              final genre = store.genres[index - 1];
              final isSelected = store.selectedGenreId == genre.id;

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(genre.name!),
                  selected: isSelected,
                  onSelected: (_) => store.filterByGenre(genre.id!),
                  selectedColor: Theme.of(context).primaryColor,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
