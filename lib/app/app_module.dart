import 'package:aplicativo_filmes_flutter/app/modules/details/details_module.dart';
import 'package:aplicativo_filmes_flutter/app/modules/home/home_module.dart';
import 'package:aplicativo_filmes_flutter/app/modules/list/list_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
  @override
  final List<Module> imports = [];

  @override
  final List<Bind> binds = [];

  @override
  final List<ModularRoute> routes = [
    ModuleRoute('/', module: HomeModule()),
    ModuleRoute('/filmes-list', module: ListModule()),
    ModuleRoute('/filme-details', module: DetailsModule()),
  ];
}
