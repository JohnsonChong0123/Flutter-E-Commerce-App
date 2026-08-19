package com.example.e_commerce_client.addresspicker

import com.google.android.gms.maps.CameraUpdateFactory
import com.google.android.gms.maps.model.LatLng
import com.google.android.gms.maps.model.MarkerOptions

import com.example.app.generated.GoogleMapHostApi 
import com.example.app.generated.MarkerDto   

class AddressPickerGoogleMapHostApi(
    private val mapRegistry: AddressPickerMapRegistry,
) : GoogleMapHostApi {

    override fun initializeMap(viewId: Long) {
        // Keep contract explicit; map operations are queued until view is ready.
        mapRegistry.withMap(viewId) { _ -> }
    }

    override fun updateStoreMarkers(viewId: Long, markers: List<MarkerDto>) {
        mapRegistry.withMap(viewId) { googleMap ->
            googleMap.clear()
            for (marker in markers) {
                val markerLatLng = LatLng(marker.latitude, marker.longitude)
                googleMap.addMarker(
                    MarkerOptions()
                        .position(markerLatLng)
                        .title(marker.title)
                        .snippet(marker.address)
                )
            }
        }
    }

    override fun moveCamera(viewId: Long, latitude: Double, longitude: Double, zoom: Double) {
        mapRegistry.withMap(viewId) { googleMap ->
            val position = LatLng(latitude, longitude)
            googleMap.animateCamera(CameraUpdateFactory.newLatLngZoom(position, zoom.toFloat()))
        }
    }
}
