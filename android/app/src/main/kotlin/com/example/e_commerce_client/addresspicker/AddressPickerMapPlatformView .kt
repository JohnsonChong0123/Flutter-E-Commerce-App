package com.example.e_commerce_client.addresspicker

import android.content.Context
import android.view.View
import com.google.android.gms.maps.GoogleMap
import com.google.android.gms.maps.MapView
import com.google.android.gms.maps.OnMapReadyCallback
import io.flutter.plugin.platform.PlatformView

import com.example.app.generated.GoogleMapFlutterApi

class AddressPickerMapPlatformView (
    context: Context,
    private val viewId: Long,
    private val mapRegistry: AddressPickerMapRegistry,
    private val flutterApi: GoogleMapFlutterApi,
) : PlatformView, OnMapReadyCallback {

    private val mapView: MapView = MapView(context)

    init {
        mapView.onCreate(null)
        mapView.getMapAsync(this)
    }

    override fun getView(): View {
        return mapView
    }

    override fun onMapReady(googleMap: GoogleMap) {
        googleMap.uiSettings.isCompassEnabled = true
        googleMap.uiSettings.isMapToolbarEnabled = false
        googleMap.uiSettings.isZoomControlsEnabled = true
        googleMap.setOnCameraIdleListener {
            val target = googleMap.cameraPosition.target
            flutterApi.onCameraIdle(viewId, target.latitude, target.longitude) { }
        }
        googleMap.setOnMarkerDragListener(
            object : GoogleMap.OnMarkerDragListener {
                override fun onMarkerDragStart(marker: com.google.android.gms.maps.model.Marker) = Unit

                override fun onMarkerDrag(marker: com.google.android.gms.maps.model.Marker) = Unit

                override fun onMarkerDragEnd(marker: com.google.android.gms.maps.model.Marker) {
                    val position = marker.position
                    flutterApi.onMarkerDragEnd(viewId, position.latitude, position.longitude) { }
                }
            },
        )
        mapRegistry.attachMap(viewId, googleMap)
        mapView.onResume()
    }

    override fun dispose() {
        mapRegistry.detachMap(viewId)
        mapView.onPause()
        mapView.onDestroy()
    }
}
