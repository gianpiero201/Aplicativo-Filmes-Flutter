import 'dart:convert';

import 'package:aplicativo_filmes_flutter/app/models/discover_filmes.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class HomeStore extends NotifierStore<Exception, List<DiscoverFilmes>> {
  HomeStore() : super(<DiscoverFilmes>[]);
  static const String _apikey = "86dd5e9b9b24eef059e8e20e0c23ac6d";

  Future<void> setStoreFromPage(int page) async {
    setLoading(true);

    Response response = await http.get(
      Uri.http(
        "api.themoviedb.org",
        "/3/discover/movie",
        {"api_key": _apikey, "page": "1"},
      ),
      headers: {"Accept": "application/json"},
    );

    DiscoverFilmes discoverFilmes = DiscoverFilmes();

    List<DiscoverFilmes> filmes =
        discoverFilmes.fromJson(json.decode(response.body));

    if (filmes.isNotEmpty) {
      update(filmes);
    } else {
      setError(Exception("Lista de filmes vazia"));
    }

    setLoading(false);
  }
}
