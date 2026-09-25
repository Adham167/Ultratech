import 'package:equatable/equatable.dart';
import '../../../../Auth/data/models/response/user_profile_model.dart';
import '../../../data/models/earnings_model.dart';

abstract class TechnicianEarningsState extends Equatable {
  const TechnicianEarningsState();

  @override
  List<Object?> get props => [];
}

class TechnicianEarningsInitial extends TechnicianEarningsState {}

class TechnicianEarningsLoading extends TechnicianEarningsState {}

class TechnicianEarningsSuccess extends TechnicianEarningsState {
  final EarningsModel earnings;
  final UserProfileModel? profile;

  const TechnicianEarningsSuccess(this.earnings, {this.profile});

  @override
  List<Object?> get props => [earnings, profile];
}

class TechnicianEarningsFailure extends TechnicianEarningsState {
  final String errMessage;

  const TechnicianEarningsFailure(this.errMessage);

  @override
  List<Object?> get props => [errMessage];
}
