import 'package:equatable/equatable.dart';
import '../../domain/entities/agent_entity.dart';

abstract class SalesDashboardState extends Equatable {
  const SalesDashboardState();

  @override
  List<Object?> get props => [];
}

class SalesDashboardInitial extends SalesDashboardState {}

class SalesDashboardLoading extends SalesDashboardState {}

class SalesDashboardSuccess extends SalesDashboardState {
  final AgentEntity agent;
  const SalesDashboardSuccess(this.agent);

  @override
  List<Object?> get props => [agent];
}

class SalesDashboardFailure extends SalesDashboardState {
  final String errMessage;
  const SalesDashboardFailure(this.errMessage);

  @override
  List<Object?> get props => [errMessage];
}
