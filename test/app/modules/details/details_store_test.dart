import 'package:flutter_test/flutter_test.dart';
import 'package:aplicativo_filmes_flutter/app/modules/details/details_store.dart';
 
void main() {
  late DetailsStore store;

  setUpAll(() {
    store = DetailsStore();
  });

  test('increment count', () async {
    expect(store.state, equals(0));
    store.update(store.state + 1);
    expect(store.state, equals(1));
  });
}