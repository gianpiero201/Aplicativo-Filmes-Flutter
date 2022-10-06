import 'package:aplicativo_filmes_flutter/app/modules/list/list_page.dart';
import 'package:aplicativo_filmes_flutter/app/modules/list/list_store.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ListModule extends Module {
  @override
  final List<Bind> binds = [Bind.lazySingleton((i) => ListStore()),];

  @override
  final List<ModularRoute> routes = [ChildRoute('/', child: (_, args) => ListPage()),];

}