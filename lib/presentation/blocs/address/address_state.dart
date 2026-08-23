part of 'address_bloc.dart';

sealed class AddressState extends Equatable {
  const AddressState();

  @override
  List<Object?> get props => [];
}

final class AddressInitial extends AddressState {
  const AddressInitial();
}


final class AddressLoading extends AddressState {
  final int mapViewId;
  final bool isResolvingAddress;

  const AddressLoading({
    required this.mapViewId,
    this.isResolvingAddress = true,
  });

  @override
  List<Object> get props => [mapViewId, isResolvingAddress];
}

final class AddressLoaded extends AddressState {
  final AddressEntity selectedAddress;
  final int mapViewId;
  final bool isResolvingAddress;

  const AddressLoaded({
    required this.selectedAddress,
    required this.mapViewId,
    this.isResolvingAddress = false,
  });

  @override
  List<Object> get props => [selectedAddress, mapViewId, isResolvingAddress];
}

final class AddressResolving extends AddressState {
  final AddressEntity selectedAddress;
  final int mapViewId;

  const AddressResolving({
    required this.selectedAddress,
    required this.mapViewId,
  });

  @override
  List<Object> get props => [selectedAddress, mapViewId];
}

final class AddressError extends AddressState {
  final String message;
  final int? mapViewId;
  final AddressEntity? lastKnownAddress;

  const AddressError({
    required this.message,
    this.mapViewId,
    this.lastKnownAddress,
  });

  @override
  List<Object?> get props => [message, mapViewId, lastKnownAddress];
}