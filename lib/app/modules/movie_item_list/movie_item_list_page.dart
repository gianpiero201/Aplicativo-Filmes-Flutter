import 'package:aplicativo_filmes_flutter/app/models/discover_filmes.dart';
import 'package:flutter/material.dart';

class MovieItemListPage extends StatefulWidget {
  final String title;
  final DiscoverFilmes filme;
  const MovieItemListPage(
      {Key? key, this.title = 'MovieItemListPage', required this.filme})
      : super(key: key);
  @override
  MovieItemListPageState createState() => MovieItemListPageState();
}

class MovieItemListPageState extends State<MovieItemListPage> {
  @override
  Widget build(BuildContext context) {
    String urlImage =
        "https://image.tmdb.org/t/p/original${widget.filme.posterPath}";

    return SizedBox(
      height: 50,
      width: double.maxFinite,
      child: Row(
        children: <Widget>[
          Flexible(child: buildImage(urlImage)),
          Flexible(child: Text(widget.filme.title ?? "")),
        ],
      ),
    );
  }

  Widget buildImage(String url) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        color: Colors.white,
        child: Image.network(
          url,
        ),
      );
}
