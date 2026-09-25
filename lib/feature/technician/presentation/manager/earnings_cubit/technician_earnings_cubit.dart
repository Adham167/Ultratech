import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Auth/data/models/response/user_profile_model.dart';
import '../../../../Auth/domain/usecases/get_user_profile_usecase.dart';
import '../../../domain/usecases/get_my_earnings_usecase.dart';
import 'technician_earnings_state.dart';

class TechnicianEarningsCubit extends Cubit<TechnicianEarningsState> {
  final GetMyEarningsUseCase getMyEarningsUseCase;
  final GetUserProfileUseCase? getUserProfileUseCase;

  TechnicianEarningsCubit({
    required this.getMyEarningsUseCase,
    this.getUserProfileUseCase,
  }) : super(TechnicianEarningsInitial());

  Future<void> getMyEarnings() async {
    emit(TechnicianEarningsLoading());

    UserProfileModel? profile;
    if (getUserProfileUseCase != null) {
      final profileResult = await getUserProfileUseCase!();
      profileResult.fold((_) => null, (p) => profile = p);
    }

    final result = await getMyEarningsUseCase();

    result.fold(
      (failure) {
        emit(
          TechnicianEarningsFailure(
            failure.errMessage,
          ),
        );
      },
      (earnings) {
        emit(
          TechnicianEarningsSuccess(
            earnings,
            profile: profile,
          ),
        );
      },
    );
  }
}
