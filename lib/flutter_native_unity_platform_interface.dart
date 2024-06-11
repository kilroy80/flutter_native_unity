import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_native_unity_method_channel.dart';

abstract class FlutterNativeUnityPlatform extends PlatformInterface {
  /// Constructs a FlutterNativeUnityPlatform.
  FlutterNativeUnityPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterNativeUnityPlatform _instance = MethodChannelFlutterNativeUnity();

  /// The default instance of [FlutterNativeUnityPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterNativeUnity].
  static FlutterNativeUnityPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterNativeUnityPlatform] when
  /// they register themselves.
  static set instance(FlutterNativeUnityPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> launch({
    required String initData,
    String? className,
  }) {
    throw UnimplementedError('launch() has not been implemented.');
  }
}
