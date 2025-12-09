import 'package:mobx/mobx.dart';
import '../../domain/entities/movie.dart';
import '../../domain/usecases/get_movie_details.dart';

part 'movie_detail_store.g.dart';

class MovieDetailStore = _MovieDetailStoreBase with _$MovieDetailStore;

abstract class _MovieDetailStoreBase with Store {
  final GetMovieDetails getMovieDetails;

  _MovieDetailStoreBase({required this.getMovieDetails});

  // ==================== OBSERVAVEIS ====================

  @observable
  Movie? movie;

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  // ==================== COMPUTADOS ====================

  @computed
  bool get hasError => errorMessage != null;

  @computed
  bool get hasMovie => movie != null;

  // ==================== AÇÕES ====================

  @action
  Future<void> loadMovieDetails(int movieId) async {
    isLoading = true;
    errorMessage = null;

    final result = await getMovieDetails(MovieParams(movieId: movieId));

    result.fold(
      (failure) {
        errorMessage = failure.message;
        isLoading = false;
      },
      (movieData) {
        movie = movieData;
        isLoading = false;
      },
    );
  }

  @action
  void clearError() {
    errorMessage = null;
  }
}
