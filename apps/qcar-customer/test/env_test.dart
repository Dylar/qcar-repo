import 'package:carmanual/core/environment_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('check default env config', () async {
    expect(EnvironmentConfig.APP_NAME, "Car manual");
    expect(EnvironmentConfig.ENV, Env.DEV.name);
    expect(EnvironmentConfig.FLAVOR, "");
  });
}
