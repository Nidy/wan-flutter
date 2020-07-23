package com.waikiki.wanflutter

import io.flutter.embedding.android.FlutterActivity
import androidx.annotation.NonNull;
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

import android.os.Bundle
import android.view.WindowManager

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // 隐藏状态栏代码
        window.addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN)
    }

    /// 重写onFlutterUiDisplayed方法，在Flutter界面显示后显示状态栏
    override fun onFlutterUiDisplayed() {
        super.onFlutterUiDisplayed()
        // 显示状态栏代码
        window.clearFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN)
    }

}
