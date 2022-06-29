package com.adsbynimbus.reactnative

import com.adsbynimbus.Nimbus
import com.adsbynimbus.request.RequestManager
import com.facebook.react.ReactPackage
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.ViewManager

class NimbusReactNativePackage : ReactPackage {
    override fun createNativeModules(reactContext: ReactApplicationContext): List<NativeModule> =
        listOf(NimbusReactNativeModule(reactContext))


    override fun createViewManagers(reactContext: ReactApplicationContext): List<ViewManager<*, *>> =
        listOf(NimbusReactNativeViewManager())
}

class NimbusReactNativeModule(
    private val reactContext: ReactApplicationContext,
    private val publisherKey: String = "dev-sdk",
    private val apiKey: String = "DEV-cae2-4774-97ba-4e15c6276be0"
) : NativeModule {
    override fun getName(): String = "Nimbus"

    override fun initialize() {
        Nimbus.initialize(reactContext, publisherKey, apiKey)
        Nimbus.testMode = true
        RequestManager.setRequestUrl("https://dev-sdk.adsbynimbus.com/rta/test")
    }

    override fun canOverrideExistingModule(): Boolean = false

    override fun onCatalystInstanceDestroy() {}
}
