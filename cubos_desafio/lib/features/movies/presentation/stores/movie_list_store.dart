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

  // ==================== OBSERVABLES ====================

  @observable
  ObservableList<Movie> movies = ObservableList<Movie>();

  @observable
  ObservableList<Genre> genres = ObservableList<Genre>();

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @observable
  int? selectedGenreId;

  @observable
  String searchQuery = '';

  // ==================== COMPUTED ====================

  @computed
  bool get hasError => errorMessage != null;

  @computed
  bool get hasMovies => movies.isNotEmpty;

  @computed
  bool get hasGenres => genres.isNotEmpty;

  // ==================== ACTIONS ====================

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
        selectedGenreId = null;
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
  Future<void> filterByGenre(int genreId) async {
    if (selectedGenreId == genreId) {
      // Se clicar no mesmo gênero, volta para popular
      await loadPopularMovies();
      return;
    }

    isLoading = true;
    errorMessage = null;
    selectedGenreId = genreId;
    searchQuery = '';

    final result = await getMoviesByGenre(GenreParams(genreId: genreId));

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
  Future<void> searchMoviesByQuery(String query) async {
    if (query.trim().isEmpty) {
      await loadPopularMovies();
      return;
    }

    isLoading = true;
    errorMessage = null;
    searchQuery = query;
    selectedGenreId = null;

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
