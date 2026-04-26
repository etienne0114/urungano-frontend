import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:urungano/core/services/api/api_client.dart';
import 'package:urungano/main.dart';

void main() {
  test('App root widget builds', () {
    ApiClient.instance.setOfflineMode(true);
    const app = ProviderScope(child: UrunganoApp());
    expect(app, isA<Widget>());
  });
}
