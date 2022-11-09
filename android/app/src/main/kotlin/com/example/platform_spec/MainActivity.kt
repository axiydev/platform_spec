package com.example.platform_spec

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel

class MainActivity: FlutterActivity() {
    private val networkEventChannel = "com.example.platform_spec/connectivity"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, networkEventChannel)
            .setStreamHandler(NetworkStreamHandler(this))
        
     
        super.configureFlutterEngine(flutterEngine)
    }
}
