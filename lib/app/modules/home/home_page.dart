import 'package:aplicativo_filmes_flutter/app/models/discover_filmes.dart';
import 'package:aplicativo_filmes_flutter/app/modules/movie_item_list/movie_item_list_page.dart';
import 'package:aplicativo_filmes_flutter/app/modules/slider/slider_page.dart';
import 'package:aplicativo_filmes_flutter/app/models/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:rx/converters.dart';
import 'package:rx/core.dart';
import 'home_store.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key? key, this.title = 'Home'}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeStore store;
  late final FilmesStore filmeStore;

  TextStyle textStyle = const TextStyle(
    color: Colors.white,
    fontSize: 16,
    decoration: TextDecoration.none,
  );

  @override
  void initState() {
    store = Modular.get<HomeStore>();
    filmeStore = Modular.get<FilmesStore>();
    super.initState();
  }

  @override
  void dispose() {
    Modular.dispose<HomeStore>();
    Modular.dispose<FilmesStore>();
    super.dispose();
  }

  Future<void> getFilmes() {
    return store.setStore();
  }

  Future<void> getSliderFilmes() {
    return filmeStore.setStore();
  }

  void setLoading() {
    if (store.isLoading) {
      EasyLoading.show(
        status: 'Loading Movies',
      );
    } else {
      EasyLoading.dismiss(animation: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    EasyLoading.show();

    Utils.forkJoinUtil([getFilmes(), getSliderFilmes()])
        .toObservable()
        .subscribe(
          Observer(
            next: (List<void> result) {
              EasyLoading.dismiss();
            },
            error: (error, stackTrace) {
              EasyLoading.showError(error.toString());
            },
          ),
        );

    return Container(
      padding: const EdgeInsets.all(30),
      decoration: const BoxDecoration(color: Color.fromARGB(255, 50, 50, 50)),
      child: DefaultTextStyle(
        style: textStyle,
        child: SafeArea(
          child: Column(
            children: [
              ScopedBuilder<FilmesStore, Object, List<DiscoverFilmes>>(
                store: filmeStore,
                onError: (context, error) {
                  if (EasyLoading.isShow) {
                    return const Text("");
                  }
                  EasyLoading.showError(error.toString());
                  return const Text("Erro");
                },
                onState: (context, state) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 4,
                    child: SliderPage(
                      filmes: state,
                    ),
                  );
                },
              ),
              Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Principais Filmes"),
                  TextButton(
                    onPressed: () => {
                      Navigator.pushNamed(context, '/filmes-list/'),
                    },
                    child: const Text(
                      "VER TODOS",
                      style: TextStyle(fontSize: 8),
                    ),
                  ),
                ],
              ),
              ScopedBuilder<HomeStore, Object, List<DiscoverFilmes>>(
                store: store,
                onError: (context, error) {
                  if (EasyLoading.isShow) {
                    return const Text("");
                  }
                  EasyLoading.showError(error.toString());
                  return const Text("Erro");
                },
                onState: (context, state) {
                  return Container(
                    height: MediaQuery.of(context).size.height / 2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: state.length,
                      itemBuilder: (context, index) => MovieItemListPage(
                        filme: state[index],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
