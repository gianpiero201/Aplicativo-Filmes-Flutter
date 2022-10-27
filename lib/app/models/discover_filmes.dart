import 'package:flutter/foundation.dart';

class DiscoverFilmes {
  final bool? adult;
  final String? backdropPath;
  final List<int>? genreIds;
  late final int? id;
  final String? originalLanguage;
  final String? originalTitle;
  final String? overview;
  final double? popularity;
  final String? posterPath;
  final String? releaseDate;
  final String? title;
  final bool? video;
  final double? voteAverage;
  final int? voteCount;
  Uint8List? posterPathBytes;
  Uint8List? backdropPathBytes;

  DiscoverFilmes({
    this.adult,
    this.backdropPath,
    this.genreIds,
    this.id,
    this.originalLanguage,
    this.originalTitle,
    this.overview,
    this.popularity,
    this.posterPath,
    this.releaseDate,
    this.title,
    this.video,
    this.voteAverage,
    this.voteCount,
  });

  List<DiscoverFilmes> fromJson(Map<String, dynamic> json, String resultField) {
    List<dynamic> results = json[resultField];
    List<DiscoverFilmes> filmes = [];

    results.forEach((dynamic filme) {
      filmes.add(DiscoverFilmes(
        adult: filme['adult'],
        backdropPath: filme['backdrop_path'],
        genreIds: filme['genre_ids'].cast<int>(),
        id: filme['id'],
        originalLanguage: filme['original_language'],
        originalTitle: filme['original_title'],
        overview: filme['overview'],
        popularity: filme['popularity'],
        posterPath: filme['poster_path'],
        releaseDate: filme['release_date'],
        title: filme['title'],
        video: filme['video'],
        voteAverage: filme['vote_average'].toDouble(),
        voteCount: filme['vote_count'],
      ));
    });

    return filmes;
  }
}
