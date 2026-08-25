package com.example.e_commerce_client.addresspicker

import com.google.android.gms.maps.CameraUpdate
import com.google.android.gms.maps.CameraUpdateFactory
import com.google.android.gms.maps.GoogleMap
import com.google.android.gms.maps.model.LatLng
import io.mockk.*
import org.junit.After
import org.junit.Assert.*
import org.junit.Before
import org.junit.Test

class AddressPickerGoogleMapHostApiTest {

    private lateinit var mapRegistry: AddressPickerMapRegistry
    private lateinit var mockGoogleMap: GoogleMap
    private lateinit var hostApi: AddressPickerGoogleMapHostApi
    private lateinit var cameraUpdate: CameraUpdate

    @Before
    fun setUp() {
        mapRegistry = AddressPickerMapRegistry()
        mockGoogleMap = mockk<GoogleMap>(relaxed = true)
        hostApi = AddressPickerGoogleMapHostApi(mapRegistry)
        cameraUpdate = mockk()
    }

    @After
    fun tearDown() {
        // Clean up static mocks (CameraUpdateFactory) so they don't leak across tests.
        unmockkAll()
    }

    // -----------------------------------------------------------------------------------------
    // Delegation tests: the host API must forward the correct viewId to the registry's withMap.
    // -----------------------------------------------------------------------------------------

    @Test
    fun `initializeMap delegates to registry withMap with the given viewId`() {
        val viewId = 99L
        val mockRegistry = mockk<AddressPickerMapRegistry>(relaxed = true)

        val api = AddressPickerGoogleMapHostApi(mockRegistry)
        api.initializeMap(viewId)

        verify(exactly = 1) { mockRegistry.withMap(eq(viewId), any()) }
    }

    @Test
    fun `moveCamera delegates to registry withMap with the given viewId`() {
        val viewId = 99L
        val mockRegistry = mockk<AddressPickerMapRegistry>(relaxed = true)

        val api = AddressPickerGoogleMapHostApi(mockRegistry)
        api.moveCamera(viewId, 37.4219, -122.0841, 15.0)

        verify(exactly = 1) { mockRegistry.withMap(eq(viewId), any()) }
    }

    // -----------------------------------------------------------------------------------------
    // Behavior tests: real registry + mocked GoogleMap.
    // -----------------------------------------------------------------------------------------

    @Test
    fun `moveCamera animates the camera with provided coordinates and zoom when map is attached`() {
        val viewId = 123L
        val latitude = 37.4219
        val longitude = -122.0841
        val zoom = 15.0

        val latLngSlot = slot<LatLng>()
        val zoomSlot = slot<Float>()
        mockkStatic(CameraUpdateFactory::class)
        every {
            CameraUpdateFactory.newLatLngZoom(capture(latLngSlot), capture(zoomSlot))
        } returns cameraUpdate

        // Attach the map first so withMap executes the operation immediately.
        mapRegistry.attachMap(viewId, mockGoogleMap)
        hostApi.moveCamera(viewId, latitude, longitude, zoom)

        // Verify the camera update was built with the exact coordinates and zoom.
        verify(exactly = 1) { CameraUpdateFactory.newLatLngZoom(any(), any()) }
        assertEquals(latitude, latLngSlot.captured.latitude, 0.0)
        assertEquals(longitude, latLngSlot.captured.longitude, 0.0)
        assertEquals(zoom.toFloat(), zoomSlot.captured, 0.0f)

        // Verify the map actually received the camera update.
        verify(exactly = 1) { mockGoogleMap.animateCamera(cameraUpdate) }
    }

    @Test
    fun `moveCamera does not animate the camera until the map is attached`() {
        val viewId = 123L

        mockkStatic(CameraUpdateFactory::class)
        every { CameraUpdateFactory.newLatLngZoom(any(), any()) } returns cameraUpdate

        // Call before attaching the map -> operation must be queued, not executed.
        hostApi.moveCamera(viewId, 1.0, 2.0, 10.0)
        verify(exactly = 0) { mockGoogleMap.animateCamera(any()) }

        // Now attach the map -> queued operation should run.
        mapRegistry.attachMap(viewId, mockGoogleMap)
        verify(exactly = 1) { mockGoogleMap.animateCamera(cameraUpdate) }
    }

    @Test
    fun `moveCamera executes only for the correct viewId`() {
        val attachedViewId = 123L
        val detachedViewId = 456L

        mockkStatic(CameraUpdateFactory::class)
        every { CameraUpdateFactory.newLatLngZoom(any(), any()) } returns cameraUpdate

        // Only attach one view's map.
        mapRegistry.attachMap(attachedViewId, mockGoogleMap)

        // moveCamera for the detached view must be queued (not executed).
        hostApi.moveCamera(detachedViewId, 1.0, 2.0, 10.0)
        verify(exactly = 0) { mockGoogleMap.animateCamera(any()) }

        // moveCamera for the attached view must execute immediately.
        hostApi.moveCamera(attachedViewId, 3.0, 4.0, 12.0)
        verify(exactly = 1) { mockGoogleMap.animateCamera(cameraUpdate) }

        // Attaching the second view later should flush its queued operation.
        mapRegistry.attachMap(detachedViewId, mockGoogleMap)
        verify(exactly = 2) { mockGoogleMap.animateCamera(cameraUpdate) }
    }

    @Test
    fun `initializeMap executes without error when map is attached`() {
        val viewId = 123L

        mapRegistry.attachMap(viewId, mockGoogleMap)

        // The no-op operation captured by initializeMap must run against the attached map
        // without throwing.
        hostApi.initializeMap(viewId)

        // No camera operations are expected from initializeMap itself.
        verify(exactly = 0) { mockGoogleMap.animateCamera(any()) }
    }

    @Test
    fun `initializeMap does not throw and queues operation when map is not yet attached`() {
        val viewId = 123L

        // Should queue the no-op without throwing; attaching later flushes it.
        hostApi.initializeMap(viewId)

        mapRegistry.attachMap(viewId, mockGoogleMap)

        // Still no camera operations expected from initializeMap.
        verify(exactly = 0) { mockGoogleMap.animateCamera(any()) }
    }
}
