import 'package:flutter_test/flutter_test.dart';
import 'package:qcar_customer/core/environment_config.dart';

void main() {
  test('check default env config', () async {
    expect(EnvironmentConfig.APP_NAME, "QCar");
    expect(EnvironmentConfig.ENV, Env.DEV.name);
    expect(EnvironmentConfig.FLAVOR, "");
  });
}
