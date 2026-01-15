package com.kinosoft.flutter_native_unity

import android.content.res.Resources
import android.graphics.Color
import android.os.Bundle
import android.util.Log
import android.widget.Button
import android.widget.FrameLayout
import com.kinosoft.flutter_native_unity.NativeUnityActivity
import com.kinosoft.flutter_native_unity.IUnityStreamData
import com.kinosoft.flutter_native_unity.UnityMessageParser
import org.json.JSONObject

class ExampleUnityActivity : NativeUnityActivity(), IUnityStreamData {

    private val tag: String = UnityActivity::class.java.simpleName

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        addContents()
    }

    private fun addContents() {
        val buttonLayoutParams = FrameLayout.LayoutParams(150.px, 50.px)
        buttonLayoutParams.topMargin = getStatusBarHeight()

        val button = Button(this)
        button.layoutParams = buttonLayoutParams
        button.setOnClickListener {
            exitActivity()
        }
        button.setBackgroundColor(Color.BLUE)
        button.text = "Exit Button"
        unityPlayer.addView(button)
    }

    override fun onUnityMessage(message: String) {
//        super.onUnityMessage(message)
        Log.d(tag, message)

        val data = UnityMessageParser.parse(message)
        if (data.isNotEmpty()) {
            val jsonObject = JSONObject(data)

            val action = jsonObject.getString("action")
            if (action == "backButton") {
                exitActivity()
            }
        }
    }

    override fun onSceneLoaded(name: String, buildIndex: Int, isLoaded: Boolean, isValid: Boolean) {
        Log.d(tag, name)
    }
}

//val Int.dp: Int
//    get() = (this / Resources.getSystem().displayMetrics.density).toInt()
//val Int.px: Int
//    get() = (this * Resources.getSystem().displayMetrics.density).toInt()