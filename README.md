# flutter_native_unity

Flutter에서 **Unity**를 네이티브 방식으로 임베드하기 위한 **보조 플러그인**입니다.

본 플러그인은 **단독 사용을 위한 플러그인이 아니며**,  
**flutter_unity_widget** 플러그인을 사용할 때 발생하는 문제점(메모리 누수, 터치 이벤트 불안정 등)을 보완하기 위한 **보조 역할**을 합니다.

> 현재 메시지 통신은 **flutter_unity_widget** 패키지를 그대로 사용하며, Android / iOS 네이티브 코드로 지원합니다.

---

## 목적

- Flutter 앱 내에서 Unity 화면을 보다 안정적으로 표시하기 위한 **네이티브 레벨 지원**
- Android에서 `UnityActivity`를 별도 프로세스(`:unity`)로 실행하여 메인 앱 충돌 최소화
- iOS에서 `UIViewController` 기반의 별도 화면으로 실행하여 메인 앱 충돌 최소화
- (향후 목표)
    - 양방향 통신 브릿지 강화
    - **flutter_unity_widget** 의존성 제거
    - 단독 플러그인으로 전환

---

## 사용 방식

### 1. 의존성 추가 (pubspec.yaml)

```yaml
dependencies:
    flutter_unity_widget: # 또는 최신 버전
    git:
      url: https://github.com/kilroy80/flutter-unity-view-widget
      ref: '23625ce926b26ef5edfef65df64328e638c1e38d'   

  flutter_native_unity:
    git:
      url: https://github.com/kilroy80/flutter_native_unity.git
```

---

### 2. 기타 설정

[flutter_unity_widget](https://pub.dev/packages/flutter_unity_widget) 플러그인 페이지를 참고하여 동일하게 설정합니다.

---

### 3. Android 설정

#### App 레벨 `build.gradle`에 의존성 추가

```groovy
dependencies {
    compileOnly rootProject.findProject(":flutter_native_unity")
}
```

#### App 레벨 `AndroidManifest.xml`에 Activity 추가

```xml
<application>
    <activity
        android:name=".UnityActivity"
        android:process=":unity" />
</application>
```

> ⚠️ 주의  
`${plugin-path}/android/libs` 경로에 있는 `unity-classes.jar` 파일은  
**빌드한 Unity 버전에 맞는 jar 파일로 반드시 교체해야 합니다.**  
버전이 맞지 않을 경우 Android 앱이 실행 즉시 종료됩니다.

---

### 4. iOS 설정

iOS는 별도의 추가 설정이 필요하지 않습니다.

---

## 실행 코드

### Flutter

`FlutterNativeUnity().launch()` 함수 설명

- `initData`  
  Activity 또는 ViewController 초기화 시 필요한 데이터를 **JSON 문자열**로 전달
- `className`  
  네이티브에서 실행할 Activity(Android) 또는 ViewController(iOS)의 클래스 이름

```dart
import 'dart:io';
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

`${plugin-path}/android/src` 경로에 있는  
**NativeUnityActivity** 클래스를 상속받아 Activity를 Kotlin 또는 Java로 직접 구현합니다.

자세한 내용은 예제 코드 **ExampleUnityActivity**를 참고하세요.

---

### iOS

`${plugin-path}/ios/Classes` 경로에 있는  
**NativeUnityViewController** 클래스를 상속받아 ViewController를 Swift로 직접 구현합니다.

자세한 내용은 예제 코드 **ExampleViewController**를 참고하세요.

---

## 라이선스

MIT License
