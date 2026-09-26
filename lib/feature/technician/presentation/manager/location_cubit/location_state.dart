import 'package:equatable/equatable.dart';

abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object?> get props => [];
}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationSuccess extends LocationState {
  final String message;

  const LocationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class LocationFailure extends LocationState {
  final String errMessage;

  const LocationFailure(this.errMessage);

  @override
  List<Object?> get props => [errMessage];
}

class LocationPermissionDeniedForever extends LocationState {
  final String errMessage;

  const LocationPermissionDeniedForever(this.errMessage);

  @override
  List<Object?> get props => [errMessage];
}
