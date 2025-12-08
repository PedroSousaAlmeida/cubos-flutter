// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_list_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MovieListStore on _MovieListStoreBase, Store {
  Computed<bool>? _$hasErrorComputed;

  @override
  bool get hasError => (_$hasErrorComputed ??= Computed<bool>(
    () => super.hasError,
    name: '_MovieListStoreBase.hasError',
  )).value;
  Computed<bool>? _$hasMoviesComputed;

  @override
  bool get hasMovies => (_$hasMoviesComputed ??= Computed<bool>(
    () => super.hasMovies,
    name: '_MovieListStoreBase.hasMovies',
  )).value;
  Computed<bool>? _$hasGenresComputed;

  @override
  bool get hasGenres => (_$hasGenresComputed ??= Computed<bool>(
    () => super.hasGenres,
    name: '_MovieListStoreBase.hasGenres',
  )).value;
  Computed<bool>? _$hasSelectedGenresComputed;

  @override
  bool get hasSelectedGenres => (_$hasSelectedGenresComputed ??= Computed<bool>(
    () => super.hasSelectedGenres,
    name: '_MovieListStoreBase.hasSelectedGenres',
  )).value;

  late final _$moviesAtom = Atom(
    name: '_MovieListStoreBase.movies',
    context: context,
  );

  @override
  ObservableList<Movie> get movies {
    _$moviesAtom.reportRead();
    return super.movies;
  }

  @override
  set movies(ObservableList<Movie> value) {
    _$moviesAtom.reportWrite(value, super.movies, () {
      super.movies = value;
    });
  }

  late final _$genresAtom = Atom(
    name: '_MovieListStoreBase.genres',
    context: context,
  );

  @override
  ObservableList<Genre> get genres {
    _$genresAtom.reportRead();
    return super.genres;
  }

  @override
  set genres(ObservableList<Genre> value) {
    _$genresAtom.reportWrite(value, super.genres, () {
      super.genres = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_MovieListStoreBase.isLoading',
    context: context,
  );

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: '_MovieListStoreBase.errorMessage',
    context: context,
  );

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$selectedGenreIdsAtom = Atom(
    name: '_MovieListStoreBase.selectedGenreIds',
    context: context,
  );

  @override
  ObservableList<int> get selectedGenreIds {
    _$selectedGenreIdsAtom.reportRead();
    return super.selectedGenreIds;
  }

  @override
  set selectedGenreIds(ObservableList<int> value) {
    _$selectedGenreIdsAtom.reportWrite(value, super.selectedGenreIds, () {
      super.selectedGenreIds = value;
    });
  }

  late final _$searchQueryAtom = Atom(
    name: '_MovieListStoreBase.searchQuery',
    context: context,
  );

  @override
  String get searchQuery {
    _$searchQueryAtom.reportRead();
    return super.searchQuery;
  }

  @override
  set searchQuery(String value) {
    _$searchQueryAtom.reportWrite(value, super.searchQuery, () {
      super.searchQuery = value;
    });
  }

  late final _$loadInitialDataAsyncAction = AsyncAction(
    '_MovieListStoreBase.loadInitialData',
    context: context,
  );

  @override
  Future<void> loadInitialData() {
    return _$loadInitialDataAsyncAction.run(() => super.loadInitialData());
  }

  late final _$loadPopularMoviesAsyncAction = AsyncAction(
    '_MovieListStoreBase.loadPopularMovies',
    context: context,
  );

  @override
  Future<void> loadPopularMovies() {
    return _$loadPopularMoviesAsyncAction.run(() => super.loadPopularMovies());
  }

  late final _$loadGenresAsyncAction = AsyncAction(
    '_MovieListStoreBase.loadGenres',
    context: context,
  );

  @override
  Future<void> loadGenres() {
    return _$loadGenresAsyncAction.run(() => super.loadGenres());
  }

  late final _$toggleGenreAsyncAction = AsyncAction(
    '_MovieListStoreBase.toggleGenre',
    context: context,
  );

  @override
  Future<void> toggleGenre(int genreId) {
    return _$toggleGenreAsyncAction.run(() => super.toggleGenre(genreId));
  }

  late final _$clearGenreFiltersAsyncAction = AsyncAction(
    '_MovieListStoreBase.clearGenreFilters',
    context: context,
  );

  @override
  Future<void> clearGenreFilters() {
    return _$clearGenreFiltersAsyncAction.run(() => super.clearGenreFilters());
  }

  late final _$_updateMoviesBySelectedGenresAsyncAction = AsyncAction(
    '_MovieListStoreBase._updateMoviesBySelectedGenres',
    context: context,
  );

  @override
  Future<void> _updateMoviesBySelectedGenres() {
    return _$_updateMoviesBySelectedGenresAsyncAction.run(
      () => super._updateMoviesBySelectedGenres(),
    );
  }

  late final _$searchMoviesByQueryAsyncAction = AsyncAction(
    '_MovieListStoreBase.searchMoviesByQuery',
    context: context,
  );

  @override
  Future<void> searchMoviesByQuery(String query) {
    return _$searchMoviesByQueryAsyncAction.run(
      () => super.searchMoviesByQuery(query),
    );
  }

  late final _$_MovieListStoreBaseActionController = ActionController(
    name: '_MovieListStoreBase',
    context: context,
  );

  @override
  void clearError() {
    final _$actionInfo = _$_MovieListStoreBaseActionController.startAction(
      name: '_MovieListStoreBase.clearError',
    );
    try {
      return super.clearError();
    } finally {
      _$_MovieListStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
movies: ${movies},
genres: ${genres},
isLoading: ${isLoading},
errorMessage: ${errorMessage},
selectedGenreIds: ${selectedGenreIds},
searchQuery: ${searchQuery},
hasError: ${hasError},
hasMovies: ${hasMovies},
hasGenres: ${hasGenres},
hasSelectedGenres: ${hasSelectedGenres}
    ''';
  }
}
