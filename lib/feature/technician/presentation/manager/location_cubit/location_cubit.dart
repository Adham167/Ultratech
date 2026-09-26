import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../domain/repositories/technician_repository.dart';
import 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  final TechnicianRepository technicianRepository;

  LocationCubit({
    required this.technicianRepository,
  }) : super(LocationInitial());

  Future<void> updateOrderLocation(int orderId) async {
    emit(LocationLoading());
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(const LocationFailure('خدمات الموقع (GPS) مغلقة. يرجى تفعيل الـ GPS للمتابعة.'));
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(const LocationFailure('يحتاج التطبيق إلى صلاحية الوصول للموقع لتحديد عنوان العميل.'));
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        emit(const LocationPermissionDeniedForever(
          'تم رفض صلاحية الوصول للموقع بشكل دائم. يرجى فتح الإعدادات لتفعيلها يدويياً.',
        ));
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final result = await technicianRepository.updateOrderLocation(
        orderId,
        position.latitude,
        position.longitude,
      );

      result.fold(
        (failure) => emit(LocationFailure(failure.errMessage)),
        (msg) => emit(LocationSuccess(
          (msg.isNotEmpty && !msg.contains('{') && !msg.contains('Exception'))
              ? msg
              : 'تم تحديث موقع العميل بنجاح',
        )),
      );
    } catch (e) {
      emit(const LocationFailure('حدث خطأ أثناء تحديث الموقع، يرجى المحاولة لاحقاً.'));
    }
  }

  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }

  Future<void> openGoogleMaps(String? mapsUrl, double? lat, double? lng) async {
    final String urlString = (mapsUrl != null && mapsUrl.isNotEmpty)
        ? mapsUrl
        : 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';

    final Uri url = Uri.parse(urlString);

    try {
      bool launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
      
      if (!launched) {
        // Fallback in case external application mode fails
        await launchUrl(url, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      emit(LocationFailure('تعذر فتح تطبيق الخرائط: ${e.toString()}'));
    }
  }
}
