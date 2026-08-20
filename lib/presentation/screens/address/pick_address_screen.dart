import 'dart:async';
import 'package:e_commerce_client/service_locator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/sources/remote/map_remote_data.dart';
import '../../../domain/entity/address/address_entity.dart';
import '../../blocs/address/address_bloc.dart';

class AddressPickerPage extends StatefulWidget {
  final AddressEntity? initialAddress;
  final String? title;

  const AddressPickerPage({super.key, this.initialAddress, this.title});

  @override
  State<AddressPickerPage> createState() => _AddressPickerPageState();
}

class _AddressPickerPageState extends State<AddressPickerPage> {
  StreamSubscription<MapCoordinateUpdate>? _coordinateSub;
  int? _activeViewId;

  @override
  void initState() {
    super.initState();
    _coordinateSub = sl<MapRemoteData>().coordinateUpdates.listen((update) {
      if (_activeViewId == null || _activeViewId != update.viewId) return;

      context.read<AddressPickerBloc>().add(
        MapCoordinateUpdated(
          latitude: update.latitude,
          longitude: update.longitude,
        ),
      );
    });
  }

  @override
  void dispose() {
    _coordinateSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddressPickerBloc, AddressState>(
      builder: (context, addressState) {
        final selectedAddress = addressState.selectedAddress;

        return Scaffold(
          appBar: AppBar(
            title: Text(widget.title ?? 'Select Delivery Address'),
            actions: [
              IconButton(
                icon: const Icon(Icons.my_location),
                onPressed: () {
                  final bloc = context.read<AddressPickerBloc>();
                  final currentViewId = addressState.mapViewId;
                  if (currentViewId != null) {
                    bloc.add(
                      MapViewCreated(
                        mapViewId: currentViewId,
                        initialAddress: addressState.selectedAddress,
                      ),
                    );
                  }
                },
                tooltip: 'Use my current location',
              ),
            ],
          ),
          body: Stack(
            children: [
              Positioned.fill(
                child: _MapSurface(
                  onMapCreated: (viewId) {
                    _activeViewId = viewId;
                    context.read<AddressPickerBloc>().add(
                      MapViewCreated(
                        mapViewId: viewId,
                        initialAddress: widget.initialAddress,
                      ),
                    );
                  },
                ),
              ),

              const IgnorePointer(
                child: Center(
                  child: Icon(Icons.location_pin, size: 46, color: Colors.red),
                ),
              ),

              if (addressState.status == MapStatus.loading &&
                  selectedAddress == null)
                const Center(child: CircularProgressIndicator()),

              Align(
                alignment: Alignment.bottomCenter,
                child: SafeArea(
                  minimum: const EdgeInsets.all(16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Theme.of(context).primaryColor,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Delivery Address',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        if (selectedAddress == null)
                          const Text(
                            'Move the map to select a location',
                            style: TextStyle(color: Colors.grey),
                          )
                        else
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                selectedAddress.formattedAddress,
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Lat: ${selectedAddress.latitude.toStringAsFixed(6)}, '
                                'Lng: ${selectedAddress.longitude.toStringAsFixed(6)}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),

                        if (addressState.isResolvingAddress) ...[
                          const SizedBox(height: 10),
                          const LinearProgressIndicator(minHeight: 3),
                        ],

                        if (addressState.errorMessage != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            addressState.errorMessage!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                              fontSize: 12,
                            ),
                          ),
                        ],
                        const SizedBox(height: 12),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: selectedAddress == null
                                ? null
                                : () {
                                    Navigator.of(context).pop();
                                  },
                            icon: const Icon(Icons.check_circle),
                            label: const Text('Confirm Address'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MapSurface extends StatelessWidget {
  final ValueChanged<int> onMapCreated;

  const _MapSurface({required this.onMapCreated});

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform != TargetPlatform.android) {
      return const Center(
        child: Text('Native Google Maps is supported on Android only.'),
      );
    }

    return AndroidView(
      viewType: 'com.example.e_commerce_client/address_picker_map_view',
      onPlatformViewCreated: onMapCreated,
    );
  }
}
