import 'dart:typed_data';

import 'package:aplicativo_filmes_flutter/app/models/discover_filmes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/async.dart' as asyncF;
import 'package:http/http.dart' as http;

class Utils {
  static Future<List<dynamic>> forkJoinUtil(
      List<Future<dynamic>> requesitions) async {
    List<dynamic> results = [];

    for (var item in requesitions) {
      results.add(await item);
    }

    return results;
  }

  static Future<void> getImage(String url, DiscoverFilmes filme) async {
    filme.posterPathBytes ??= (await http.get(Uri.parse(url))).bodyBytes;
  }

  static Widget buildImage(String url, DiscoverFilmes filme, int? cacheWidth,
          int? cacheHeight) =>
      asyncF.FutureBuilder(
        future: getImage(url, filme),
        builder: (context, snapshot) {
          if (filme.posterPathBytes == null) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              width: cacheWidth!.toDouble(),
              color: const Color.fromARGB(29, 250, 250, 250),
            );
          }
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            color: const Color.fromARGB(29, 250, 250, 250),
            child: Image.memory(
              filme.posterPathBytes as Uint8List,
              cacheWidth: cacheWidth ?? 91,
              cacheHeight: cacheHeight ?? 137,
              fit: BoxFit.cover,
            ),
          );
        },
      );
}

class FutureBuilder {}
