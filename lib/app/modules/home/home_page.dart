import 'package:aplicativo_filmes_flutter/app/models/discover_filmes.dart';
import 'package:aplicativo_filmes_flutter/app/modules/slider/slider_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'home_store.dart';
import 'dart:async';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key? key, this.title = 'Home'}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeStore store;
  late List<DiscoverFilmes> filmes = [];
  TextStyle textStyle = const TextStyle(
    color: Colors.white,
    fontSize: 16,
    decoration: TextDecoration.none,
  );

  @override
  void initState() {
    store = Modular.get<HomeStore>();
    store.selectLoading.addListener(() => setLoading());
    store.selectState.addListener(() => filmes = store.state);
    super.initState();
  }

  @override
  void dispose() {
    Modular.dispose<HomeStore>();
    super.dispose();
  }

  Future<void> getFilmes() async {
    await store.setStoreFromPage(1);
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
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: const BoxDecoration(color: Color.fromARGB(255, 50, 50, 50)),
      child: DefaultTextStyle(
        style: textStyle,
        child: SafeArea(
          child: Column(
            children: [
              Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Principais Filmes"),
                  TextButton(
                    onPressed: () => {
                      Navigator.pushNamed(context, '/filmes-list'),
                    },
                    child: const Text(
                      "VER TODOS",
                      style: TextStyle(fontSize: 8),
                    ),
                  ),
                ],
              ),
              Flexible(
                child: FutureBuilder(
                    future: getFilmes(),
                    builder: (context, snapshot) {
                      if (filmes.isEmpty) {
                        EasyLoading.show(
                          status: 'Loading Movies',
                        );
                        return const Text("");
                      }
                      return SliderPage(
                        filmes: filmes,
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
