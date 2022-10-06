import 'package:flutter_test/flutter_test.dart';
import 'package:aplicativo_filmes_flutter/app/modules/list/list_store.dart';
 
void main() {
  late ListStore store;

  setUpAll(() {
    store = ListStore();
  });

  test('increment count', () async {
    expect(store.state, equals(0));
    store.update(store.state + 1);
    expect(store.state, equals(1));
  });
}