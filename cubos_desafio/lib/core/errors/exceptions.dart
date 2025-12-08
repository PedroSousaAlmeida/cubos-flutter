class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'Erro no servidor']);

  @override
  String toString() => message;
}

class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'Erro ao acessar dados salvos']);

  @override
  String toString() => message;
}

class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'Sem conexão com a internet']);

  @override
  String toString() => message;
}
