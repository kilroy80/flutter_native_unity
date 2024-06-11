package com.kinosoft.flutter_native_unity

interface IUnityStreamData {
    fun onSceneLoaded(name: String, buildIndex: Int, isLoaded: Boolean, isValid: Boolean)
    fun onUnityMessage(message: String)
}