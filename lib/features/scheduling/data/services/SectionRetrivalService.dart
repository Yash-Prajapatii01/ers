import 'package:ers_linux/features/scheduling/data/models/sections.dart';
import '../data_source/network.dart';
import '../models/udfModel.dart';

/// 1️⃣ SectionFetcher
/// Retrieves the full list of SectionModel from the BookingForm API.
class SectionFetcher {
  final BookingFormRemoteSource _remoteSource;

  SectionFetcher({required BookingFormRemoteSource remoteSource})
      : _remoteSource = remoteSource;

  /// Returns all sections
  Future<List<SectionModel>> fetchSections(String token) async {
    final booking = await _remoteSource.fetchBookingDetails(token);
    return booking.sections;
  }
}
