package com.example.e_commerce_client.addresspicker

import com.google.android.gms.maps.GoogleMap
import org.junit.Assert.*
import org.junit.Before
import org.junit.Test
import io.mockk.mockk

class AddressPickerMapRegistryTest {

    private lateinit var mapRegistry: AddressPickerMapRegistry
    private lateinit var mockGoogleMap: GoogleMap

    @Before
    fun setUp() {
        mapRegistry = AddressPickerMapRegistry()
        mockGoogleMap = mockk<GoogleMap>()
    }

    @Test
    fun `attachMap and withMap should execute operation immediately when map is attached`() {
        val viewId = 123L
        val operationExecuted = mutableListOf<GoogleMap>()

        // Attach map first
        mapRegistry.attachMap(viewId, mockGoogleMap)

        // Then call withMap - should execute immediately
        mapRegistry.withMap(viewId) { googleMap ->
            operationExecuted.add(googleMap)
        }

        // Verify operation was executed with the correct map
        assertEquals(1, operationExecuted.size)
        assertEquals(mockGoogleMap, operationExecuted[0])
    }

    @Test
    fun `withMap should queue operation when map is not yet attached`() {
        val viewId = 123L
        val operationExecuted = mutableListOf<GoogleMap>()

        // Call withMap before attaching map - should queue the operation
        mapRegistry.withMap(viewId) { googleMap ->
            operationExecuted.add(googleMap)
        }

        // Verify operation was not executed yet
        assertTrue(operationExecuted.isEmpty())

        // Now attach the map - should execute queued operation
        mapRegistry.attachMap(viewId, mockGoogleMap)

        // Verify operation was executed with the correct map
        assertEquals(1, operationExecuted.size)
        assertEquals(mockGoogleMap, operationExecuted[0])
    }

    @Test
    fun `multiple queued operations should all execute when map is attached`() {
        val viewId = 123L
        val operationExecuted = mutableListOf<GoogleMap>()

        // Queue multiple operations
        mapRegistry.withMap(viewId) { googleMap ->
            operationExecuted.add(googleMap)
        }
        mapRegistry.withMap(viewId) { googleMap ->
            operationExecuted.add(googleMap)
        }
        mapRegistry.withMap(viewId) { googleMap ->
            operationExecuted.add(googleMap)
        }

        // Verify operations were not executed yet
        assertTrue(operationExecuted.isEmpty())

        // Attach the map - should execute all queued operations
        mapRegistry.attachMap(viewId, mockGoogleMap)

        // Verify all operations were executed
        assertEquals(3, operationExecuted.size)
        assertTrue(operationExecuted.all { it == mockGoogleMap })
    }

    @Test
    fun `detachMap should clear pending operations`() {
        val viewId = 123L
        val operationExecuted = mutableListOf<GoogleMap>()

        // Queue operation before map is attached
        mapRegistry.withMap(viewId) { googleMap ->
            operationExecuted.add(googleMap)
        }

        // Detach should clear pending operation
        mapRegistry.detachMap(viewId)

        // Attach map later
        mapRegistry.attachMap(viewId, mockGoogleMap)

        // Operation should NOT be executed
        assertTrue(operationExecuted.isEmpty())
    }

    @Test
    fun `withMap after detachMap should queue new operations`() {
        val viewId = 123L
        val operationExecuted = mutableListOf<GoogleMap>()

        // Attach and then detach map
        mapRegistry.attachMap(viewId, mockGoogleMap)
        mapRegistry.detachMap(viewId)

        // Call withMap after detach - should queue operation
        mapRegistry.withMap(viewId) { googleMap ->
            operationExecuted.add(googleMap)
        }

        // Verify operation was queued, not executed
        assertTrue(operationExecuted.isEmpty())

        // Attach map again - should execute queued operation
        mapRegistry.attachMap(viewId, mockGoogleMap)

        // Verify operation was executed
        assertEquals(1, operationExecuted.size)
        assertEquals(mockGoogleMap, operationExecuted[0])
    }

    @Test
    fun `different viewIds should have independent map and operation queues`() {
        val viewId1 = 123L
        val viewId2 = 456L
        val operationExecuted1 = mutableListOf<GoogleMap>()
        val operationExecuted2 = mutableListOf<GoogleMap>()
        val mockGoogleMap2 = mockk<GoogleMap>()

        // Attach map for viewId1
        mapRegistry.attachMap(viewId1, mockGoogleMap)

        // Queue operation for viewId2 (no map attached yet)
        mapRegistry.withMap(viewId2) { googleMap ->
            operationExecuted2.add(googleMap)
        }

        // Execute operation for viewId1
        mapRegistry.withMap(viewId1) { googleMap ->
            operationExecuted1.add(googleMap)
        }

        // Verify viewId1 operation executed, viewId2 operation queued
        assertEquals(1, operationExecuted1.size)
        assertEquals(mockGoogleMap, operationExecuted1[0])
        assertTrue(operationExecuted2.isEmpty())

        // Attach map for viewId2
        mapRegistry.attachMap(viewId2, mockGoogleMap2)

        // Verify viewId2 operation executed
        assertEquals(1, operationExecuted2.size)
        assertEquals(mockGoogleMap2, operationExecuted2[0])
    }

    @Test
    fun `attachMap should replace existing map for same viewId`() {
        val viewId = 123L
        val operationExecuted = mutableListOf<GoogleMap>()
        val mockGoogleMap2 = mockk<GoogleMap>()

        // Attach first map
        mapRegistry.attachMap(viewId, mockGoogleMap)

        // Attach second map (should replace first)
        mapRegistry.attachMap(viewId, mockGoogleMap2)

        // Execute operation - should use the second map
        mapRegistry.withMap(viewId) { googleMap ->
            operationExecuted.add(googleMap)
        }

        // Verify second map was used
        assertEquals(1, operationExecuted.size)
        assertEquals(mockGoogleMap2, operationExecuted[0])
    }

    @Test
    fun `pending operations should be cleared when map is attached`() {
        val viewId = 123L
        val operationExecuted = mutableListOf<GoogleMap>()

        // Queue multiple operations
        mapRegistry.withMap(viewId) { googleMap ->
            operationExecuted.add(googleMap)
        }
        mapRegistry.withMap(viewId) { googleMap ->
            operationExecuted.add(googleMap)
        }

        // Attach map - should execute all queued operations
        mapRegistry.attachMap(viewId, mockGoogleMap)

        // Verify all operations executed
        assertEquals(2, operationExecuted.size)

        // Call withMap again - should execute immediately (not queue)
        mapRegistry.withMap(viewId) { googleMap ->
            operationExecuted.add(googleMap)
        }

        // Verify new operation executed immediately
        assertEquals(3, operationExecuted.size)
    }
}