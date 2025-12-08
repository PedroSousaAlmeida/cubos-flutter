import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/genre.dart';
import '../repositories/movie_repository.dart';

/// UseCase para buscar todos os gêneros disponíveis
class GetGenres implements UseCase<List<Genre>, NoParams> {
  final MovieRepository repository;

  GetGenres(this.repository);

  @override
  Future<Either<Failure, List<Genre>>> call(NoParams params) async {
    return await repository.getGenres();
  }
}