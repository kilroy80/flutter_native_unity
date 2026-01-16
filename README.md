# flutter_native_unity

[한국어](README.ko.md)

A **supplementary plugin** for embedding **Unity** into Flutter applications in a **native manner**.

This plugin is **not intended to be used standalone**.  
It is designed to **complement** the **flutter_unity_widget** plugin by addressing common issues such as **memory leaks** and **unstable touch events**.

> Currently, message communication continues to rely on the **flutter_unity_widget** package, while native-level support is provided for Android and iOS.

---

## Purpose

- Provide **native-level support** for more stable Unity rendering inside Flutter apps
- On **Android**, run `UnityActivity` in a **separate process** (`:unity`) to minimize crashes in the main app
- On **iOS**, run Unity in a **separate UIViewController-based screen** to minimize crashes in the main app
- (Future goals)
  - Enhance the **bi-directional communication bridge**
  - Remove dependency on **flutter_unity_widget**
  - Transition into a **standalone plugin**

---

## Usage

### 1. Add Dependencies (`pubspec.yaml`)

```yaml
dependencies:
  flutter_unity_widget: # or the latest version
    git:
      url: https://github.com/kilroy80/flutter-unity-view-widget
      ref: '6bf900b5c297d3bf6cbcca8af32c0af2dbe8d7ae'

  flutter_native_unity:
    git:
      url: https://github.com/kilroy80/flutter_native_unity.git
```

---

### 2. Additional Configuration

Follow the same configuration steps described on the  
[flutter_unity_widget](https://pub.dev/packages/flutter_unity_widget) plugin page.

---

### 3. Android Setup

#### Add Dependency in App-level `build.gradle` or `build.gradle.kts`

```groovy
// build.gradle
dependencies {
    compileOnly rootProject.findProject(":flutter_native_unity")
}
```

```kotlin
// build.gradle.kts
dependencies {
    rootProject.findProject(":flutter_native_unity")?.let {
        compileOnly(it)
    }
}
```

#### Add Activity in App-level `AndroidManifest.xml`

```xml
<application>
    <activity
        android:name=".ExampleUnityActivity"
        android:process=":unity" />
</application>
```

> ⚠️ **Important**  
> The `unity-classes.jar` file located at `${plugin-path}/android/libs` **must be replaced** with the JAR file that matches your **Unity build version**.  
> If the versions do not match, the Android app may **crash immediately on launch**.

---

### 4. iOS Setup

No additional configuration is required for iOS.

---

## Runtime Code

### Flutter

`FlutterNativeUnity().launch()` function parameters:

- `initData`  
  A **JSON string** containing initialization data passed when the Activity or ViewController is created
- `className`  
  The class name of the native **Activity (Android)** or **ViewController (iOS)** to launch

```dart
import 'package:flutter_native_unity/flutter_native_unity.dart';

MaterialButton(
  onPressed: () {
    FlutterNativeUnity().launch(
      initData: 'json_to_string',
      className: Platform.isAndroid
          ? 'ExampleUnityActivity'
          : 'ExampleViewController',
    );
  },
  child: const Text('Open Unity Screen'),
);
```

---

### Android

Under `${plugin-path}/android/src`,  
extend the **NativeUnityActivity** class and implement your own Activity in **Kotlin or Java**.

Refer to the **ExampleUnityActivity** sample code for details.

---

### iOS

Under `${plugin-path}/ios/Classes`,  
extend the **NativeUnityViewController** class and implement your own ViewController in **Swift**.

Refer to the **ExampleViewController** sample code for details.

---

## License

MIT License