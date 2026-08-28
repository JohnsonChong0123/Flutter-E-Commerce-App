import 'dart:async';
import 'package:e_commerce_client/service_locator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions/theme_extensions.dart';
import '../../../core/routes/app_router.dart';
import '../../../data/models/map/map_coord_update.dart';
import '../../../data/sources/remote/map_remote_data.dart';
import '../../../domain/entity/address/address_entity.dart';
import '../../blocs/address/address_bloc.dart';
import '../../cubits/user/user_cubit.dart';

class AddressPickerPage extends StatefulWidget {
  // final AddressEntity? initialAddress;
  final String? title;

  const AddressPickerPage({
    super.key,
    // this.initialAddress,
    this.title,
  });

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

      if (!mounted) return;
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
      builder: (context, state) {
        return Scaffold(
          appBar: _buildAppBar(state),
          body: _buildBody(state, context),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(AddressState state) {
    return AppBar(
      title: Text(widget.title ?? 'Select Delivery Address'),
      actions: [
        IconButton(
          icon: const Icon(Icons.my_location),
          onPressed: () {
            final bloc = context.read<AddressPickerBloc>();
            final viewId = _getMapViewId(state);
            if (viewId != null) {
              bloc.add(
                MapViewCreated(
                  mapViewId: viewId,
                  initialAddress: _getCurrentAddress(state),
                ),
              );
            }
          },
          tooltip: 'Use my current location',
        ),
      ],
    );
  }

  Widget _buildBody(AddressState state, BuildContext context) {
    return Stack(
      children: [
        // Map Surface
        Positioned.fill(
          child: _MapSurface(
            onMapCreated: (viewId) {
              _activeViewId = viewId;
              context.read<AddressPickerBloc>().add(
                MapViewCreated(mapViewId: viewId, initialAddress: null),
              );
            },
          ),
        ),

        // Center Pin
        const IgnorePointer(
          child: Center(
            child: Icon(Icons.location_pin, size: 46, color: Colors.red),
          ),
        ),

        // Loading Overlay
        if (state is AddressLoading) _buildLoadingOverlay(),

        // Bottom Sheet
        Align(
          alignment: Alignment.bottomCenter,
          child: SafeArea(
            minimum: const EdgeInsets.all(16),
            child: _buildBottomSheet(state, context),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withValues(alpha: 0.3),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildBottomSheet(AddressState state, BuildContext context) {
    return Container(
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
          _buildHeader(),
          const SizedBox(height: 12),
          _buildAddressContent(state, context),
          _buildStatusIndicators(state),
          const SizedBox(height: 12),
          _buildConfirmButton(state),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
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
    );
  }

  Widget _buildAddressContent(AddressState state, BuildContext context) {
    return switch (state) {
      AddressInitial() => const Text(
        'Move the map to select a location',
        style: TextStyle(color: Colors.grey),
      ),
      AddressLoading() => const Text(
        'Loading address...',
        style: TextStyle(color: Colors.grey),
      ),
      AddressLoaded() => _buildAddressDetails(state.selectedAddress),
      AddressResolving() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAddressDetails(state.selectedAddress),
          const SizedBox(height: 8),
          Text(
            'Resolving address...',
            style: TextStyle(
              color: context.theme.primaryColor,
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
      AddressError() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (state.lastKnownAddress != null)
            _buildAddressDetails(state.lastKnownAddress!)
          else
            const Text(
              'Unable to load address',
              style: TextStyle(color: Colors.grey),
            ),
          const SizedBox(height: 8),
          _buildErrorWidget(state.message),
        ],
      ),
    };
  }

  Widget _buildAddressDetails(AddressEntity address) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(address.formattedAddress, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 4),
        Text(
          'Lat: ${address.latitude.toStringAsFixed(6)}, '
          'Lng: ${address.longitude.toStringAsFixed(6)}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildErrorWidget(String message) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Theme.of(context).colorScheme.error,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicators(AddressState state) {
    if (state is AddressResolving) {
      return const Padding(
        padding: EdgeInsets.only(top: 10),
        child: LinearProgressIndicator(minHeight: 3),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildConfirmButton(AddressState state) {
    final canConfirm = switch (state) {
      AddressLoaded() => true,
      AddressResolving() => true,
      _ => false,
    };

    final addressToReturn = switch (state) {
      AddressLoaded() => state.selectedAddress,
      AddressResolving() => state.selectedAddress,
      _ => null,
    };

    return BlocConsumer<UserCubit, UserState>(
      listener: (context, userState) {
        if (userState is UserSuccess) {
          context.pushNamed(AppRouter.checkoutName);
        }
      },
      builder: (context, userState) {
        final isUpdating = userState is UserLoading;

        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: canConfirm && addressToReturn != null && !isUpdating
                ? () {
                    context.read<UserCubit>().updateUserAddress(
                      addressToReturn.formattedAddress,
                      addressToReturn.latitude,
                      addressToReturn.longitude,
                    );
                  }
                : null,
            icon: const Icon(Icons.check_circle),
            label: switch ((state, userState)) {
              (AddressLoading(), _) => const Text('Loading...'),
              (AddressError(), _) => const Text('Address Retry'),
              (_, UserLoading()) => const Text('Saving...'),
              (_, UserFailure()) => const Text('User Retry'),
              _ => const Text('Confirm Address'),
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        );
      },
    );
  }

  // Helper methods to extract data from state
  int? _getMapViewId(AddressState state) {
    return switch (state) {
      AddressLoaded() => state.mapViewId,
      AddressResolving() => state.mapViewId,
      AddressLoading() => state.mapViewId,
      AddressError() => state.mapViewId,
      _ => null,
    };
  }

  AddressEntity? _getCurrentAddress(AddressState state) {
    return switch (state) {
      AddressLoaded() => state.selectedAddress,
      AddressResolving() => state.selectedAddress,
      AddressError() => state.lastKnownAddress,
      _ => null,
    };
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
