package com.example.e_commerce_client

import com.example.app.generated.GoogleMapFlutterApi
import com.example.app.generated.GoogleMapHostApi
import com.example.e_commerce_client.addresspicker.AddressPickerGoogleMapHostApi
import com.example.e_commerce_client.addresspicker.AddressPickerMapRegistry
import com.example.e_commerce_client.addresspicker.AddressPickerMapViewFactory
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
	override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
		super.configureFlutterEngine(flutterEngine)

		val mapRegistry = AddressPickerMapRegistry()
		val flutterApi = GoogleMapFlutterApi(flutterEngine.dartExecutor.binaryMessenger)
		flutterEngine
			.platformViewsController
			.registry
			.registerViewFactory(
				AddressPickerMapViewFactory.VIEW_TYPE,
				AddressPickerMapViewFactory(this, mapRegistry, flutterApi),
			)

		GoogleMapHostApi.setUp(
			flutterEngine.dartExecutor.binaryMessenger,
			AddressPickerGoogleMapHostApi(mapRegistry),
		)
	}
}
