import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_native_unity/flutter_native_unity.dart';
import 'package:flutter_native_unity/flutter_native_unity_platform_interface.dart';
import 'package:flutter_native_unity/flutter_native_unity_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterNativeUnityPlatform
    with MockPlatformInterfaceMixin
    implements FlutterNativeUnityPlatform {

  // @override
  // Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<void> launch({
    required String initData,
    String? className,}) async {
  }
}

void main() {
  final FlutterNativeUnityPlatform initialPlatform = FlutterNativeUnityPlatform.instance;

  test('$MethodChannelFlutterNativeUnity is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterNativeUnity>());
  });

  test('getPlatformVersion', () async {
    FlutterNativeUnity flutterNativeUnityPlugin = FlutterNativeUnity();
    MockFlutterNativeUnityPlatform fakePlatform = MockFlutterNativeUnityPlatform();
    FlutterNativeUnityPlatform.instance = fakePlatform;

    // expect(await flutterNativeUnityPlugin.getPlatformVersion(), '42');
  });
}
