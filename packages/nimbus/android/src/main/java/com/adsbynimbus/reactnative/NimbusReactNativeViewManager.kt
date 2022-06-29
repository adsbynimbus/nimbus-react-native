package com.adsbynimbus.reactnative

import android.graphics.Color
import android.util.Log
import android.view.View
import com.adsbynimbus.NimbusAdManager
import com.adsbynimbus.NimbusError
import com.adsbynimbus.render.AdController
import com.adsbynimbus.render.Renderer.Companion.loadBlockingAd
import com.adsbynimbus.request.NimbusRequest
import com.adsbynimbus.request.NimbusResponse
import com.adsbynimbus.request.RequestManager
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.annotations.ReactProp

class NimbusReactNativeViewManager(val adManager: NimbusAdManager = NimbusAdManager()) :
    SimpleViewManager<View>() {

    var View.reactController: AdController?
        get() = getTag(R.id.nimbus_react_controller) as? AdController
        set(value) = setTag(R.id.nimbus_react_controller, value)

    override fun onDropViewInstance(view: View) {
        view.reactController?.destroy()
    }

    override fun getName() = "NimbusReactNativeView"

    override fun createViewInstance(reactContext: ThemedReactContext): View =
        View(reactContext).apply {
            adManager.makeRequest(reactContext,
                NimbusRequest.forInterstitialAd("React Native Sample"),
                object : RequestManager.Listener {
                    override fun onAdResponse(nimbusResponse: NimbusResponse) {
                        reactContext.loadBlockingAd(nimbusResponse)?.let {
                            reactController = it
                            it.start()
                        }
                    }

                    override fun onError(error: NimbusError) {
                        Log.w(null, "Error Loading Ad ${error.cause}")
                    }
                })
        }

    @ReactProp(name = "color")
    fun setColor(view: View, color: String) {
        view.setBackgroundColor(Color.parseColor(color))
    }
}
