import 'package:dartz/dartz.dart';
import '../errors/failures.dart';

/// Interface base para todos os Use Cases
///
/// [Type] - Tipo de retorno do use case
/// [Params] - Parâmetros necessários para executar o use case
abstract class UseCase<T, Params> {
  /// Executa o caso de uso
  ///
  /// Retorna [Right] com o resultado em caso de sucesso
  /// Retorna [Left] com [Failure] em caso de erro
  Future<Either<Failure, T>> call(Params params);
}

/// Classe para use cases que não precisam de parâmetros
class NoParams {
  const NoParams();
}
