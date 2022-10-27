import 'package:aplicativo_filmes_flutter/app/models/detail_filme.dart';
import 'package:aplicativo_filmes_flutter/app/models/discover_filmes.dart';
import 'package:aplicativo_filmes_flutter/app/models/utils.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:aplicativo_filmes_flutter/app/modules/details/details_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:rx/converters.dart';
import 'package:rx/core.dart';

class DetailsPage extends StatefulWidget {
  final String title;
  const DetailsPage({Key? key, this.title = 'DetailsPage'}) : super(key: key);
  @override
  DetailsPageState createState() => DetailsPageState();
}

class DetailsPageState extends State<DetailsPage> {
  late DetailsStore store = Modular.get();
  late DiscoverFilmes filme = DiscoverFilmes();

  TextStyle textStyle = const TextStyle(
    color: Colors.white,
    fontSize: 14,
    decoration: TextDecoration.none,
  );

  @override
  void initState() {
    store = Modular.get<DetailsStore>();
    filme = DiscoverFilmes();
    super.initState();
  }

  Future<void> getFilme() {
    return store.setStore(filme.id);
  }

  @override
  Widget build(BuildContext context) {
    EasyLoading.show();
    if (ModalRoute.of(context)?.settings.arguments != null) {
      filme = ModalRoute.of(context)?.settings.arguments as DiscoverFilmes;
      filme.posterPathBytes = null;
    }

    Utils.forkJoinUtil([getFilme()]).toObservable().subscribe(
          Observer(
            next: (List<void> result) {
              EasyLoading.dismiss();
            },
            error: (error, stackTrace) {
              EasyLoading.showError(error.toString());
            },
          ),
        );

    String urlImage = "https://image.tmdb.org/t/p/original${filme.posterPath}";

    return Container(
      padding: const EdgeInsets.all(30),
      decoration: const BoxDecoration(color: Color.fromARGB(255, 50, 50, 50)),
      child: DefaultTextStyle(
        style: textStyle,
        child: SafeArea(
          child: Column(children: [
            Row(
              children: [
                Flexible(
                  child: IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/filmes-list/');
                    },
                    icon: const Icon(
                      Icons.arrow_circle_left_outlined,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
            ScopedBuilder<DetailsStore, Object, DetailFilme>(
              store: store,
              onError: (context, error) {
                if (EasyLoading.isShow) {
                  return const Text("");
                }
                EasyLoading.showError(error.toString());
                return const Text("Erro");
              },
              onState: (context, state) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height / 1.3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Utils.buildImage(urlImage, filme, 493, 790),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                        height: MediaQuery.of(context).size.height / 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Flexible(
                              child: Text(
                                "Overview: ${state.overview}",
                                overflow: TextOverflow.visible,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                  "Genres: ${state.genres?.map((e) => e.name).join(", ")}"),
                            ),
                            Flexible(
                              child: Text(
                                "IMDB: ${(state.voteAverage! * 100).round() / 100}",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          ]),
        ),
      ),
    );
  }
}
