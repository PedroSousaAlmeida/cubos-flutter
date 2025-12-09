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
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
              label: const Text(
                'Voltar',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
            ),
          ),
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
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
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
            return const Center(child: Text('Nenhum detalhe encontrado'));
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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Poster centralizado
          Center(child: _buildPoster()),
          const SizedBox(height: 16),

          // Rating centralizado
          Center(child: _buildRating()),
          const SizedBox(height: 16),

          // Título centralizado
          Center(child: _buildTitle()),
          const SizedBox(height: 8),

          // Título original centralizado
          if (movie.originalTitle != null &&
              movie.originalTitle!.isNotEmpty) ...[
            Center(child: _buildOriginalTitle()),
            const SizedBox(height: 16),
          ],

          // Ano e Duração com background cinza
          _buildYearAndDurationChips(),
          const SizedBox(height: 16),

          // Gêneros (fundo branco, borda preta)
          _buildGenreChips(),
          const SizedBox(height: 24),

          // Descrição (à esquerda)
          _buildSection('Descrição', movie.overview),
          const SizedBox(height: 16),

          // Orçamento (background cinza)
          if (movie.budget != null && movie.budget! > 0) ...[
            _buildGraySection('ORÇAMENTO', _formatBudget(movie.budget!)),
            const SizedBox(height: 16),
          ],

          // Produtoras (background cinza)
          if (movie.productionCompanies.isNotEmpty) ...[
            _buildGraySection(
              'PRODUTORAS',
              movie.productionCompanies.map((e) => e.name).join(', '),
            ),
            const SizedBox(height: 16),
          ],

          // Diretor (à esquerda)
          if (_getDirectorNames().isNotEmpty) ...[
            _buildSection('Diretor', _getDirectorNames()),
            const SizedBox(height: 16),
          ],

          // Elenco (à esquerda)
          if (movie.cast.isNotEmpty) ...[
            _buildSection('Elenco', _getCastNames()),
          ],
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
                  child: const Center(child: CircularProgressIndicator()),
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
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        const Text(' /10', style: TextStyle(fontSize: 18, color: Colors.grey)),
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      movie.title,
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildOriginalTitle() {
    return Text(
      'Título original: ${movie.originalTitle}',
      style: const TextStyle(
        fontSize: 14,
        color: Colors.grey,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  Widget _buildYearAndDurationChips() {
    final year = _getYear();
    final duration = _formatDuration();

    return Center(
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          if (year.isNotEmpty)
            Chip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Ano: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    year,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.grey[100],
            ),
          if (duration.isNotEmpty)
            Chip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Duração: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    duration,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.grey[100],
            ),
        ],
      ),
    );
  }

  Widget _buildGenreChips() {
    return Center(
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: movie.genreIds.map((genreId) {
          final genreName = _getGenreName(genreId);
          return Chip(
            label: Text(
              genreName,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.white,
            side: const BorderSide(color: Colors.grey, width: 1),
          );
        }).toList(),
      ),
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

  Widget _buildGraySection(String title, String content) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 16, color: Colors.black),
          children: [
            TextSpan(
              text: '$title: ',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            TextSpan(text: content.isEmpty ? 'Não disponível' : content),
          ],
        ),
      ),
    );
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

  String _getCastNames() {
    final topCast = movie.cast.take(5).toList();
    return topCast.map((actor) => actor.name).join(', ');
  }

  String _getGenreName(int genreId) {
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
