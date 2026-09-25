import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../../technician/domain/repositories/technician_repository.dart';
import '../../data/models/response/user_profile_model.dart';

class GetUserProfileUseCase {
  final TechnicianRepository repository;

  GetUserProfileUseCase(this.repository);

  Future<Either<Failure, UserProfileModel>> call() async {
    return await repository.getUserProfile();
  }
}
