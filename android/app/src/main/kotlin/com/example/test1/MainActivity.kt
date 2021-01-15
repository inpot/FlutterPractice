package com.example.test1

import android.content.Context
import android.os.Bundle
import android.os.PersistableBundle
import android.util.Log
import android.view.View
import android.widget.Button
import android.widget.TextView
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MessageCodec
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class MainActivity: FlutterActivity() {


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        flutterEngine.platformViewsController.registry.registerViewFactory("First",PfViewFactory());
    }

}
class FirstPfView : PlatformView {
    val view: Button

    constructor(context: Context?,id:Int,param:String?){
        view = Button(context);
        view.setTextColor(0xff0000)
        view.text = param + " FirstPfView "
        view.setOnClickListener {
            Log.i("test","Onclicked")

        }
        view.setTextColor(0xff0000)

    }
    override fun getView(): View {
        Log.i("test","Dispose")
        return view
    }

    override fun dispose() {
        Log.i("test","Dispose")
    }

}
class PfViewFactory (): PlatformViewFactory (StandardMessageCodec.INSTANCE){

    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
        var parms = args as String
        return FirstPfView(context,viewId,parms )
    }


}
