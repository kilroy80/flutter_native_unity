# flutter_native_unity

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter development, view the
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Android

```
Add app level gradle : 
compileOnly rootProject.findProject(":flutter_native_unity")
    
Add AndroidManifest.xml
<activity
    android:name=".UnityActivity"
    android:process=":unity">
</activity>


```