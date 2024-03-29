import 'package:flutter_test/flutter_test.dart';
import 'package:qcar_customer/core/models/schema_validator.dart';

import 'builder/entity_builder.dart';

void main() {
  test('validate car info schema', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final info = await buildCarInfo();
    final isValid = await validateCarInfo(info.toMap());
    expect(isValid, true);
  });

  test('validate category info schema', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final info = await buildCategoryInfo();
    final isValid = await validateCategoryInfo(info.toMap());
    expect(isValid, true);
  });

  test('validate video info schema', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final info = await buildVideoInfo();
    final isValid = await validateVideoInfo(info.toMap());
    expect(isValid, true);
  });

  test('validate sell info schema', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final info = await buildSellInfo();
    final isValid = await validateSellInfo(info.toMap());
    expect(isValid, true);
  });

  test('validate sell key schema', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final key = await buildSellKey();
    final isValid = await validateSellKey(key.toMap());
    expect(isValid, true);
  });
}
