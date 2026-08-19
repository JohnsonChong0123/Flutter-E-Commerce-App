package com.example.e_commerce_client.addresspicker

import com.google.android.gms.maps.GoogleMap
import java.util.concurrent.ConcurrentHashMap

class AddressPickerMapRegistry {
    private val maps = ConcurrentHashMap<Long, GoogleMap>()
    private val pendingOperations = ConcurrentHashMap<Long, MutableList<(GoogleMap) -> Unit>>()

    fun attachMap(viewId: Long, googleMap: GoogleMap) {
        maps[viewId] = googleMap
        pendingOperations.remove(viewId)?.forEach { operation ->
            operation(googleMap)
        }
    }

    fun detachMap(viewId: Long) {
        maps.remove(viewId)
        pendingOperations.remove(viewId)
    }

    fun withMap(viewId: Long, operation: (GoogleMap) -> Unit) {
        val map = maps[viewId]
        if (map != null) {
            operation(map)
            return
        }

        val queue = pendingOperations.getOrPut(viewId) { mutableListOf() }
        queue.add(operation)
    }
}
