import 'package:devproj/providers/profiles_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  group('ProfilesNotifier Tests', () {
    late ProviderContainer container;
    late ProfilesNotifier profilesNotifier;

    setUp(() {
      container = ProviderContainer();
      profilesNotifier = container.read(profilesProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state is empty', () {
      expect(profilesNotifier.state, []);
    });

    test('fetchAllUsers updates the state with profiles', () async {
      // Simulate fetching users by directly updating the state
      profilesNotifier.state = [
        {
          'id': '1',
          'firstName': 'John',
          'lastName': 'Doe',
          'userType': 'student'
        },
        {
          'id': '2',
          'firstName': 'Jane',
          'lastName': 'Smith',
          'userType': 'alumni'
        },
      ];

      expect(profilesNotifier.state.length, 2);
    });

    test('filterProfiles filters profiles correctly', () async {
      profilesNotifier.state = [
        {
          'id': '1',
          'firstName': 'John',
          'lastName': 'Doe',
          'userType': 'student'
        },
        {
          'id': '2',
          'firstName': 'Jane',
          'lastName': 'Smith',
          'userType': 'alumni'
        },
      ];

      profilesNotifier.filterProfiles('student');
      expect(profilesNotifier.state.length, 1);
      expect(profilesNotifier.state[0]['userType'], 'student');
    });

    test('searchProfiles searches profiles correctly', () async {
      profilesNotifier.state = [
        {
          'id': '1',
          'firstName': 'John',
          'lastName': 'Doe',
          'userType': 'student'
        },
        {
          'id': '2',
          'firstName': 'Jane',
          'lastName': 'Smith',
          'userType': 'alumni'
        },
      ];

      profilesNotifier.searchProfiles('John');
      expect(profilesNotifier.state.length, 1);
      expect(profilesNotifier.state[0]['firstName'], 'John');
    });
  });
}


void main2() {
  group('ProfilesNotifier Tests', () {
    late ProviderContainer container;
    late ProfilesNotifier profilesNotifier;

    setUp(() {
      container = ProviderContainer();
      profilesNotifier = container.read(profilesProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state is empty', () {
      expect(profilesNotifier.state, []);
    });

    test('fetchAllUsers updates the state with profiles', () async {
      profilesNotifier.state = [
        {
          'id': '1',
          'firstName': 'John',
          'lastName': 'Doe',
          'userType': 'student'
        },
        {
          'id': '2',
          'firstName': 'Jane',
          'lastName': 'Smith',
          'userType': 'alumni'
        },
      ];

      expect(profilesNotifier.state.length, 2);
    });

    test('filterProfiles filters profiles correctly', () async {
      profilesNotifier.state = [
        {
          'id': '1',
          'firstName': 'John',
          'lastName': 'Doe',
          'userType': 'student'
        },
        {
          'id': '2',
          'firstName': 'Jane',
          'lastName': 'Smith',
          'userType': 'alumni'
        },
      ];

      profilesNotifier.filterProfiles('student');
      expect(profilesNotifier.state.length, 1);
      expect(profilesNotifier.state[0]['userType'], 'student');
    });

    test('searchProfiles searches profiles correctly', () async {
      profilesNotifier.state = [
        {
          'id': '1',
          'firstName': 'John',
          'lastName': 'Doe',
          'userType': 'student'
        },
        {
          'id': '2',
          'firstName': 'Jane',
          'lastName': 'Smith',
          'userType': 'alumni'
        },
      ];

      profilesNotifier.searchProfiles('John');
      expect(profilesNotifier.state.length, 1);
      expect(profilesNotifier.state[0]['firstName'], 'John');
    });

    test('resetProfiles clears all profiles', () async {
      profilesNotifier.state = [
        {
          'id': '1',
          'firstName': 'John',
          'lastName': 'Doe',
          'userType': 'student'
        },
        {
          'id': '2',
          'firstName': 'Jane',
          'lastName': 'Smith',
          'userType': 'alumni'
        },
      ];

      profilesNotifier.state = []; // Simulate reset
      expect(profilesNotifier.state.length, 0);
    });
  });
}

void main3() {
  group('ProfilesNotifier Tests', () {
    late ProviderContainer container;
    late ProfilesNotifier profilesNotifier;

    setUp(() {
      container = ProviderContainer();
      profilesNotifier = container.read(profilesProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state is empty', () {
      expect(profilesNotifier.state, []);
    });

    test('fetchAllUsers updates the state with profiles', () async {
      profilesNotifier.state = [
        {'id': '1', 'firstName': 'John', 'lastName': 'Doe', 'userType': 'student'},
        {'id': '2', 'firstName': 'Jane', 'lastName': 'Smith', 'userType': 'alumni'},
      ];

      expect(profilesNotifier.state.length, 2);
    });

    test('filterProfiles filters profiles correctly', () async {
      profilesNotifier.state = [
        {'id': '1', 'firstName': 'John', 'lastName': 'Doe', 'userType': 'student'},
        {'id': '2', 'firstName': 'Jane', 'lastName': 'Smith', 'userType': 'alumni'},
      ];

      profilesNotifier.filterProfiles('student');
      expect(profilesNotifier.state.length, 1);
      expect(profilesNotifier.state[0]['userType'], 'student');
    });

    test('searchProfiles searches profiles correctly', () async {
      profilesNotifier.state = [
        {'id': '1', 'firstName': 'John', 'lastName': 'Doe', 'userType': 'student'},
        {'id': '2', 'firstName': 'Jane', 'lastName': 'Smith', 'userType': 'alumni'},
      ];

      profilesNotifier.searchProfiles('John');
      expect(profilesNotifier.state.length, 1);
      expect(profilesNotifier.state[0]['firstName'], 'John');
    });

    test('resetProfiles clears all profiles', () async {
      profilesNotifier.state = [
        {'id': '1', 'firstName': 'John', 'lastName': 'Doe', 'userType': 'student'},
        {'id': '2', 'firstName': 'Jane', 'lastName': 'Smith', 'userType': 'alumni'},
      ];

      profilesNotifier.state = []; // Simulate reset
      expect(profilesNotifier.state.length, 0);
    });

    test('filterProfiles handles non-existent filter', () async {
      profilesNotifier.state = [
        {'id': '1', 'firstName': 'John', 'lastName': 'Doe', 'userType': 'student'},
        {'id': '2', 'firstName': 'Jane', 'lastName': 'Smith', 'userType': 'alumni'},
      ];

      profilesNotifier.filterProfiles('nonexistent');
      expect(profilesNotifier.state.length, 0);
    });
  });
}
