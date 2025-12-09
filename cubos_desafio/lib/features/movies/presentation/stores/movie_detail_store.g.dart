// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_detail_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MovieDetailStore on _MovieDetailStoreBase, Store {
  Computed<bool>? _$hasErrorComputed;

  @override
  bool get hasError => (_$hasErrorComputed ??= Computed<bool>(
    () => super.hasError,
    name: '_MovieDetailStoreBase.hasError',
  )).value;
  Computed<bool>? _$hasMovieComputed;

  @override
  bool get hasMovie => (_$hasMovieComputed ??= Computed<bool>(
    () => super.hasMovie,
    name: '_MovieDetailStoreBase.hasMovie',
  )).value;

  late final _$movieAtom = Atom(
    name: '_MovieDetailStoreBase.movie',
    context: context,
  );

  @override
  Movie? get movie {
    _$movieAtom.reportRead();
    return super.movie;
  }

  @override
  set movie(Movie? value) {
    _$movieAtom.reportWrite(value, super.movie, () {
      super.movie = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_MovieDetailStoreBase.isLoading',
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
    name: '_MovieDetailStoreBase.errorMessage',
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

  late final _$loadMovieDetailsAsyncAction = AsyncAction(
    '_MovieDetailStoreBase.loadMovieDetails',
    context: context,
  );

  @override
  Future<void> loadMovieDetails(int movieId) {
    return _$loadMovieDetailsAsyncAction.run(
      () => super.loadMovieDetails(movieId),
    );
  }

  late final _$_MovieDetailStoreBaseActionController = ActionController(
    name: '_MovieDetailStoreBase',
    context: context,
  );

  @override
  void clearError() {
    final _$actionInfo = _$_MovieDetailStoreBaseActionController.startAction(
      name: '_MovieDetailStoreBase.clearError',
    );
    try {
      return super.clearError();
    } finally {
      _$_MovieDetailStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
movie: ${movie},
isLoading: ${isLoading},
errorMessage: ${errorMessage},
hasError: ${hasError},
hasMovie: ${hasMovie}
    ''';
  }
}
