import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:mobx/mobx.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/genre.dart';
import '../../domain/entities/movie.dart';
import '../../domain/usecases/get_genres.dart';
import '../../domain/usecases/get_movies_by_genre.dart';
import '../../domain/usecases/get_popular_movies.dart';
import '../../domain/usecases/search_movies.dart';

part 'movie_list_store.g.dart';

class MovieListStore = _MovieListStoreBase with _$MovieListStore;

abstract class _MovieListStoreBase with Store {
  final GetPopularMovies getPopularMovies;
  final GetGenres getGenres;
  final GetMoviesByGenre getMoviesByGenre;
  final SearchMovies searchMovies;

  _MovieListStoreBase({
    required this.getPopularMovies,
    required this.getGenres,
    required this.getMoviesByGenre,
    required this.searchMovies,
  });

  // ==================== OBSERVAVEIS ====================

  @observable
  ObservableList<Movie> movies = ObservableList<Movie>();

  @observable
  ObservableList<Genre> genres = ObservableList<Genre>();

  @observable
  bool isLoading = false;

  @observable
  bool isLoadingMore = false;

  @observable
  String? errorMessage;

  @observable
  ObservableList<int> selectedGenreIds = ObservableList<int>();

  @observable
  String searchQuery = '';

  @observable
  int currentPage = 1;

  @observable
  bool hasMorePages = true;

  // Timer para debounce
  Timer? _debounceTimer;

  // ==================== COMPUTADOS ====================

  @computed
  bool get hasError => errorMessage != null;

  @computed
  bool get hasMovies => movies.isNotEmpty;

  @computed
  bool get hasGenres => genres.isNotEmpty;

  @computed
  bool get hasSelectedGenres => selectedGenreIds.isNotEmpty;

  // ==================== AÇÕES ====================

  @action
  Future<void> loadInitialData() async {
    await Future.wait([loadGenres(), loadPopularMovies()]);
  }

  @action
  Future<void> loadPopularMovies() async {
    isLoading = true;
    errorMessage = null;
    currentPage = 1;
    hasMorePages = true;

    final result = await getPopularMovies(const PopularMoviesParams(page: 1));

    result.fold(
      (failure) {
        errorMessage = failure.message;
        isLoading = false;
      },
      (movieList) {
        movies = ObservableList.of(movieList);
        selectedGenreIds.clear();
        searchQuery = '';
        hasMorePages = movieList.length == 20;
        isLoading = false;
      },
    );
  }

  @action
  Future<void> loadGenres() async {
    final result = await getGenres(const NoParams());

    result.fold(
      (failure) {
        errorMessage = failure.message;
      },
      (genreList) {
        genres = ObservableList.of(genreList);
      },
    );
  }

  @action
  void toggleGenre(int genreId) {
    // RECRIA a lista para forçar notificação do Observer
    final currentIds = selectedGenreIds.toList();

    if (currentIds.contains(genreId)) {
      currentIds.remove(genreId);
    } else {
      currentIds.add(genreId);
    }

    // Atribui nova lista (isso GARANTE que Observer detecta)
    selectedGenreIds = ObservableList.of(currentIds);

    // Busca filmes em background
    _updateMoviesBySelectedGenres();
  }

  @action
  Future<void> clearGenreFilters() async {
    selectedGenreIds.clear();
    await loadPopularMovies();
  }

  @action
  Future<void> _updateMoviesBySelectedGenres() async {
    if (selectedGenreIds.isEmpty) {
      await loadPopularMovies();
      return;
    }

    isLoading = true;
    errorMessage = null;
    searchQuery = '';
    currentPage = 1;
    hasMorePages = true;

    // UMA ÚNICA REQUISIÇÃO com todos os gêneros selecionados
    final result = await getMoviesByGenre(
      GenreParams(genreIds: selectedGenreIds.toList(), page: 1),
    );

    result.fold(
      (failure) {
        errorMessage = failure.message;
        isLoading = false;
      },
      (movieList) {
        movies = ObservableList.of(movieList);
        hasMorePages = movieList.length == 20;
        isLoading = false;
      },
    );
  }

  @action
  Future<void> searchMoviesByQuery(String query) async {
    if (query.trim().isEmpty) {
      await loadPopularMovies();
      return;
    }

    isLoading = true;
    errorMessage = null;
    searchQuery = query;
    selectedGenreIds.clear();
    currentPage = 1;
    hasMorePages = true;

    final result = await searchMovies(SearchParams(query: query, page: 1));

    result.fold(
      (failure) {
        errorMessage = failure.message;
        isLoading = false;
      },
      (movieList) {
        movies = ObservableList.of(movieList);
        hasMorePages = movieList.length == 20;
        isLoading = false;
      },
    );
  }

  @action
  Future<void> loadMoreMovies() async {
    if (isLoadingMore || !hasMorePages || isLoading) return;

    isLoadingMore = true;
    currentPage++;

    Either<Failure, List<Movie>>? result;

    // Decide qual método chamar baseado no estado atual
    if (searchQuery.isNotEmpty) {
      // Se está buscando
      result = await searchMovies(
        SearchParams(query: searchQuery, page: currentPage),
      );
    } else if (selectedGenreIds.isNotEmpty) {
      // Se tem gêneros selecionados
      result = await getMoviesByGenre(
        GenreParams(genreIds: selectedGenreIds.toList(), page: currentPage),
      );
    } else {
      // Filmes populares
      result = await getPopularMovies(PopularMoviesParams(page: currentPage));
    }

    result.fold(
      (failure) {
        errorMessage = failure.message;
        currentPage--; // Reverte página em caso de erro
        isLoadingMore = false;
      },
      (movieList) {
        movies.addAll(movieList);
        hasMorePages =
            movieList.length == 20; // Se retornou menos de 20, acabou
        isLoadingMore = false;
      },
    );
  }

  @action
  void searchWithDebounce(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      searchMoviesByQuery(query);
    });
  }

  @action
  void clearError() {
    errorMessage = null;
  }
}
