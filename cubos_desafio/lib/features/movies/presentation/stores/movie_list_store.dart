import 'package:mobx/mobx.dart';
import '../../domain/entities/genre.dart';
import '../../domain/entities/movie.dart';
import '../../domain/usecases/get_genres.dart';
import '../../domain/usecases/get_movies_by_genre.dart';
import '../../domain/usecases/get_popular_movies.dart';
import '../../domain/usecases/search_movies.dart';
import '../../../../core/usecases/usecase.dart';

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
  String? errorMessage;

  @observable
  ObservableList<int> selectedGenreIds = ObservableList<int>();

  @observable
  String searchQuery = '';

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

    final result = await getPopularMovies(const NoParams());

    result.fold(
      (failure) {
        errorMessage = failure.message;
        isLoading = false;
      },
      (movieList) {
        movies = ObservableList.of(movieList);
        selectedGenreIds.clear();
        searchQuery = '';
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
  Future<void> toggleGenre(int genreId) async {
    if (selectedGenreIds.contains(genreId)) {
      selectedGenreIds.remove(genreId);
    } else {
      selectedGenreIds.add(genreId);
    }

    await _updateMoviesBySelectedGenres();
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

    List<Movie> allMovies = [];

    for (int genreId in selectedGenreIds) {
      final result = await getMoviesByGenre(GenreParams(genreId: genreId));

      result.fold(
        (failure) {
          errorMessage = failure.message;
        },
        (movieList) {
          allMovies.addAll(movieList);
        },
      );
    }
    
    final uniqueMovies = <int, Movie>{};
    for (var movie in allMovies) {
      uniqueMovies[movie.id] = movie;
    }

    movies = ObservableList.of(uniqueMovies.values.toList());
    isLoading = false;
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

    final result = await searchMovies(SearchParams(query: query));

    result.fold(
      (failure) {
        errorMessage = failure.message;
        isLoading = false;
      },
      (movieList) {
        movies = ObservableList.of(movieList);
        isLoading = false;
      },
    );
  }

  @action
  void clearError() {
    errorMessage = null;
  }
}
