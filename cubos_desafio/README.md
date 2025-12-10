# Cubos Desafio - App de Filmes TMDB

> App Flutter de exploração de filmes usando a API do TMDB (The Movie Database), desenvolvido com Clean Architecture, MobX e cache offline.

![Flutter](https://img.shields.io/badge/Flutter-3.10.3-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.10.3-0175C2?logo=dart)
![MobX](https://img.shields.io/badge/State-MobX-orange)
![Architecture](https://img.shields.io/badge/Architecture-Clean-green)

---

## Índice

1. [Sobre o Projeto](#-sobre-o-projeto)
2. [Funcionalidades](#-funcionalidades)
3. [Arquitetura](#-arquitetura)
4. [Tecnologias e Bibliotecas](#-tecnologias-e-bibliotecas)
5. [Como Rodar](#-como-rodar)
6. [Estrutura de Pastas](#-estrutura-de-pastas)
7. [Documentação Técnica Detalhada](#-documentação-técnica-detalhada)
   - [CORE (Infraestrutura)](#core-infraestrutura-compartilhada)
   - [FEATURES - Movies](#features-movies)
   - [ROOT Files](#root-files)
8. [Fluxos de Dados](#-fluxos-de-dados)
9. [Como Escalar o Projeto](#-como-escalar-o-projeto)
10. [Testes](#-testes)

---

## Sobre o Projeto

App mobile desenvolvido em Flutter para explorar filmes populares do TMDB (The Movie Database).

**O que o app faz:**
- Lista filmes populares com paginação infinita
- Busca filmes por texto (debounce 500ms)
- Filtra por múltiplos gêneros simultâneos
- Exibe detalhes completos (elenco, diretor, orçamento, produtoras)
- Funciona OFFLINE (cache de 1 hora)

**Exemplo do dia a dia:**

Imagine que você está no metrô sem internet. O app mostra os últimos filmes populares que você viu quando tinha conexão. Ao voltar online, atualiza automaticamente.

---

## Funcionalidades

### Listagem de Filmes Populares
- Grid 2 colunas com scroll infinito
- Carrega próxima página aos 80% do scroll
- Imagens cacheadas (sem re-download)

### Busca Inteligente
- Debounce de 500ms (evita requests excessivos)
- Limpa filtros de gênero ao buscar
- Funciona apenas online

### Filtro Multi-Gênero
- Seleção múltipla de gêneros
- Combinação entre gêneros selecionados
- Offline: filtra cache local

### Detalhes do Filme
- Rating, ano, duração
- Descrição, elenco (top 5), diretor
- Orçamento formatado (ex: $150,000,000)
- Produtoras
- Hero animation no poster

### Cache Offline
- TTL: 1 hora
- Armazena: filmes populares (página 1), gêneros, detalhes visualizados
- Hive (local storage)

---

## Arquitetura

### Clean Architecture + MobX

O projeto segue **Clean Architecture** (Uncle Bob) dividido em 3 camadas:

```
┌─────────────────────────────────────────────────────┐
│  PRESENTATION (UI)                                  │
│  - Pages (Telas)                                    │
│  - Stores (MobX State Management)                   │
│  - Widgets (Componentes reutilizáveis)              │
│                                                      │
│  Responsabilidade: Exibir dados e captar input      │
└─────────────────────────────────────────────────────┘
                      ↓ (chama)
┌─────────────────────────────────────────────────────┐
│  DOMAIN (Regras de Negócio)                         │
│  - Entities (Objetos puros sem dependências)        │
│  - Repositories (Contratos/Interfaces)              │
│  - Use Cases (Casos de Uso = Ações do usuário)      │
│                                                      │
│  Responsabilidade: Lógica de negócio PURA           │
└─────────────────────────────────────────────────────┘
                      ↓ (implementa)
┌─────────────────────────────────────────────────────┐
│  DATA (Acesso a Dados)                              │
│  - Models (Entities + fromJson/toJson)              │
│  - DataSources (Remote API / Local Cache)           │
│  - Repository Implementation (Lógica offline-first) │
│                                                      │
│  Responsabilidade: Buscar e persistir dados         │
└─────────────────────────────────────────────────────┘
```

**Exemplo do dia a dia:**

É como um restaurante:
- **Presentation** = Garçom (interage com cliente)
- **Domain** = Cardápio e regras (o que pode ser pedido)
- **Data** = Cozinha (busca os ingredientes e prepara)

---

## Tecnologias e Bibliotecas

### Bibliotecas de Produção

| Biblioteca | Versão | Função | Por que foi escolhida? | Exemplo no Projeto |
|-----------|--------|--------|------------------------|-------------------|
| **mobx** | 2.5.0 | State Management Reativo | Reatividade automática com `@observable`/`@action`, menos boilerplate que Provider puro | `movie_list_store.dart`: `@observable ObservableList<Movie> movies` atualiza UI automaticamente |
| **flutter_mobx** | 2.3.0 | Widgets reativos do MobX | `Observer` widget que reconstrói apenas quando observables mudam | `Observer(builder: (_) => Text(store.movies.length))` |
| **dio** | 5.9.0 | Cliente HTTP | Interceptors, timeout configurável, melhor que http nativo | `api_client.dart`: Bearer token automático em todas as requests |
| **hive** | 2.2.3 | Banco NoSQL local | Rápido (até 10x mais que SQLite), sem migrations, key-value | `movie_local_datasource.dart`: Armazena filmes em boxes |
| **hive_flutter** | 1.1.0 | Inicialização Hive | `Hive.initFlutter()` com path correto | `injection_container.dart` |
| **get_it** | 9.2.0 | Service Locator (DI) | Singleton global acessível, evita prop-drilling | `sl<MovieListStore>()` injeta dependências |
| **dartz** | 0.10.1 | Either pattern | `Either<Failure, Success>` para error handling funcional | `Future<Either<Failure, List<Movie>>>` retorna erro OU sucesso |
| **equatable** | 2.0.5 | Value equality | Compara objetos por propriedades, não por referência | `Movie extends Equatable`: compara filmes por ID |
| **internet_connection_checker** | 3.0.1 | Detecta conexão real | Testa conectividade real (não só WiFi ligado) | `network_info.dart`: verifica antes de API calls |
| **provider** | 6.1.5 | DI no widget tree | Injeta stores no contexto do Flutter | `Provider<MovieListStore>(create: (_) => sl())` |
| **flutter_dotenv** | 6.0.0 | Variáveis de ambiente | Esconde API keys do código | `dotenv.env['TMDB_BEARER_TOKEN']` |
| **cached_network_image** | 3.4.1 | Cache de imagens | Baixa uma vez, exibe offline | `CachedNetworkImage(imageUrl: movie.fullPosterPath)` |
| **intl** | 0.19.0 | Formatação (datas, moedas) | Formata orçamento: `$150,000,000` | `NumberFormat.currency()` em `movie_detail_page.dart` |

### Bibliotecas de Desenvolvimento

| Biblioteca | Versão | Função |
|-----------|--------|--------|
| **build_runner** | 2.10.4 | Executa code generators |
| **mobx_codegen** | 2.7.4 | Gera código MobX (`.g.dart`) |
| **mockito** | 5.6.1 | Mocks para testes unitários |
| **flutter_lints** | 6.0.0 | Linter rules do Google |

---

## Como Rodar

### Pré-requisitos
- Flutter SDK 3.10.3+
- Dart SDK 3.10.3+
- Conta no TMDB (API key gratuita)

### Passo a Passo

**1. Clone o repositório**
```bash
git clone <repo-url>
cd cubos_desafio
```

**2. Configure o .env**

Crie um arquivo `.env` na raiz do projeto:
```bash
echo "TMDB_BEARER_TOKEN='seu_token_aqui'" > .env
```

Para obter o token:
- Acesse https://www.themoviedb.org/
- Crie uma conta
- Vá em Settings > API > Create API Key (Read Access Token)

**3. Instale dependências**
```bash
flutter pub get
```

**4. Gere código MobX**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

**5. Execute o app**
```bash
flutter run
```

### Comandos Úteis

```bash
# Re-gerar código MobX em watch mode
flutter pub run build_runner watch

# Executar testes
flutter test

# Build APK
flutter build apk --release

# Analisar código
flutter analyze
```

---

## Estrutura de Pastas

```
lib/
├── core/                          # Infraestrutura compartilhada
│   ├── constants/
│   │   └── api_constants.dart     # URLs, tokens, configurações API
│   ├── errors/
│   │   ├── exceptions.dart        # Exceptions (camada Data)
│   │   └── failures.dart          # Failures (camada Domain)
│   ├── network/
│   │   ├── api_client.dart        # Cliente Dio configurado
│   │   └── network_info.dart      # Verifica conexão internet
│   └── usecases/
│       └── usecase.dart           # Interface base de Use Cases
│
├── features/                      # Features do app (separadas)
│   └── movies/                    # Feature: Filmes
│       ├── domain/                # Regras de negócio PURAS
│       │   ├── entities/          # Objetos sem lógica de framework
│       │   │   ├── movie.dart     # Entidade Movie
│       │   │   ├── genre.dart     # Entidade Genre
│       │   │   ├── cast.dart      # Entidade Cast (ator)
│       │   │   ├── crew.dart      # Entidade Crew (equipe)
│       │   │   └── production_company.dart
│       │   ├── repositories/      # Contratos (interfaces)
│       │   │   └── movie_repository.dart
│       │   └── usecases/          # Casos de uso (ações)
│       │       ├── get_popular_movies.dart
│       │       ├── get_genres.dart
│       │       ├── get_movie_details.dart
│       │       ├── get_movies_by_genre.dart
│       │       └── search_movies.dart
│       │
│       ├── data/                  # Acesso a dados
│       │   ├── models/            # Models com serialização
│       │   │   ├── movie_model.dart     # fromJson/toJson
│       │   │   ├── genre_model.dart
│       │   │   ├── cast_model.dart
│       │   │   ├── crew_model.dart
│       │   │   └── production_company_model.dart
│       │   ├── datasources/       # Fontes de dados
│       │   │   ├── movie_remote_datasource.dart  # API TMDB
│       │   │   └── movie_local_datasource.dart   # Hive cache
│       │   └── repositories/      # Implementação dos contratos
│       │       └── movie_repo_impl.dart  # Lógica offline-first
│       │
│       └── presentation/          # Interface do usuário
│           ├── pages/
│           │   ├── movie_list_page.dart     # Tela principal (grid)
│           │   └── movie_detail_page.dart   # Tela de detalhes
│           ├── stores/            # MobX state management
│           │   ├── movie_list_store.dart    # Estado da listagem
│           │   ├── movie_list_store.g.dart  # Gerado pelo MobX
│           │   ├── movie_detail_store.dart  # Estado dos detalhes
│           │   └── movie_detail_store.g.dart
│           └── widgets/           # Componentes reutilizáveis
│               ├── movie_card.dart          # Card de filme (grid)
│               └── genre_tabs.dart          # Filtros de gênero
│
├── injection_container.dart       # Configuração GetIt (DI)
├── app.dart                       # MyApp (MaterialApp setup)
└── main.dart                      # Entry point
```

**Analogia do dia a dia:**

Imagine a estrutura como uma empresa:

- **core/** = RH e TI (recursos compartilhados por todos)
- **features/movies/domain/** = CEO e diretoria (regras de negócio)
- **features/movies/data/** = Departamento de logística (busca/armazena dados)
- **features/movies/presentation/** = Atendimento ao cliente (interface)

---

## Documentação Técnica Detalhada

---

### CORE (Infraestrutura Compartilhada)

#### core/constants/api_constants.dart

**O que faz:**
Define todas as URLs, endpoints e configurações da API TMDB em um único lugar.

**Por que existe:**
Se a API mudar (ex: `v3` → `v4`), você altera em 1 arquivo, não em 20.

**Exemplo do dia a dia:**
É como o catálogo de endereços de uma empresa de entregas. Todos os entregadores consultam o mesmo catálogo.

**Principais constantes:**
```dart
static const String baseUrl = 'https://api.themoviedb.org/3';
static const String imageBaseUrl = 'https://image.tmdb.org/t/p';
static String get bearerToken => dotenv.env['TMDB_BEARER_TOKEN'] ?? '';

// Endpoints
static const String popularMovies = '/movie/popular';
static const String searchMovies = '/search/movie';
static const String movieDetails = '/movie';
static const String genres = '/genre/movie/list';
static const String discoverMovies = '/discover/movie';

// Tamanhos de imagem
static const String posterSize = 'w500';      // 500px largura
static const String backdropSize = 'original'; // Qualidade máxima
```

---

#### core/errors/failures.dart

**O que faz:**
Define tipos de erro na **camada Domain** (regras de negócio).

**Por que existe:**
Domain não pode conhecer Exceptions (que são da camada Data). Usa Failures abstratos.

**Exemplo do dia a dia:**
No cardápio de um restaurante, você vê "Indisponível" (Failure), não "Cozinha quebrou o fogão" (Exception). A UI só precisa saber que falhou, não o motivo técnico.

**Tipos de Failure:**
- `ServerFailure` - Erro 500, 404, timeout da API
- `CacheFailure` - Hive corrompido, sem dados em cache
- `NetworkFailure` - Sem conexão com internet
- `ValidationFailure` - Dados inválidos (ex: query vazia)

**Uso:**
```dart
return Left(NetworkFailure('Sem conexão com internet'));
```

---

#### core/errors/exceptions.dart

**O que faz:**
Define tipos de Exception na **camada Data** (acesso a dados).

**Por que existe:**
DataSources lançam Exceptions. Repository captura e converte em Failures.

**Exemplo do dia a dia:**
A cozinha (Data) grita "Fogão quebrou!" (Exception). O garçom (Repository) traduz para o cliente "Prato indisponível" (Failure).

**Tipos de Exception:**
- `ServerException` - DioException, status code != 200
- `CacheException` - HiveError, cache expirado
- `NetworkException` - Sem conectividade

---

#### core/network/api_client.dart

**O que faz:**
Configura o cliente HTTP Dio com:
- Bearer token automático em todas as requests
- Timeout de 30 segundos
- LogInterceptor (apenas em debug)
- BaseURL e language padrão

**Por que existe:**
Evita configurar Dio manualmente em cada DataSource.

**Exemplo do dia a dia:**
É como configurar o GPS do seu carro uma vez. Toda viagem já sai com as preferências salvas.

**Configuração:**
```dart
Dio(
  BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',
    headers: {
      'Authorization': 'Bearer ${ApiConstants.bearerToken}',
      'accept': 'application/json',
    },
    queryParameters: {'language': 'en-US'},
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ),
)
```

---

#### core/network/network_info.dart

**O que faz:**
Verifica se há conexão REAL com a internet (não só WiFi ligado).

**Por que existe:**
WiFi pode estar conectado mas sem internet. Este checker testa com ping real.

**Exemplo do dia a dia:**
Você vê que o WiFi está ligado (ícone no celular), mas ao abrir o browser não carrega nada. Este checker detecta isso.

**Interface:**
```dart
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker connectionChecker;

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}
```

**Uso:**
```dart
if (await networkInfo.isConnected) {
  // Chama API
} else {
  // Usa cache
}
```

---

#### core/usecases/usecase.dart

**O que faz:**
Interface base para todos os Use Cases.

**Por que existe:**
Padroniza assinatura: `call(Params) → Either<Failure, Result>`

**Exemplo do dia a dia:**
É como o formulário padrão de pedido em uma empresa. Todo departamento usa o mesmo formato.

**Interface:**
```dart
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

// Parâmetros vazios
class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
```

**Uso:**
```dart
class GetPopularMovies implements UseCase<List<Movie>, PopularMoviesParams> {
  @override
  Future<Either<Failure, List<Movie>>> call(PopularMoviesParams params) {
    return repository.getPopularMovies(page: params.page);
  }
}
```

---

### FEATURES - MOVIES

---

#### features/movies/domain/entities/

**Arquivo: movie.dart**

**O que faz:**
Define a entidade Movie (objeto de negócio PURO, sem dependências de Flutter/API).

**Por que existe:**
Domain deve ser independente de frameworks. Se trocar de API, a entidade Movie permanece a mesma.

**Exemplo do dia a dia:**
É a ficha de um produto no estoque. Não importa se você vendeu online ou na loja física, o produto é o mesmo.

**Propriedades principais:**
```dart
class Movie extends Equatable {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final int voteCount;
  final double popularity;
  final List<int> genreIds;
  final List<Cast> cast;
  final List<Crew> crew;
  final List<ProductionCompany> productionCompanies;

  // Métodos computed
  String? get fullPosterPath =>
    posterPath != null
      ? '${ApiConstants.imageBaseUrl}/${ApiConstants.posterSize}$posterPath'
      : null;
}
```

**Equatable:**
Compara Movies por propriedades, não por referência. Útil para MobX detectar mudanças.

---

**Arquivo: genre.dart**

**O que faz:**
Entidade Genre (Ação, Comédia, Drama, etc.)

**Por que existe:**
Gêneros são usados para filtrar filmes.

**Exemplo do dia a dia:**
Categorias de um supermercado (Laticínios, Bebidas, Higiene).

---

**Arquivos: cast.dart, crew.dart, production_company.dart**

Similar: Entidades para ator, equipe (diretor, roteirista) e produtoras.

---

#### features/movies/domain/repositories/movie_repository.dart

**O que faz:**
Define o **CONTRATO** de como acessar dados de filmes. É uma interface abstrata.

**Por que existe:**
Domain não sabe COMO buscar dados (API? Cache?), apenas DEFINE o que deve retornar.

**Exemplo do dia a dia:**
É o cardápio de um restaurante. Diz O QUE você pode pedir, não COMO a cozinha vai preparar.

**Métodos:**
```dart
abstract class MovieRepository {
  Future<Either<Failure, List<Movie>>> getPopularMovies({int page = 1});
  Future<Either<Failure, Movie>> getMovieDetails(int movieId);
  Future<Either<Failure, List<Movie>>> searchMovies(String query, {int page = 1});
  Future<Either<Failure, List<Genre>>> getGenres();
  Future<Either<Failure, List<Movie>>> getMoviesByGenre(int genreId, {int page = 1});
  Future<Either<Failure, List<Movie>>> getMoviesByGenres(List<int> genreIds, {int page = 1});
}
```

**Either Pattern:**
Retorna `Left(Failure)` em erro ou `Right(Data)` em sucesso. Força tratar erros explicitamente.

---

#### features/movies/domain/usecases/

**Arquivo: get_popular_movies.dart**

**O que faz:**
Caso de uso: buscar filmes populares.

**Por que existe:**
Use Cases encapsulam AÇÕES do usuário. "Quando o usuário abre o app → carrega filmes populares".

**Exemplo do dia a dia:**
Você entra na Netflix → caso de uso "Mostrar filmes em alta".

**Implementação:**
```dart
class GetPopularMovies implements UseCase<List<Movie>, PopularMoviesParams> {
  final MovieRepository repository;

  GetPopularMovies(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(PopularMoviesParams params) async {
    return await repository.getPopularMovies(page: params.page);
  }
}

class PopularMoviesParams extends Equatable {
  final int page;

  const PopularMoviesParams({this.page = 1});

  @override
  List<Object> get props => [page];
}
```

**Outros Use Cases:**
- `get_genres.dart` - Carrega gêneros (Ação, Comédia...)
- `get_movie_details.dart` - Busca detalhes de 1 filme (com cast, crew)
- `get_movies_by_genre.dart` - Filtra por gêneros
- `search_movies.dart` - Busca por texto

---

#### features/movies/data/models/

**Arquivo: movie_model.dart**

**O que faz:**
Model que extende Movie (entidade) + adiciona `fromJson` e `toJson`.

**Por que existe:**
API retorna JSON. Precisamos converter JSON ↔ Objeto Dart.

**Exemplo do dia a dia:**
É como traduzir um documento em inglês (JSON da API) para português (objeto Movie).

**Implementação:**
```dart
class MovieModel extends Movie {
  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? 'Sem título',
      overview: json['overview'] as String? ?? '',
      posterPath: json['poster_path'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      genreIds: _parseGenreIds(json),
      cast: _parseCast(json),
      crew: _parseCrew(json),
      // ...
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      // ...
    };
  }
}
```

**Destaques:**
- Trata 2 formatos de gêneros (lista de IDs vs lista de objetos)
- Extrai `cast`/`crew` de `credits` nested
- Valores padrão (`?? 0`, `?? ''`) evitam null exceptions

---

#### features/movies/data/datasources/

**Arquivo: movie_remote_datasource.dart**

**O que faz:**
Acessa a API TMDB via Dio.

**Por que existe:**
Separa lógica de rede da lógica de negócio.

**Exemplo do dia a dia:**
É o entregador que busca produtos no fornecedor (API).

**Métodos principais:**
```dart
@override
Future<List<MovieModel>> getPopularMovies({int page = 1}) async {
  try {
    final response = await dio.get(
      ApiConstants.popularMovies,
      queryParameters: {'page': page},
    );

    if (response.statusCode == 200) {
      final results = response.data['results'] as List;
      return results.map((json) => MovieModel.fromJson(json)).toList();
    } else {
      throw ServerException('Erro ao buscar filmes populares');
    }
  } on DioException catch (e) {
    throw ServerException(e.message ?? 'Erro de servidor');
  }
}

@override
Future<MovieModel> getMovieDetails(int movieId) async {
  final response = await dio.get(
    '${ApiConstants.movieDetails}/$movieId',
    queryParameters: {'append_to_response': 'credits'},
  );
  // 'credits' retorna cast e crew no mesmo response
  return MovieModel.fromJson(response.data);
}

@override
Future<List<MovieModel>> getMoviesByGenres(List<int> genreIds, {int page = 1}) async {
  final genresParam = genreIds.join(',');
  final response = await dio.get(
    ApiConstants.discoverMovies,
    queryParameters: {'with_genres': genresParam, 'page': page},
  );
  // Retorna filmes que contêm os gêneros especificados
  final results = response.data['results'] as List;
  return results.map((json) => MovieModel.fromJson(json)).toList();
}
```

**Endpoints usados:**
- `GET /movie/popular?page=1`
- `GET /search/movie?query=batman&page=1`
- `GET /movie/123?append_to_response=credits`
- `GET /genre/movie/list`
- `GET /discover/movie?with_genres=28,12`

---

**Arquivo: movie_local_datasource.dart**

**O que faz:**
Armazena e recupera dados do cache Hive.

**Por que existe:**
Permite funcionamento offline.

**Exemplo do dia a dia:**
É o estoque local da loja. Se o fornecedor não entregar (sem internet), você usa o estoque.

**TTL (Time To Live):**
Cache expira após 1 hora (3.600.000 ms).

**Boxes Hive:**
- `movies` - Filmes populares (página 1)
- `movie_details` - Detalhes de filmes visualizados
- `genres` - Lista de gêneros
- `cache_meta` - Timestamps (controle de expiração)

**Implementação:**
```dart
static const int cacheTTL = 60 * 60 * 1000; // 1 hora

Future<bool> _isCacheValid(String key) async {
  final metaBox = await Hive.openBox<int>(cacheMetaBoxName);
  final timestamp = metaBox.get(key);

  if (timestamp == null) return false;

  final now = DateTime.now().millisecondsSinceEpoch;
  return (now - timestamp) < cacheTTL;
}

@override
Future<List<MovieModel>> getCachedMovies() async {
  if (!await _isCacheValid('movies')) {
    throw CacheException('Cache expirado');
  }

  final box = await Hive.openBox<Map>(moviesBoxName);
  final cachedMovies = box.values.toList();

  if (cachedMovies.isEmpty) {
    throw CacheException('Nenhum filme em cache');
  }

  return cachedMovies
      .map((json) => MovieModel.fromJson(Map<String, dynamic>.from(json)))
      .toList();
}

@override
Future<void> cacheMovies(List<MovieModel> movies) async {
  final box = await Hive.openBox<Map>(moviesBoxName);
  await box.clear();

  final moviesMap = <int, Map<String, dynamic>>{};
  for (var i = 0; i < movies.length; i++) {
    moviesMap[i] = movies[i].toJson();
  }
  await box.putAll(moviesMap);

  await _updateCacheTimestamp('movies');
}
```

**Estratégia de cache:**
- **Popular movies / Genres**: TTL de 1 hora (se expirar, refetch)
- **Movie Details**: Sem expiração (ficam salvos até limpar app)
- **Search results**: NÃO são cacheados (sempre busca nova)

---

#### features/movies/data/repositories/movie_repo_impl.dart

**O que faz:**
Implementa o contrato `MovieRepository` com lógica **offline-first**.

**Por que existe:**
Orquestra RemoteDataSource e LocalDataSource. Decide quando usar cache ou API.

**Exemplo do dia a dia:**
É o gerente da loja. Decide: "Tem no estoque? Usa. Senão, pede pro fornecedor."

**Fluxo offline-first:**
```
1. Verifica internet
   ├─ COM internet → chama API → salva em cache → retorna
   └─ SEM internet → tenta cache → se cache válido, retorna
```

**Implementação:**
```dart
@override
Future<Either<Failure, List<Movie>>> getPopularMovies({int page = 1}) async {
  if (await networkInfo.isConnected) {
    try {
      final remoteMovies = await remoteDataSource.getPopularMovies(page: page);

      // Cacheia apenas página 1 (para offline)
      if (page == 1) {
        await localDataSource.cacheMovies(remoteMovies);
      }

      return Right(remoteMovies);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  } else {
    // Sem internet
    if (page == 1) {
      try {
        final localMovies = await localDataSource.getCachedMovies();
        return Right(localMovies);
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    } else {
      // Paginação requer internet
      return const Left(NetworkFailure('Paginação requer conexão'));
    }
  }
}
```

**Lógica de filtro offline:**
Quando offline, filtra filmes em cache pelos gêneros selecionados:
```dart
@override
Future<Either<Failure, List<Movie>>> getMoviesByGenres(
  List<int> genreIds,
  {int page = 1}
) async {
  if (await networkInfo.isConnected) {
    // Chama API
    final movies = await remoteDataSource.getMoviesByGenres(genreIds, page: page);
    return Right(movies);
  } else {
    // Filtra cache local
    final allMovies = await localDataSource.getCachedMovies();
    final filteredMovies = allMovies.where(
      (movie) => movie.genreIds.any((id) => genreIds.contains(id))
    ).toList();
    return Right(filteredMovies);
  }
}
```

---

#### features/movies/presentation/stores/

**Arquivo: movie_list_store.dart**

**O que faz:**
Gerencia ESTADO da tela de listagem com MobX.

**Por que existe:**
Centraliza lógica de UI: loading, erros, dados, filtros.

**Exemplo do dia a dia:**
É o painel de controle da interface. Mostra status (carregando, erro, sucesso) e permite ações (buscar, filtrar).

**Observables (Estado reativo):**
```dart
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
```

**Computed (Valores derivados):**
```dart
@computed
bool get hasError => errorMessage != null;

@computed
bool get hasMovies => movies.isNotEmpty;

@computed
bool get hasGenres => genres.isNotEmpty;

@computed
bool get hasSelectedGenres => selectedGenreIds.isNotEmpty;
```

**Actions (Modificam estado):**
```dart
@action
Future<void> loadPopularMovies() async {
  isLoading = true;
  errorMessage = null;

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
      currentPage = 1;
      hasMorePages = true;
      isLoading = false;
    },
  );
}

@action
void toggleGenre(int genreId) {
  final currentIds = selectedGenreIds.toList();

  if (currentIds.contains(genreId)) {
    currentIds.remove(genreId);
  } else {
    currentIds.add(genreId);
  }

  selectedGenreIds = ObservableList.of(currentIds);
  _updateMoviesBySelectedGenres();
}

@action
Future<void> loadMoreMovies() async {
  if (isLoadingMore || !hasMorePages || isLoading) return;

  isLoadingMore = true;
  currentPage++;

  // Determina qual busca fazer
  final result = searchQuery.isNotEmpty
      ? await searchMovies(SearchParams(query: searchQuery, page: currentPage))
      : hasSelectedGenres
          ? await getMoviesByGenre(GenreParams(genreIds: selectedGenreIds.toList(), page: currentPage))
          : await getPopularMovies(PopularMoviesParams(page: currentPage));

  result.fold(
    (failure) {
      currentPage--;
      isLoadingMore = false;
    },
    (movieList) {
      movies.addAll(movieList);
      hasMorePages = movieList.length == 20;
      isLoadingMore = false;
    },
  );
}
```

**Debounce em busca:**
```dart
Timer? _debounceTimer;

@action
void searchWithDebounce(String query) {
  _debounceTimer?.cancel();
  _debounceTimer = Timer(const Duration(milliseconds: 500), () {
    searchMoviesByQuery(query);
  });
}
```

---

**Arquivo: movie_detail_store.dart**

Similar, mas para tela de detalhes:
- `@observable Movie? movie`
- `@observable bool isLoading`
- `@action loadMovieDetails(int movieId)`

---

#### 📂 features/movies/presentation/pages/

**Arquivo: movie_list_page.dart**

**O que faz:**
Tela principal com grid de filmes.

**Componentes:**
- `AppBar` com barra de busca
- `GenreTabs` (filtros horizontais)
- `GridView.builder` (2 colunas)
- Infinite scroll (detecta 80% do scroll)

**Infinite scroll:**
```dart
void _onScroll(MovieListStore store) {
  final maxScroll = _scrollController.position.maxScrollExtent;
  final currentScroll = _scrollController.position.pixels;
  final delta = 0.8 * maxScroll;

  if (currentScroll >= delta) {
    store.loadMoreMovies();
  }
}
```

**Observer pattern:**
```dart
Observer(
  builder: (_) {
    if (store.isLoading && !store.hasMovies) {
      return const Center(child: CircularProgressIndicator());
    }

    if (store.hasError && !store.hasMovies) {
      return ErrorWidget(
        message: store.errorMessage,
        onRetry: () => store.loadPopularMovies(),
      );
    }

    return GridView.builder(
      controller: _scrollController,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
      ),
      itemCount: store.movies.length + (store.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= store.movies.length) {
          return const Center(child: CircularProgressIndicator());
        }
        return MovieCard(movie: store.movies[index], genres: store.genres);
      },
    );
  },
)
```

---

**Arquivo: movie_detail_page.dart**

**O que faz:**
Tela de detalhes de um filme.

**Seções:**
- Poster com Hero animation
- Rating (nota/10)
- Título e título original
- Ano e duração (chips)
- Gêneros (chips)
- Descrição completa
- Orçamento formatado
- Produtoras
- Diretor
- Elenco (top 5 atores)

**Formatação de orçamento:**
```dart
String _formatBudget(double budget) {
  final formatter = NumberFormat.currency(
    locale: 'en_US',
    symbol: '\$',
    decimalDigits: 0,
  );
  return formatter.format(budget); // Ex: $150,000,000
}
```

**Hero animation:**
```dart
Hero(
  tag: 'movie-${movie.id}',
  child: CachedNetworkImage(
    imageUrl: movie.fullPosterPath ?? '',
    placeholder: (context, url) => const CircularProgressIndicator(),
    errorWidget: (context, url, error) => const Icon(Icons.error),
  ),
)
```

---

#### features/movies/presentation/widgets/

**Arquivo: movie_card.dart**

**O que faz:**
Card reutilizável de filme (usado no grid).

**Componentes:**
- Poster com `CachedNetworkImage`
- Título (max 2 linhas)
- Gêneros (max 2, separados por " • ")
- Rating (estrela + nota)
- Hero animation

**Implementação:**
```dart
String _getGenreNames() {
  return genres
      .where((genre) => movie.genreIds.contains(genre.id))
      .map((genre) => genre.name)
      .take(2)
      .join(' • ');
}

Widget build(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MovieDetailPage(movieId: movie.id),
        ),
      );
    },
    child: Card(
      child: Column(
        children: [
          Hero(
            tag: 'movie-${movie.id}',
            child: CachedNetworkImage(imageUrl: movie.fullPosterPath),
          ),
          Text(movie.title, maxLines: 2),
          Text(_getGenreNames()),
          Row(
            children: [
              Icon(Icons.star, color: Colors.amber),
              Text('${movie.voteAverage}/10'),
            ],
          ),
        ],
      ),
    ),
  );
}
```

---

**Arquivo: genre_tabs.dart**

**O que faz:**
ListView horizontal de FilterChips (gêneros).

**Features:**
- Chip "Todos" sempre visível
- Múltipla seleção
- Observer individual por chip (performance)

**Implementação:**
```dart
Observer(
  builder: (_) {
    final isSelected = store.selectedGenreIds.contains(genre.id);

    return FilterChip(
      label: Text(genre.name),
      selected: isSelected,
      onSelected: (_) => store.toggleGenre(genre.id),
      selectedColor: Colors.blue,
      backgroundColor: Colors.grey[200],
    );
  },
)
```

**Por que Observer individual?**
Causa re-renderização APENAS do chip que mudou, não de toda a lista. Performance otimizada.

---

### ROOT FILES

#### main.dart

**O que faz:**
Entry point do app.

**Fluxo:**
1. `WidgetsFlutterBinding.ensureInitialized()`
2. Carrega `.env` com `dotenv.load()`
3. Inicializa DI com `di.init()`
4. `runApp(MyApp())`

**Implementação:**
```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  await di.init();

  runApp(
    Provider<MovieListStore>(
      create: (_) => di.sl<MovieListStore>(),
      child: const MyApp(),
    ),
  );
}
```

---

#### app.dart

**O que faz:**
Widget `MyApp` com configuração do MaterialApp.

**Configuração:**
```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cubos Desafio',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MovieListPage(),
    );
  }
}
```

---

#### injection_container.dart

**O que faz:**
Configura todas as injeções de dependência com GetIt.

**Por que existe:**
Centraliza registro de dependências. Facilita testes e manutenção.

**Ordem de registro:**
1. Features (Stores, UseCases, Repositories, DataSources)
2. Core (NetworkInfo, ApiClient)
3. External (InternetConnectionChecker, Hive)

**Tipos de registro:**
- `registerFactory` - Nova instância a cada chamada (Stores)
- `registerLazySingleton` - Singleton criado apenas quando usado (UseCases, Repositories)

**Implementação:**
```dart
final sl = GetIt.instance;

Future<void> init() async {
  // ==================== STORES ====================

  sl.registerFactory(
    () => MovieListStore(
      getPopularMovies: sl(),
      getGenres: sl(),
      getMoviesByGenre: sl(),
      searchMovies: sl(),
    ),
  );

  sl.registerFactory(
    () => MovieDetailStore(getMovieDetails: sl()),
  );

  // ==================== USE CASES ====================

  sl.registerLazySingleton(() => GetPopularMovies(sl()));
  sl.registerLazySingleton(() => GetGenres(sl()));
  sl.registerLazySingleton(() => GetMovieDetails(sl()));
  sl.registerLazySingleton(() => GetMoviesByGenre(sl()));
  sl.registerLazySingleton(() => SearchMovies(sl()));

  // ==================== REPOSITORY ====================

  sl.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // ==================== DATA SOURCES ====================

  sl.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(dio: sl()),
  );

  sl.registerLazySingleton<MovieLocalDataSource>(
    () => MovieLocalDataSourceImpl(),
  );

  // ==================== CORE ====================

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => ApiClient());
  sl.registerLazySingleton(() => sl<ApiClient>().dio);

  // ==================== EXTERNAL ====================

  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());

  await Hive.initFlutter();
}
```

**Uso:**
```dart
final store = sl<MovieListStore>(); // Injeta store
```

---

## Fluxos de Dados

### Fluxo 1: Carregar Filmes Populares (Online)

```
┌────────────────┐
│ MovieListPage  │  ← Usuário abre o app
│ (UI)           │
└───────┬────────┘
        │ initState
        │ store.loadPopularMovies()
        ↓
┌────────────────────┐
│ MovieListStore     │  ← isLoading = true
│ (MobX)             │
└────────┬───────────┘
         │ getPopularMovies(page: 1)
         ↓
┌───────────────────────┐
│ GetPopularMovies      │  ← Valida params
│ (Use Case)            │
└────────┬──────────────┘
         │ repository.getPopularMovies()
         ↓
┌────────────────────────────┐
│ MovieRepositoryImpl        │  ← Verifica internet
│ (Offline-first logic)      │
└────────┬───────────────────┘
         │ networkInfo.isConnected ✅
         ↓
┌────────────────────────────┐
│ MovieRemoteDataSource      │  ← Dio HTTP
│ (API)                      │
└────────┬───────────────────┘
         │ GET /movie/popular?page=1
         ↓
┌────────────────────────────┐
│ TMDB API                   │  ← API externa
└────────┬───────────────────┘
         │ Response 200 OK
         │ JSON: { results: [...] }
         ↓
┌────────────────────────────┐
│ MovieRepositoryImpl        │  ← Salva em cache
│ localDataSource.cache()    │
└────────┬───────────────────┘
         │ Right(moviesList)
         ↓
┌────────────────────────────┐
│ MovieListStore             │  ← movies = moviesList
│ movies.addAll(...)         │  ← isLoading = false
└────────┬───────────────────┘
         │ Observer detecta mudança
         ↓
┌────────────────────┐
│ MovieListPage      │  ← GridView reconstrói
│ GridView.builder() │  ← Exibe filmes
└────────────────────┘
```

---

### Fluxo 2: Carregar Filmes (Offline)

```
┌────────────────┐
│ MovieListPage  │  ← Usuário abre sem internet
└───────┬────────┘
        │ store.loadPopularMovies()
        ↓
┌────────────────────────────┐
│ MovieRepositoryImpl        │  ← Verifica internet
└────────┬───────────────────┘
         │ networkInfo.isConnected ❌
         ↓
┌────────────────────────────┐
│ MovieLocalDataSource       │  ← Busca em Hive
│ (Cache)                    │
└────────┬───────────────────┘
         │ getCachedMovies()
         │ Verifica TTL (1h)
         ↓
         │ TTL válido? ✅
         ↓
┌────────────────────────────┐
│ Hive Cache                 │  ← Retorna filmes salvos
└────────┬───────────────────┘
         │ Right(cachedMovies)
         ↓
┌────────────────────┐
│ MovieListPage      │  ← Exibe cache
│ (Sem indicador de  │  ← Funciona offline!
│  "modo offline")   │
└────────────────────┘
```

---

### Fluxo 3: Busca com Debounce

```
┌────────────────┐
│ TextField      │  ← Usuário digita "bat"
│ (Busca)        │
└───────┬────────┘
        │ onChanged('bat')
        ↓
┌────────────────────┐
│ MovieListStore     │  ← Timer.cancel() (cancela anterior)
│ searchWithDebounce │  ← Timer(500ms)
└────────┬───────────┘
         │ (aguarda...)
         │
         │ Usuário digita 'batman'
         │ onChanged('batman')
         ↓
┌────────────────────┐
│ Timer.cancel()     │  ← Cancela timer 'bat'
│ Timer(500ms) {     │  ← Novo timer 'batman'
│   search('batman') │
│ }                  │
└────────┬───────────┘
         │ 500ms de silêncio ✅
         ↓
┌────────────────────────────┐
│ SearchMovies (Use Case)    │  ← query='batman'
└────────┬───────────────────┘
         │ repository.searchMovies()
         ↓
┌────────────────────────────┐
│ TMDB API                   │  ← GET /search/movie?query=batman
└────────┬───────────────────┘
         │ Resultados da busca
         ↓
┌────────────────────┐
│ MovieListPage      │  ← Exibe resultados
└────────────────────┘
```

**Por que debounce?**
Evita fazer 6 requests ('b', 'ba', 'bat', 'batm', 'batma', 'batman'). Faz apenas 1 request após usuário parar de digitar.

---

### Fluxo 4: Filtro Multi-Gênero

```
┌────────────────┐
│ GenreTabs      │  ← Usuário clica chip "Ação" (id: 28)
│ (FilterChips)  │
└───────┬────────┘
        │ store.toggleGenre(28)
        ↓
┌────────────────────┐
│ MovieListStore     │  ← selectedGenreIds.add(28)
│ @action            │  ← selectedGenreIds = [28]
│ toggleGenre(28)    │  ← _updateMoviesBySelectedGenres()
└────────┬───────────┘
         │
         ↓
┌────────────────────────────┐
│ GetMoviesByGenre           │  ← genreIds: [28]
│ (Use Case)                 │
└────────┬───────────────────┘
         │ repository.getMoviesByGenres([28])
         ↓
┌────────────────────────────┐
│ TMDB API                   │  ← GET /discover/movie?with_genres=28
└────────┬───────────────────┘
         │ Filmes de Ação
         ↓
┌────────────────────┐
│ MovieListPage      │  ← Exibe apenas filmes de Ação
└────────────────────┘

        ⬇️ Usuário clica chip "Aventura" (id: 12)

┌────────────────────┐
│ MovieListStore     │  ← selectedGenreIds.add(12)
│ toggleGenre(12)    │  ← selectedGenreIds = [28, 12]
└────────┬───────────┘
         │
         ↓
┌────────────────────────────┐
│ TMDB API                   │  ← GET /discover/movie?with_genres=28,12
│ (Filmes com Ação E Aventura)
└────────┬───────────────────┘
         │ Filmes filtrados
         ↓
┌────────────────────┐
│ MovieListPage      │  ← Exibe filmes de Ação E Aventura
└────────────────────┘
```

---

### Fluxo 5: Paginação Infinita

```
┌────────────────┐
│ GridView       │  ← Usuário scrollando...
│ (Scroll)       │  ← Chegou em 80% do scroll
└───────┬────────┘
        │ _onScroll detecta
        │ currentScroll >= 80% maxScroll
        ↓
┌────────────────────┐
│ MovieListStore     │  ← isLoadingMore = true
│ loadMoreMovies()   │  ← currentPage++ (agora = 2)
└────────┬───────────┘
         │
         ↓
┌────────────────────────────┐
│ GetPopularMovies           │  ← page: 2
└────────┬───────────────────┘
         │ repository.getPopularMovies(page: 2)
         ↓
┌────────────────────────────┐
│ TMDB API                   │  ← GET /movie/popular?page=2
└────────┬───────────────────┘
         │ Novos 20 filmes (página 2)
         ↓
┌────────────────────┐
│ MovieListStore     │  ← movies.addAll(novosList)
│ movies = [         │  ← Adiciona no final da lista
│   ...40 filmes    │  ← isLoadingMore = false
│ ]                 │  ← hasMorePages = (novosList.length == 20)
└────────┬───────────┘
         │ Observer detecta
         ↓
┌────────────────────┐
│ GridView           │  ← Mostra mais 20 filmes
│ (Total: 40 filmes) │  ← Usuário continua scrollando...
└────────────────────┘
```

**Quando para?**
Quando API retorna menos de 20 filmes (última página).

---

## Como Escalar o Projeto

###  Novas Features

#### 1. Sistema de Favoritos

**Implementação:**

**Use Case:**
```dart
// lib/features/movies/domain/usecases/toggle_favorite.dart
class ToggleFavorite implements UseCase<void, ToggleFavoriteParams> {
  final MovieRepository repository;

  @override
  Future<Either<Failure, void>> call(ToggleFavoriteParams params) {
    return repository.toggleFavorite(params.movieId);
  }
}
```

**Local DataSource:**
```dart
// Hive box: 'favorites'
Future<void> toggleFavorite(int movieId) async {
  final box = await Hive.openBox<int>('favorites');
  if (box.containsKey(movieId)) {
    await box.delete(movieId);
  } else {
    await box.put(movieId, movieId);
  }
}
```

**Store:**
```dart
@observable
ObservableList<int> favoriteIds = ObservableList<int>();

@action
Future<void> toggleFavorite(int movieId) async {
  if (favoriteIds.contains(movieId)) {
    favoriteIds.remove(movieId);
  } else {
    favoriteIds.add(movieId);
  }
  await toggleFavoriteUseCase(ToggleFavoriteParams(movieId: movieId));
}
```

**UI:**
```dart
IconButton(
  icon: Icon(
    store.favoriteIds.contains(movie.id)
      ? Icons.favorite
      : Icons.favorite_border,
    color: Colors.red,
  ),
  onPressed: () => store.toggleFavorite(movie.id),
)
```

**Arquivos criados:**
- `features/movies/domain/usecases/toggle_favorite.dart`
- `features/movies/presentation/pages/favorites_page.dart`

**Arquivos alterados:**
- `movie_local_datasource.dart` (adicionar métodos de favoritos)
- `movie_list_store.dart` (adicionar observables/actions)

---

#### 2. Sistema de Reviews/Ratings

**Como implementar:**

Criar nova feature completa:
```
features/reviews/
├── domain/
│   ├── entities/review.dart
│   ├── repositories/review_repository.dart
│   └── usecases/
│       ├── get_movie_reviews.dart
│       └── add_review.dart (se TMDB permitir)
├── data/
│   ├── models/review_model.dart
│   ├── datasources/review_remote_datasource.dart
│   └── repositories/review_repo_impl.dart
└── presentation/
    ├── pages/reviews_page.dart
    └── widgets/review_card.dart
```

**Endpoint TMDB:**
- `GET /movie/{id}/reviews`

**Entity:**
```dart
class Review extends Equatable {
  final String id;
  final String author;
  final String content;
  final DateTime createdAt;
  final double? rating;
}
```

---

#### 3. Watchlist / "Ver Depois"

Similar a favoritos, mas com timestamp:

```dart
class WatchlistItem extends Equatable {
  final int movieId;
  final DateTime addedAt;
  final bool watched;
}

// Hive box: 'watchlist'
```

**Funcionalidades:**
- Adicionar/remover da watchlist
- Marcar como assistido
- Ordenar por data de adição

---

#### 4. Notificações de Lançamentos

**Bibliotecas:**
- `flutter_local_notifications`

**Implementação:**
```dart
// lib/core/services/notification_service.dart
class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin;

  Future<void> scheduleReleaseNotification(Movie movie) async {
    await _plugin.zonedSchedule(
      movie.id,
      'Novo lançamento!',
      '${movie.title} já está disponível',
      // scheduledDate: movie.releaseDate
    );
  }
}
```

**Endpoint TMDB:**
- `GET /movie/upcoming`

---

#### 5. Integração com Streaming Services

**Endpoint TMDB:**
- `GET /movie/{id}/watch/providers`

**Response:**
```json
{
  "results": {
    "BR": {
      "flatrate": [
        { "provider_name": "Netflix", "logo_path": "/..." },
        { "provider_name": "Prime Video", "logo_path": "/..." }
      ]
    }
  }
}
```

**Widget:**
```dart
class StreamingBadge extends StatelessWidget {
  final String providerName;
  final String logoPath;

  // Exibe logo do streaming service
}
```

---

### Melhorias Arquiteturais

#### 1. Testes Unitários

**Estrutura:**
```
test/
├── core/
│   └── network/
│       └── api_client_test.dart
├── features/movies/
│   ├── domain/
│   │   └── usecases/
│   │       └── get_popular_movies_test.dart
│   ├── data/
│   │   ├── models/
│   │   │   └── movie_model_test.dart
│   │   └── repositories/
│   │       └── movie_repo_impl_test.dart
│   └── presentation/
│       └── stores/
│           └── movie_list_store_test.dart
```

**Exemplo de teste:**
```dart
// test/features/movies/domain/usecases/get_popular_movies_test.dart
void main() {
  late GetPopularMovies usecase;
  late MockMovieRepository mockRepository;

  setUp(() {
    mockRepository = MockMovieRepository();
    usecase = GetPopularMovies(mockRepository);
  });

  test('deve buscar filmes populares do repository', () async {
    // Arrange
    final tMovies = [tMovie1, tMovie2];
    when(mockRepository.getPopularMovies(page: 1))
        .thenAnswer((_) async => Right(tMovies));

    // Act
    final result = await usecase(const PopularMoviesParams(page: 1));

    // Assert
    expect(result, Right(tMovies));
    verify(mockRepository.getPopularMovies(page: 1));
    verifyNoMoreInteractions(mockRepository);
  });

  test('deve retornar ServerFailure quando repository falha', () async {
    // Arrange
    when(mockRepository.getPopularMovies(page: 1))
        .thenAnswer((_) async => Left(ServerFailure('Erro')));

    // Act
    final result = await usecase(const PopularMoviesParams(page: 1));

    // Assert
    expect(result, Left(ServerFailure('Erro')));
  });
}
```

---

#### 2. CI/CD com GitHub Actions

**Arquivo: `.github/workflows/ci.yml`**
```yaml
name: CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.10.3'
      - run: flutter pub get
      - run: flutter pub run build_runner build --delete-conflicting-outputs
      - run: flutter test
      - run: flutter analyze

  build:
    runs-on: ubuntu-latest
    needs: test
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter build apk --release
      - uses: actions/upload-artifact@v3
        with:
          name: release-apk
          path: build/app/outputs/flutter-apk/app-release.apk
```

---

#### 3. Internacionalização (i18n)

**Arquivos:**
```
lib/l10n/
├── app_en.arb  # Inglês
├── app_pt.arb  # Português
└── app_es.arb  # Espanhol
```

**app_en.arb:**
```json
{
  "appTitle": "Movies",
  "searchHint": "Search movies...",
  "popularMovies": "Popular Movies",
  "noResults": "No results found"
}
```

**app_pt.arb:**
```json
{
  "appTitle": "Filmes",
  "searchHint": "Buscar filmes...",
  "popularMovies": "Filmes Populares",
  "noResults": "Nenhum resultado encontrado"
}
```

**pubspec.yaml:**
```yaml
flutter:
  generate: true

dependencies:
  flutter_localizations:
    sdk: flutter
```

**l10n.yaml:**
```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

**Gerar:**
```bash
flutter gen-l10n
```

**Uso:**
```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Text(AppLocalizations.of(context)!.searchHint)
```

---

#### 4. Dark Mode

**Store:**
```dart
@observable
ThemeMode themeMode = ThemeMode.light;

@action
void toggleTheme() {
  themeMode = themeMode == ThemeMode.light
    ? ThemeMode.dark
    : ThemeMode.light;

  // Salvar em SharedPreferences
  _saveThemePreference();
}
```

**main.dart:**
```dart
MaterialApp(
  theme: ThemeData.light(),
  darkTheme: ThemeData.dark(),
  themeMode: themeStore.themeMode,
)
```

---

#### 5. Migração para Riverpod

**Por que migrar?**
- Riverpod é mais testável que MobX
- Compile-time safety (erros em tempo de compilação)
- Provider sem contexto
- Melhor performance

**De MobX:**
```dart
@observable
ObservableList<Movie> movies = ObservableList<Movie>();

@action
Future<void> loadMovies() async { ... }
```

**Para Riverpod:**
```dart
final moviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>(
  (ref) => MoviesNotifier(ref.read),
);

class MoviesNotifier extends StateNotifier<List<Movie>> {
  MoviesNotifier(this.read) : super([]);

  final Reader read;

  Future<void> loadPopularMovies() async {
    final result = await read(getPopularMoviesProvider)(PopularMoviesParams());
    result.fold(
      (error) => state = [],
      (movies) => state = movies,
    );
  }
}
```

---

### ⚡ Otimizações de Performance

#### 1. Lazy Loading de Imagens

**Já implementado:** `CachedNetworkImage`

**Melhorias:**
```dart
CachedNetworkImage(
  imageUrl: movie.fullPosterPath,
  maxHeightDiskCache: 600,
  maxWidthDiskCache: 400,
  fadeInDuration: const Duration(milliseconds: 200),
  memCacheHeight: 600,
  memCacheWidth: 400,
)
```

---

#### 2. Code Splitting

**Deferred imports:**
```dart
import 'features/movies/presentation/pages/movie_detail_page.dart'
  deferred as movie_detail;

// Uso:
await movie_detail.loadLibrary();
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => movie_detail.MovieDetailPage()),
);
```

---

#### 3. RepaintBoundary

**MovieCard:**
```dart
RepaintBoundary(
  child: MovieCard(movie: movie),
)
```

**Por que?**
Isola repaint do card. Quando 1 card atualiza, não repinta todos os outros.

---

#### 4. Build Optimization

**Já implementado:**
- `const` constructors em widgets estáticos
- `Observer` apenas onde necessário (não no widget pai)
- Keys em listas (`key: ValueKey(movie.id)`)

---

## Testes

### Estrutura de Testes

```
test/
├── core/
│   ├── network/
│   │   ├── api_client_test.dart
│   │   └── network_info_test.dart
│   └── usecases/
│       └── usecase_test.dart
├── features/
│   └── movies/
│       ├── domain/
│       │   └── usecases/
│       │       ├── get_popular_movies_test.dart
│       │       ├── get_genres_test.dart
│       │       ├── get_movie_details_test.dart
│       │       ├── get_movies_by_genre_test.dart
│       │       └── search_movies_test.dart
│       ├── data/
│       │   ├── models/
│       │   │   ├── movie_model_test.dart
│       │   │   └── genre_model_test.dart
│       │   ├── datasources/
│       │   │   ├── movie_remote_datasource_test.dart
│       │   │   └── movie_local_datasource_test.dart
│       │   └── repositories/
│       │       └── movie_repo_impl_test.dart
│       └── presentation/
│           ├── stores/
│           │   ├── movie_list_store_test.dart
│           │   └── movie_detail_store_test.dart
│           └── pages/
│               ├── movie_list_page_test.dart
│               └── movie_detail_page_test.dart
├── mocks/
│   └── mock_data.dart
└── fixtures/
    └── movie_response.json
```

### Como Executar

```bash
# Testes unitários
flutter test

# Testes com coverage
flutter test --coverage

# Visualizar coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```


---

## Autor Pedro Henrique Sousa Almeida

Desenvolvido com Flutter + Clean Architecture + MobX

---


