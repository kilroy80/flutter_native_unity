#include "include/flutter_native_unity/flutter_native_unity_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "flutter_native_unity_plugin.h"

void FlutterNativeUnityPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  flutter_native_unity::FlutterNativeUnityPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
