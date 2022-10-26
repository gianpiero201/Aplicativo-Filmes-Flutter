import 'package:aplicativo_filmes_flutter/app/modules/details/details_page.dart';
import 'package:aplicativo_filmes_flutter/app/modules/details/details_store.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DetailsModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => DetailsStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => DetailsPage()),
  ];
}
