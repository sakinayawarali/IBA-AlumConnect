import 'package:devproj/providers/profiles_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


void main() {
  group('ConnectionStatusProvider Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('connectionStatusProvider returns true if connection exists',
        () async {
      // Simulate connection exists by directly returning true
      final result =
          await container.read(connectionStatusProvider('user2').future);
      expect(result, true);
    });

    test('connectionStatusProvider returns false if connection does not exist',
        () async {
      // Simulate connection does not exist by directly returning false
      final result =
          await container.read(connectionStatusProvider('user2').future);
      expect(result, false);
    });
  });
}
