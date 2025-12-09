import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/movie.dart';
import '../stores/movie_detail_store.dart';

class MovieDetailPage extends StatelessWidget {
  const MovieDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.read<MovieDetailStore>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Voltar',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Observer(
        builder: (_) {
          // Loading inicial
          if (store.isLoading && !store.hasMovie) {
            return const Center(child: CircularProgressIndicator());
          }

          // Erro
          if (store.hasError && !store.hasMovie) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    store.errorMessage ?? 'Erro desconhecido',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Voltar'),
                  ),
                ],
              ),
            );
          }

          // Sem filme
          if (!store.hasMovie) {
            return const Center(
              child: Text('Nenhum detalhe encontrado'),
            );
          }

          final movie = store.movie!;
          return _MovieDetailContent(movie: movie);
        },
      ),
    );
  }
}

class _MovieDetailContent extends StatelessWidget {
  final Movie movie;

  const _MovieDetailContent({required this.movie});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Poster com Hero Animation
          _buildPoster(),
          const SizedBox(height: 16),

          // Rating
          _buildRating(),
          const SizedBox(height: 16),

          // Título
          _buildTitle(),
          const SizedBox(height: 8),

          // Ano e Duração
          _buildYearAndDuration(),
          const SizedBox(height: 16),

          // Gêneros
          _buildGenres(context),
          const SizedBox(height: 24),

          // Descrição
          _buildSection('Descrição', movie.overview),
          const SizedBox(height: 16),

          // Orçamento
          if (movie.budget != null && movie.budget! > 0) ...[
            _buildSection('ORÇAMENTO', _formatBudget(movie.budget!)),
            const SizedBox(height: 16),
          ],

          // Produtoras
          if (movie.productionCompanies.isNotEmpty) ...[
            _buildSection(
              'PRODUTORAS',
              movie.productionCompanies.map((e) => e.name).join(', '),
            ),
            const SizedBox(height: 16),
          ],

          // Diretor
          _buildDirector(),
          if (_getDirectorNames().isNotEmpty) const SizedBox(height: 16),

          // Elenco
          _buildCast(),
        ],
      ),
    );
  }

  Widget _buildPoster() {
    return Hero(
      tag: 'movie-${movie.id}',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: movie.fullPosterPath != null
            ? CachedNetworkImage(
                imageUrl: movie.fullPosterPath!,
                width: 200,
                height: 300,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 200,
                  height: 300,
                  color: Colors.grey[300],
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 200,
                  height: 300,
                  color: Colors.grey[300],
                  child: const Icon(Icons.movie, size: 64),
                ),
              )
            : Container(
                width: 200,
                height: 300,
                color: Colors.grey[300],
                child: const Icon(Icons.movie, size: 64),
              ),
      ),
    );
  }

  Widget _buildRating() {
    final rating = movie.voteAverage?.toStringAsFixed(1) ?? '0.0';
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          rating,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          ' /10',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        Text(
          movie.title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        if (movie.originalTitle != null &&
            movie.originalTitle != movie.title) ...[
          const SizedBox(height: 4),
          Text(
            'Título original: ${movie.originalTitle}',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _buildYearAndDuration() {
    final year = _getYear();
    final duration = _formatDuration();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (year.isNotEmpty) ...[
          Text(
            'Ano: $year',
            style: const TextStyle(fontSize: 16),
          ),
        ],
        if (year.isNotEmpty && duration.isNotEmpty) ...[
          const SizedBox(width: 8),
          const Text(' | ', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
        ],
        if (duration.isNotEmpty) ...[
          Text(
            'Duração: $duration',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ],
    );
  }

  Widget _buildGenres(BuildContext context) {
    // Precisa do contexto para acessar o MovieListStore que tem a lista de genres
    // Por enquanto, vamos mostrar apenas os IDs ou criar uma lista hardcoded
    // Em uma implementação ideal, você passaria a lista de gêneros aqui

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: movie.genreIds.map((genreId) {
        // Mapeamento básico de gêneros (você pode melhorar isso)
        final genreName = _getGenreName(genreId);
        return Chip(
          label: Text(
            genreName,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.blue,
        );
      }).toList(),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content.isEmpty ? 'Não disponível' : content,
          style: const TextStyle(fontSize: 16),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }

  Widget _buildDirector() {
    final directors = _getDirectorNames();

    if (directors.isEmpty) {
      return const SizedBox.shrink();
    }

    return _buildSection('Diretor', directors);
  }

  Widget _buildCast() {
    if (movie.cast.isEmpty) {
      return const SizedBox.shrink();
    }

    // Pega os primeiros 5 atores
    final topCast = movie.cast.take(5).toList();
    final castNames = topCast.map((actor) => actor.name).join(', ');

    return _buildSection('Elenco', castNames);
  }

  // ==================== HELPERS ====================

  String _getYear() {
    if (movie.releaseDate == null || movie.releaseDate!.isEmpty) {
      return '';
    }
    try {
      final date = DateTime.parse(movie.releaseDate!);
      return date.year.toString();
    } catch (e) {
      return '';
    }
  }

  String _formatDuration() {
    if (movie.runtime == null || movie.runtime! <= 0) {
      return '';
    }

    final hours = movie.runtime! ~/ 60;
    final minutes = movie.runtime! % 60;

    if (hours > 0) {
      return '${hours}h ${minutes.toString().padLeft(2, '0')}min';
    } else {
      return '${minutes}min';
    }
  }

  String _formatBudget(double budget) {
    final formatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: '\$',
      decimalDigits: 0,
    );
    return formatter.format(budget);
  }

  String _getDirectorNames() {
    final directors = movie.crew.where((c) => c.job == 'Director').toList();
    return directors.map((d) => d.name).join(', ');
  }

  String _getGenreName(int genreId) {
    // Mapeamento de gêneros do TMDB
    const genreMap = {
      28: 'AÇÃO',
      12: 'AVENTURA',
      16: 'ANIMAÇÃO',
      35: 'COMÉDIA',
      80: 'CRIME',
      99: 'DOCUMENTÁRIO',
      18: 'DRAMA',
      10751: 'FAMÍLIA',
      14: 'FANTASIA',
      36: 'HISTÓRIA',
      27: 'TERROR',
      10402: 'MÚSICA',
      9648: 'MISTÉRIO',
      10749: 'ROMANCE',
      878: 'SCI-FI',
      10770: 'TV',
      53: 'THRILLER',
      10752: 'GUERRA',
      37: 'WESTERN',
    };

    return genreMap[genreId] ?? 'OUTRO';
  }
}
