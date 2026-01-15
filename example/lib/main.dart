import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_native_unity/flutter_native_unity.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: MaterialButton(
            onPressed: () {
              FlutterNativeUnity().launch(
                initData: 'json_to_string',
                className: Platform.isAndroid
                    ? 'ExampleUnityActivity' : 'ExampleViewController',
              );
            },
            child: const Text('Open Unity Screen\n'),
          ),
        ),
      ),
    );
  }
}
