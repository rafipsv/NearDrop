import 'package:flutter_test/flutter_test.dart';

import 'package:neardrop/core/constants/app_constants.dart';

void main() {
  test('uses the NearDrop product name', () {
    expect(AppConstants.appName, 'NearDrop');
  });
}
