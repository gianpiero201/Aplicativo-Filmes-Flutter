import 'dart:typed_data';

import 'package:aplicativo_filmes_flutter/app/models/discover_filmes.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SliderPage extends StatefulWidget {
  final String title;
  final List<DiscoverFilmes> filmes;
  bool? isLoading = false;
  SliderPage(
      {Key? key,
      this.title = 'SliderPage',
      required this.filmes,
      this.isLoading})
      : super(key: key);

  @override
  SliderPageState createState() {
    return SliderPageState();
  }
}

class SliderPageState extends State<SliderPage> {
  CarouselController btnCarouselController = CarouselController();

  void isLoading() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          const Divider(
            color: Colors.black,
          ),
          Flexible(
            child: Flex(
              direction: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 5,
                    child: CarouselSlider.builder(
                      carouselController: btnCarouselController,
                      itemCount: widget.filmes.length,
                      itemBuilder: (context, index, realIndex) {
                        String url =
                            "https://image.tmdb.org/t/p/original${widget.filmes[index].backdropPath}";
                        return buildImage(url, widget.filmes[index]);
                      },
                      options: CarouselOptions(
                        aspectRatio: 2.9,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.black,
          )
        ],
      ),
    );
  }

  Future<void> getImage(String url, DiscoverFilmes filme) async {
    filme.posterPathBytes ??= (await http.get(Uri.parse(url))).bodyBytes;
  }

  Widget buildImage(String url, DiscoverFilmes filme) => FutureBuilder(
        future: getImage(url, filme),
        builder: (context, snapshot) {
          if (filme.posterPathBytes == null) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              color: const Color.fromARGB(29, 250, 250, 250),
            );
          }
          return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                color: const Color.fromARGB(29, 250, 250, 250),
                child: Image.memory(
                  filme.posterPathBytes as Uint8List,
                  cacheWidth: 662,
                  cacheHeight: 372,
                  fit: BoxFit.cover,
                ),
              ));
        },
      );
}
