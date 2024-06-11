import 'flutter_native_unity_platform_interface.dart';

class FlutterNativeUnity {
  Future<void> launch({
    required String initData,
    String? className,
  }) {
    return FlutterNativeUnityPlatform.instance.launch(
      initData: initData, className: className,
    );
  }
}