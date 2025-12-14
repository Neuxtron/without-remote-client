package com.example.without_remote_client
import android.content.Context
import android.media.AudioManager
import android.view.KeyEvent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "media_control"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                val audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager

                fun sendKey(keyCode: Int) {
                    audioManager.dispatchMediaKeyEvent(
                        KeyEvent(KeyEvent.ACTION_DOWN, keyCode)
                    )
                    audioManager.dispatchMediaKeyEvent(
                        KeyEvent(KeyEvent.ACTION_UP, keyCode)
                    )
                }

                when (call.method) {
                    "playPause" -> sendKey(KeyEvent.KEYCODE_MEDIA_PLAY_PAUSE)
                    "next" -> sendKey(KeyEvent.KEYCODE_MEDIA_NEXT)
                    "previous" -> sendKey(KeyEvent.KEYCODE_MEDIA_PREVIOUS)
                    else -> result.notImplemented()
                }
                result.success(null)
            }
    }
}
