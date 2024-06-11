package com.kinosoft.flutter_native_unity

import org.json.JSONObject

object UnityMessageParser {

    fun parse(message: String): String {

        if (!message.startsWith("@UnityMessage@")) return ""

        val unityMessage = message.replace("@UnityMessage@", "")
        val jsonObject = JSONObject(unityMessage)

        val id = jsonObject.getInt("id")
        val seq = jsonObject.getString("seq")
        val name = jsonObject.getString("name")
        val data = jsonObject.getJSONObject("data")

        return data.toString()
    }
}