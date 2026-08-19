package com.example.e_commerce_client.addresspicker

import android.content.Context
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

import com.example.app.generated.GoogleMapFlutterApi

class AddressPickerMapViewFactory(
    private val context: Context,
    private val mapRegistry: AddressPickerMapRegistry,
    private val flutterApi: GoogleMapFlutterApi,
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    companion object {
        const val VIEW_TYPE = "com.example.e_commerce_client/address_picker_map_view"
    }

    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
        return AddressPickerMapPlatformView (
            context = this.context,
            viewId = viewId.toLong(),
            mapRegistry = mapRegistry,
            flutterApi = flutterApi,
        )
    }
}
