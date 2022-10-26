import 'dart:async';

import 'package:aplicativo_filmes_flutter/app/models/discover_filmes.dart';
import 'package:aplicativo_filmes_flutter/app/modules/movie_item_list/movie_item_list_page.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:aplicativo_filmes_flutter/app/modules/list/list_store.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ListPage extends StatefulWidget {
  final String title;
  const ListPage({Key? key, this.title = 'ListPage'}) : super(key: key);
  @override
  ListPageState createState() => ListPageState();
}

class ListPageState extends State<ListPage> {
  final int _totPages = 35337;
  late final ListStore store;
  List<DiscoverFilmes> filmes = [];
  bool _searchVisibility = false;
  TextEditingController searchController = TextEditingController();
  final PagingController _pagingController = PagingController(firstPageKey: 1);
  FocusNode searchFocus = FocusNode();

  @override
  void initState() {
    store = Modular.get<ListStore>();
    store.selectLoading.addListener(() => setLoading());
    store.selectState.addListener(() => filmes = store.state);
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
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

  Future<void> _fetchPage(int page) async {
    try {
      await store.setStoreFromPage(page);

      if (page == _totPages - 1) {
        _pagingController.appendLastPage(filmes);
        return;
      }

      final nextPageKey = page + 1;
      _pagingController.appendPage(filmes, nextPageKey);
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: const BoxDecoration(color: Color.fromARGB(255, 50, 50, 50)),
      child: SafeArea(
        child: Column(
          children: [
            Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/');
                    },
                    icon: const Icon(
                      Icons.arrow_circle_left_outlined,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                ),
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    Visibility(
                      visible: _searchVisibility,
                      child: SizedBox(
                        height: 35,
                        width: 150,
                        child: TextField(
                          controller: searchController,
                          focusNode: searchFocus,
                          decoration: const InputDecoration(
                            labelStyle: TextStyle(color: Colors.white),
                            hintText: 'Pesquisar',
                            hintStyle: TextStyle(
                              color: Color.fromARGB(150, 190, 190, 190),
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _searchVisibility = !_searchVisibility;
                          Future.delayed(const Duration(milliseconds: 100), () {
                            if (_searchVisibility) {
                              searchFocus.requestFocus();
                            }
                          });
                        });
                      },
                      icon: const Icon(Icons.search),
                    ),
                  ],
                )
              ],
            ),
            Flexible(
              child: PagedListView(
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate(
                  itemBuilder: (context, item, index) {
                    return MovieItemListPage(
                      filme: item as DiscoverFilmes,
                      onClick: (filme) {
                        Navigator.pushNamed(
                          context,
                          '/filme-details/',
                          arguments: filme,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
