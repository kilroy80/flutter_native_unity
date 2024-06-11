package com.kinosoft.flutter_native_unity

import android.annotation.SuppressLint
import android.app.Activity
import android.app.ActivityManager
import android.content.Context
import android.content.res.Configuration
import android.content.res.Resources
import android.os.Build
import android.os.Bundle
import android.os.Process
import android.util.Log
import android.view.KeyEvent
import android.view.MotionEvent
import android.view.Window
import android.view.WindowManager
import android.widget.FrameLayout
import com.unity3d.player.IUnityPlayerLifecycleEvents
import com.unity3d.player.UnityPlayer
import com.xraph.plugin.flutter_unity_widget.DataStreamEventNotifier
import com.xraph.plugin.flutter_unity_widget.DataStreamEventTypes
import io.reactivex.rxjava3.android.schedulers.AndroidSchedulers
import org.json.JSONObject


open class NativeUnityActivity : Activity(), IUnityStreamData {

    private val tag: String = NativeUnityActivity::class.java.simpleName

    companion object {
        const val EXTRA_FULL_SCREEN = "extra_full_screen"
        const val EXTRA_KEEP_SCREEN_ON = "extra_keep_screen_on"
        const val EXTRA_INIT_MESSAGE = "extra_init_message"
    }

    // don't change the name of this variable; referenced from native code
    protected lateinit var mUnityPlayer: UnityPlayer

    val unityPlayer: FrameLayout
        get() = mUnityPlayer

    override fun onCreate(savedInstanceState: Bundle?) {
        requestWindowFeature(Window.FEATURE_NO_TITLE)
        super.onCreate(savedInstanceState)

        mUnityPlayer = UnityPlayer(this, object : IUnityPlayerLifecycleEvents {
            override fun onUnityPlayerUnloaded() {
//                moveTaskToBack(true);
            }

            override fun onUnityPlayerQuitted() {
            }
        })
        setContentView(mUnityPlayer)

        mUnityPlayer.requestFocus()

        val i = intent
        val isFullScreen = i.getStringExtra(EXTRA_FULL_SCREEN) ?: false
        val isKeepScreenOn = i.getStringExtra(EXTRA_KEEP_SCREEN_ON) ?: true
        val initMessage = i.getStringExtra(EXTRA_INIT_MESSAGE) ?: ""

        // must setContentView after
        if (isFullScreen == false) {
            window.clearFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN)
            window.addFlags(WindowManager.LayoutParams.FLAG_FORCE_NOT_FULLSCREEN)
//            window.addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS)
            window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS)

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                window.attributes.layoutInDisplayCutoutMode = WindowManager.LayoutParams.LAYOUT_IN_DISPLAY_CUTOUT_MODE_SHORT_EDGES;
            }
        }

        if (isKeepScreenOn == true) {
            window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        }

        if (initMessage.isNotEmpty()) {
            Log.e(tag, "init message: $initMessage")
        }

        // receive message
        registerDataStream()

//        addContents()
    }

//    private fun addContents() {
//        val buttonLayoutParams = FrameLayout.LayoutParams(150.px, 50.px)
//        buttonLayoutParams.topMargin = getStatusBarHeight()
//
//        val button = Button(this)
//        button.layoutParams = buttonLayoutParams
//        button.setOnClickListener {
//            android.os.Process.killProcess(android.os.Process.myPid())
//        }
//        button.setBackgroundColor(Color.RED)
//        button.text = "Exit Button"
//        unityPlayer.addView(button)
//    }

    @SuppressLint("CheckResult")
    fun registerDataStream() {
        DataStreamEventNotifier.notifier.subscribeOn(AndroidSchedulers.mainThread())
            .observeOn(AndroidSchedulers.mainThread()).subscribe {
                subscribeData(it.toMap())
            }
    }

    @SuppressLint("CheckResult")
    fun unRegisterDataStream() {
        DataStreamEventNotifier.notifier.unsubscribeOn(AndroidSchedulers.mainThread())
    }

    private fun subscribeData(streamData: Map<String, Any>) {
        when (streamData["eventType"].toString()) {
            DataStreamEventTypes.OnUnitySceneLoaded.name -> {
                if (streamData["name"] != null && streamData["buildIndex"] != null
                    && streamData["isLoaded"] != null && streamData["isValid"] != null) {

                    onSceneLoaded(
                        streamData["name"].toString(),
                        streamData["buildIndex"].toString().toInt(),
                        streamData["isLoaded"].toString().toBoolean(),
                        streamData["isValid"].toString().toBoolean()
                    )
                }
            }
            DataStreamEventTypes.OnUnityMessage.name -> {
                if (streamData["data"] != null) {
                    onUnityMessage(streamData["data"].toString())
                }
            }
        }
    }

    fun sendNativeMessage(
        gameObj: String?,
        method: String?,
        arg: String?
    ) {
        UnityPlayer.UnitySendMessage(gameObj, method, arg)
    }

    override fun onUnityMessage(message: String) {
        val unityMessage = message.replace("@UnityMessage@", "")
        val jsonObject = JSONObject(unityMessage)

        val id = jsonObject.getInt("id")
        val seq = jsonObject.getString("seq")
        val name = jsonObject.getString("name")
        val data = jsonObject.getJSONObject("data")
    }

    override fun onSceneLoaded(name: String, buildIndex: Int, isLoaded: Boolean, isValid: Boolean) {
        Log.e(tag, name)
    }

    fun exitActivity() {
        onDestroy()
        android.os.Process.killProcess(android.os.Process.myPid())

//        val processName = getProcessName(this) ?: ""
//        if (processName.isNotEmpty() && processName.contains(":")) {
//            android.os.Process.killProcess(android.os.Process.myPid())
//        } else {
//            onPause()
//            finish()
//            overridePendingTransition(0, 0)
//        }
    }

    override fun onStart() {
        super.onStart()

//        if (!MultiWindowSupport.isInMultiWindowMode(this))
//            return
//
//        mUnityPlayer.resume()
    }

    override fun onStop() {
        super.onStop()

//        if (!MultiWindowSupport.isInMultiWindowMode(this))
//            return
//
//        mUnityPlayer.pause()
    }

    override fun onResume() {
        super.onResume()

//        if (MultiWindowSupport.isInMultiWindowMode(this) && !MultiWindowSupport.isMultiWindowModeChangedToTrue(this))
//            return

        mUnityPlayer.resume()
    }

    override fun onPause() {
        super.onPause()

//        MultiWindowSupport.saveMultiWindowMode(this)
//
//        if (MultiWindowSupport.isInMultiWindowMode(this))
//            return

        mUnityPlayer.pause()
    }

    override fun onDestroy() {
        mUnityPlayer.destroy();
        super.onDestroy()

        unRegisterDataStream()
    }

    // Low Memory Unity
    override fun onLowMemory() {
        super.onLowMemory()
        mUnityPlayer.lowMemory()
    }

    // Trim Memory Unity
    override fun onTrimMemory(level: Int) {
        super.onTrimMemory(level)
        if (level == TRIM_MEMORY_RUNNING_CRITICAL) {
            mUnityPlayer.lowMemory()
        }
    }

    // This ensures the layout will be correct.
    override fun onConfigurationChanged(newConfig: Configuration) {
        super.onConfigurationChanged(newConfig)
        mUnityPlayer.configurationChanged(newConfig)
    }

    // Notify Unity of the focus change.
    override fun onWindowFocusChanged(hasFocus: Boolean) {
        super.onWindowFocusChanged(hasFocus)
        mUnityPlayer.windowFocusChanged(hasFocus)
    }

    // For some reason the multiple keyevent type is not supported by the ndk.
    // Force event injection by overriding dispatchKeyEvent().
    override fun dispatchKeyEvent(event: KeyEvent): Boolean {
        return if (event.action == KeyEvent.ACTION_MULTIPLE) mUnityPlayer.injectEvent(event)
            else super.dispatchKeyEvent(
            event
        )
    }

    // Pass any events not handled by (unfocused) views straight to UnityPlayer
    override fun onKeyUp(keyCode: Int, event: KeyEvent?): Boolean {
        return mUnityPlayer.onKeyUp(keyCode, event)
    }

    override fun onKeyDown(keyCode: Int, event: KeyEvent?): Boolean {
        return mUnityPlayer.onKeyDown(keyCode, event)
    }

    override fun onTouchEvent(event: MotionEvent?): Boolean {
        return mUnityPlayer.onTouchEvent(event)
    }

    override fun onGenericMotionEvent(event: MotionEvent?): Boolean {
        return mUnityPlayer.onGenericMotionEvent(event)
    }

    fun getStatusBarHeight(): Int {
        val resourceId = resources.getIdentifier("status_bar_height", "dimen", "android")
        return if (resourceId > 0) {
            resources.getDimensionPixelSize(resourceId)
        } else 0
    }

    fun getNavigationBarHeight(): Int {
        val resourceId = resources.getIdentifier("navigation_bar_height", "dimen", "android")
        return if (resourceId > 0) {
            resources.getDimensionPixelSize(resourceId)
        } else 0
    }

    open fun getProcessName(context: Context): String? {
        val pid = Process.myPid()
        val manager = context.getSystemService(ACTIVITY_SERVICE) as ActivityManager
        val infoList = manager.runningAppProcesses
        if (infoList != null) {
            for (processInfo in infoList) {
                if (processInfo.pid == pid) {
                    return processInfo.processName
                }
            }
        }
        return null
    }
}

val Int.dp: Int
    get() = (this / Resources.getSystem().displayMetrics.density).toInt()
val Int.px: Int
    get() = (this * Resources.getSystem().displayMetrics.density).toInt()