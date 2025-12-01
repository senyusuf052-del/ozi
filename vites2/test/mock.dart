import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// A fake implementation of FirebasePlatform.
// This is used to mock Firebase for testing.
class FakeFirebasePlatform extends Fake with MockPlatformInterfaceMixin implements FirebasePlatform {
  @override
  Future<FirebaseAppPlatform> initializeApp({
    String? name,
    FirebaseOptions? options,
  }) async {
    return FakeFirebaseAppPlatform(name: name, options: options);
  }

  @override
  List<FirebaseAppPlatform> get apps => [FakeFirebaseAppPlatform()];

  @override
  FirebaseAppPlatform app([String name = defaultFirebaseAppName]) {
    return FakeFirebaseAppPlatform(name: name);
  }
}

// A fake implementation of FirebaseAppPlatform.
class FakeFirebaseAppPlatform extends Fake with MockPlatformInterfaceMixin implements FirebaseAppPlatform {
  FakeFirebaseAppPlatform({String? name, FirebaseOptions? options})
      : _name = name ?? defaultFirebaseAppName,
        _options = options ??
            const FirebaseOptions(
              apiKey: 'fake',
              appId: 'fake',
              messagingSenderId: 'fake',
              projectId: 'fake',
            );

  final String _name;
  final FirebaseOptions _options;

  @override
  String get name => _name;

  @override
  FirebaseOptions get options => _options;
}

// A helper function to set up Firebase for testing.
// This should be called in the test's main function.
void setupFirebaseMocks() {
  TestWidgetsFlutterBinding.ensureInitialized();
  Firebase.delegatePackingProperty = FakeFirebasePlatform();
}
