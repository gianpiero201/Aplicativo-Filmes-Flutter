import 'package:aplicativo_filmes_flutter/app/models/discover_filmes.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';

const String _apikey = "86dd5e9b9b24eef059e8e20e0c23ac6d";

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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () => {btnCarouselController.previousPage()},
                    icon: const Icon(Icons.arrow_back_ios)),
                Expanded(
                  child: SizedBox(
                    height: double.maxFinite,
                    child: CarouselSlider.builder(
                      carouselController: btnCarouselController,
                      itemCount: widget.filmes.length,
                      itemBuilder: (context, index, realIndex) {
                        String url =
                            "https://image.tmdb.org/t/p/original${widget.filmes[index].posterPath}";
                        return buildImage(url);
                      },
                      options: CarouselOptions(),
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () => {btnCarouselController.nextPage()},
                    icon: const Icon(Icons.arrow_forward_ios)),
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

  Widget buildImage(String url) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        color: Colors.white,
        child: Image.network(
          url,
          width: double.maxFinite,
        ),
      );
}
