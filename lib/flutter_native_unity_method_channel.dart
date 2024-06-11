import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_native_unity_platform_interface.dart';

/// An implementation of [FlutterNativeUnityPlatform] that uses method channels.
class MethodChannelFlutterNativeUnity extends FlutterNativeUnityPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_native_unity');

  @override
  Future<void> launch({
    required String initData,
    String? className,
  }) async {
    await methodChannel.invokeMethod('unity#vc#create', {
      'className': className,
      'data': initData,
    });
  }
}
