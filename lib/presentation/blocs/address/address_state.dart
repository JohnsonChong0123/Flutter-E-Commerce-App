part of 'address_bloc.dart';

enum MapStatus { initial, loading, loaded, error }

class AddressState extends Equatable {
  final MapStatus status;
  final AddressEntity? selectedAddress;
  final int? mapViewId;
  final bool isResolvingAddress;
  final String? errorMessage;

  const AddressState({
    this.status = MapStatus.initial,
    this.selectedAddress,
    this.mapViewId,
    this.isResolvingAddress = false,
    this.errorMessage,
  });

  AddressState copyWith({
    MapStatus? status,
    AddressEntity? selectedAddress,
    int? mapViewId,
    bool? isResolvingAddress,
    String? errorMessage,
    bool clearError = false,
    bool clearSelectedAddress = false,
  }) {
    return AddressState(
      status: status ?? this.status,
      selectedAddress: clearSelectedAddress ? null : (selectedAddress ?? this.selectedAddress),
      mapViewId: mapViewId ?? this.mapViewId,
      isResolvingAddress: isResolvingAddress ?? this.isResolvingAddress,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    selectedAddress,
    mapViewId,
    isResolvingAddress,
    errorMessage,
  ];
}

