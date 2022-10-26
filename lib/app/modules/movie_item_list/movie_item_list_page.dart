import 'package:aplicativo_filmes_flutter/app/models/discover_filmes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MovieItemListPage extends StatefulWidget {
  final String title;
  final DiscoverFilmes filme;
  final Function(DiscoverFilmes filme)? onClick;
  const MovieItemListPage({
    Key? key,
    this.title = 'MovieItemListPage',
    required this.filme,
    this.onClick,
  }) : super(key: key);
  @override
  MovieItemListPageState createState() => MovieItemListPageState();
}

class MovieItemListPageState extends State<MovieItemListPage> {
  @override
  Widget build(BuildContext context) {
    String urlImage =
        "https://image.tmdb.org/t/p/original${widget.filme.posterPath}";

    return InkWell(
      onTap: () {
        if (widget.onClick != null) {
          widget.onClick!(widget.filme);
        }
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.black,
              width: 2,
            )),
        margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
        height: 60,
        width: double.maxFinite,
        child: Row(
          children: <Widget>[
            Flexible(
              child: buildImage(urlImage),
            ),
            Flexible(child: Text(widget.filme.title ?? "")),
          ],
        ),
      ),
    );
  }

  Future<void> getImage(String url) async {
    widget.filme.posterPathBytes ??= (await http.get(Uri.parse(url))).bodyBytes;
  }

  Widget buildImage(String url) => FutureBuilder(
        future: getImage(url),
        builder: (context, snapshot) {
          if (widget.filme.posterPathBytes == null) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              width: 35,
              color: const Color.fromARGB(29, 250, 250, 250),
            );
          }
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            color: const Color.fromARGB(29, 250, 250, 250),
            child: Image.memory(
              widget.filme.posterPathBytes as Uint8List,
              cacheWidth: 91,
              cacheHeight: 137,
              fit: BoxFit.cover,
            ),
          );
        },
      );
}
