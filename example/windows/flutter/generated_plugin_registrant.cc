//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <flutter_native_unity/flutter_native_unity_plugin_c_api.h>
#include <flutter_unity_widget/flutter_unity_widget_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  FlutterNativeUnityPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterNativeUnityPluginCApi"));
  FlutterUnityWidgetPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterUnityWidgetPlugin"));
}
