import 'dart:convert';

import 'package:aplicativo_filmes_flutter/app/models/detail_filme.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

const String _apikey = "86dd5e9b9b24eef059e8e20e0c23ac6d";

class DetailsStore extends NotifierStore<Exception, DetailFilme> {
  DetailsStore() : super(DetailFilme());

  Future<void> setStore(int? id) async {
    setLoading(true);

    Response response = await http.get(
      Uri.http(
        "api.themoviedb.org",
        "/3/movie/${id}",
        {"api_key": _apikey},
      ),
      headers: {"Accept": "application/json"},
    );

    DetailFilme detailFilme = DetailFilme.fromJson(json.decode(response.body));

    update(detailFilme);

    setLoading(false);
  }
}
