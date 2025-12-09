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
                // Botão "Todos" - Observer individual
                return Observer(
                  builder: (_) {
                    final isSelected = !store.hasSelectedGenres;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: const Text('Todos'),
                        selected: isSelected,
                        onSelected: (_) => store.clearGenreFilters(),
                        selectedColor: Colors.blue,
                        backgroundColor: Colors.grey[200],
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    );
                  },
                );
              }

              final genre = store.genres[index - 1];

              // Observer INDIVIDUAL para cada chip (isso resolve!)
              return Observer(
                builder: (_) {
                  final isSelected = store.selectedGenreIds.contains(genre.id);

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(genre.name!),
                      selected: isSelected,
                      onSelected: (_) => store.toggleGenre(genre.id!),
                      selectedColor: Colors.blue,
                      backgroundColor: Colors.grey[200],
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                      checkmarkColor: Colors.white,
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
