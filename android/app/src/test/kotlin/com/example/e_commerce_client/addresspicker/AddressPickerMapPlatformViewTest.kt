package com.example.e_commerce_client.addresspicker

import android.content.Context
import android.view.View
import com.example.app.generated.GoogleMapFlutterApi
import com.google.android.gms.maps.GoogleMap
import com.google.android.gms.maps.MapView
import com.google.android.gms.maps.UiSettings
import com.google.android.gms.maps.model.CameraPosition
import com.google.android.gms.maps.model.LatLng
import com.google.android.gms.maps.model.Marker
import io.mockk.*
import org.junit.After
import org.junit.Assert.*
import org.junit.Before
import org.junit.Test

class AddressPickerMapPlatformViewTest {

    private lateinit var context: Context
    private lateinit var mockMapView: MapView
    private lateinit var mockGoogleMap: GoogleMap
    private lateinit var mockUiSettings: UiSettings
    private lateinit var mapRegistry: AddressPickerMapRegistry
    private lateinit var flutterApi: GoogleMapFlutterApi
    private lateinit var platformView: AddressPickerMapPlatformView

    private val viewId = 42L

    // Slots to capture the listeners installed by the platform view.
    private val cameraIdleSlot = slot<GoogleMap.OnCameraIdleListener>()
    private val markerDragListenerSlot = slot<GoogleMap.OnMarkerDragListener>()
    private val capturedFlutterLat = slot<Double>()
    private val capturedFlutterLng = slot<Double>()

    @Before
    fun setUp() {
        context = mockk(relaxed = true)
        mockMapView = mockk(relaxed = true)
        mockGoogleMap = mockk(relaxed = true)
        mockUiSettings = mockk(relaxed = true)
        mapRegistry = AddressPickerMapRegistry()
        flutterApi = mockk(relaxed = true)

        // Stub the map's uiSettings so onMapReady can configure it.
        every { mockGoogleMap.uiSettings } returns mockUiSettings

        // Capture the camera-idle runnable installed on the map.
        every {
            mockGoogleMap.setOnCameraIdleListener(capture(cameraIdleSlot))
        } just Runs

        // Capture the marker drag listener installed on the map.
        every {
            mockGoogleMap.setOnMarkerDragListener(capture(markerDragListenerSlot))
        } just Runs

        // Capture the coordinates forwarded to the Flutter API.
        every {
            flutterApi.onCameraIdle(eq(viewId), capture(capturedFlutterLat), capture(capturedFlutterLng), any())
        } just Runs
        every {
            flutterApi.onMarkerDragEnd(eq(viewId), capture(capturedFlutterLat), capture(capturedFlutterLng), any())
        } just Runs

        platformView = AddressPickerMapPlatformView(
            context = context,
            viewId = viewId,
            mapRegistry = mapRegistry,
            flutterApi = flutterApi,
            mapView = mockMapView,
        )
    }

    @After
    fun tearDown() {
        unmockkAll()
    }

    // ---------------------------------------------------------------------------------------------
    // Construction + lifecycle
    // ---------------------------------------------------------------------------------------------

    @Test
    fun `construction initialises MapView lifecycle and requests an async map`() {
        // init block must call onCreate then getMapAsync with itself as the callback.
        verify(exactly = 1) { mockMapView.onCreate(null) }
        verify(exactly = 1) { mockMapView.getMapAsync(any<com.google.android.gms.maps.OnMapReadyCallback>()) }
    }

    @Test
    fun `getView returns the underlying MapView`() {
        val returned: View = platformView.getView()
        assertSame(mockMapView, returned)
    }

    // ---------------------------------------------------------------------------------------------
    // onMapReady behaviour
    // ---------------------------------------------------------------------------------------------

    @Test
    fun `onMapReady configures uiSettings as expected`() {
        platformView.onMapReady(mockGoogleMap)

        verify(exactly = 1) { mockUiSettings.isCompassEnabled = true }
        verify(exactly = 1) { mockUiSettings.isMapToolbarEnabled = false }
        verify(exactly = 1) { mockUiSettings.isZoomControlsEnabled = true }
    }

    @Test
    fun `onMapReady registers camera idle and marker drag listeners`() {
        platformView.onMapReady(mockGoogleMap)

        assertTrue(cameraIdleSlot.isCaptured)
        assertTrue(markerDragListenerSlot.isCaptured)
    }

    @Test
    fun `onMapReady attaches the map to the registry and resumes the MapView`() {
        platformView.onMapReady(mockGoogleMap)

        // The map should now be resolvable from the registry.
        var resolved: GoogleMap? = null
        mapRegistry.withMap(viewId) { resolved = it }
        assertSame(mockGoogleMap, resolved)

        verify(exactly = 1) { mockMapView.onResume() }
    }

    // ---------------------------------------------------------------------------------------------
    // Camera idle -> Flutter API forwarding
    // ---------------------------------------------------------------------------------------------

    @Test
    fun `camera idle listener forwards viewId and target coordinates to flutterApi`() {
        val target = LatLng(12.34, 56.78)
        every { mockGoogleMap.cameraPosition } returns CameraPosition(target, 10f, 0f, 0f)

        platformView.onMapReady(mockGoogleMap)

        // Trigger the captured camera-idle callback.
        cameraIdleSlot.captured.onCameraIdle()

        verify(exactly = 1) {
            flutterApi.onCameraIdle(eq(viewId), eq(12.34), eq(56.78), any())
        }
        assertEquals(12.34, capturedFlutterLat.captured, 0.0)
        assertEquals(56.78, capturedFlutterLng.captured, 0.0)
    }

    // ---------------------------------------------------------------------------------------------
    // Marker drag -> Flutter API forwarding
    // ---------------------------------------------------------------------------------------------

    @Test
    fun `marker drag end listener forwards viewId and marker position to flutterApi`() {
        val marker: Marker = mockk(relaxed = true)
        val position = LatLng(-1.23, 4.56)
        every { marker.position } returns position

        platformView.onMapReady(mockGoogleMap)

        // Trigger the captured drag-end callback.
        markerDragListenerSlot.captured.onMarkerDragEnd(marker)

        verify(exactly = 1) {
            flutterApi.onMarkerDragEnd(eq(viewId), eq(-1.23), eq(4.56), any())
        }
        assertEquals(-1.23, capturedFlutterLat.captured, 0.0)
        assertEquals(4.56, capturedFlutterLng.captured, 0.0)
    }

    @Test
    fun `marker drag start and drag do not forward anything to flutterApi`() {
        val marker: Marker = mockk(relaxed = true)

        platformView.onMapReady(mockGoogleMap)

        // The platform view overrides these as no-ops.
        markerDragListenerSlot.captured.onMarkerDragStart(marker)
        markerDragListenerSlot.captured.onMarkerDrag(marker)

        verify(exactly = 0) { flutterApi.onCameraIdle(any(), any(), any(), any()) }
        verify(exactly = 0) { flutterApi.onMarkerDragEnd(any(), any(), any(), any()) }
    }

    // ---------------------------------------------------------------------------------------------
    // dispose behaviour
    // ---------------------------------------------------------------------------------------------

    @Test
    fun `dispose detaches the map from the registry and tears down the MapView`() {
        platformView.onMapReady(mockGoogleMap)

        platformView.dispose()

        // After dispose the map should no longer be attached; withMap must queue (not run)
        // the operation, so the captured lambda should never execute.
        var ran = false
        mapRegistry.withMap(viewId) { ran = true }
        assertFalse("operation should not run after the map is detached", ran)

        verify(exactly = 1) { mockMapView.onPause() }
        verify(exactly = 1) { mockMapView.onDestroy() }
    }
}
