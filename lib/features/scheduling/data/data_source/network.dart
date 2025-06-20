import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import '../models/booking_model.dart';

// Remote Data Source

abstract class BookingFormRemoteSource {
  Future<BookingModel> fetchBookingDetails(String token);
}

@LazySingleton(as: BookingFormRemoteSource)
class BookingFormRemoteSourceImpl extends BookingFormRemoteSource {
  final http.Client client;

  BookingFormRemoteSourceImpl({required this.client});

  @override
  Future<BookingModel> fetchBookingDetails(String token) async {
    final uri = Uri.parse(
      'https://test.eresourcescheduler.cloud/rest/booking/profile?visibility=ADD',
      // 'https://varun-pc.eresourcescheduler.cloud:8443/rest/booking/profile?visibility=',
    );

    final response = await client.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    log('🔁 [BookingRemote] fetchProfile response: ${response.statusCode}');
    log('Response body length: ${response.body.length}');

    if (response.statusCode == 200) {
      try {
        final jsonMap = json.decode(response.body) as Map<String, dynamic>;
        log('✅ JSON decoded successfully');
        // print(jsonMap);
        return BookingModel.fromJson(jsonMap);
      } catch (e, stackTrace) {
        log('❌ Error parsing JSON: $e');
        log('Stack trace: $stackTrace');
        log('Raw response: ${response.body}');
        throw Exception('Failed to parse booking profile response: $e');
      }
    } else {
      log('❌ HTTP Error: ${response.statusCode} - ${response.reasonPhrase}');
      log('Error body: ${response.body}');
      throw Exception(
        'Failed to fetch booking profile: ${response.statusCode} ${response.reasonPhrase}',
      );
    }
  }
}

// void main() async {
//   final client = http.Client();
//   final remoteSource = BookingFormRemoteSourceImpl(client: client);
//   final sectionFetcher = SectionFetcher(remoteSource: remoteSource);
//   final udfExtractor = UdfExtractor();
//
//   const token = 'p0gqjthl00p11djt4btzpyqp2yvi4w';
//
//   // Fetch all sections
//   final sections = await sectionFetcher.fetchSections(token);
//   print('Got ${await sectionFetcher.sectionCount(token)} sections:');
//   print(await sectionFetcher.sectionTitles(token));
//
//   // For each section, extract UDFs and render them
//   for (final section in sections) {
//     print('Section: ${section.title} (id=${section.id})');
//     final udfs = udfExtractor.extractUdfs(section);
//     for (final udf in udfs) {
//       print(
//         '  • ${udf.displayName} udf id=${udf.id} '
//         '[type=${udf.fieldType}, order=${udf.order}, '
//         'required=${udf.isRequired}, code=${udf.code}, options = ${udf.udfOptionsModel} , regex = ${udf.regex}, length = ${udf.maxLength}    ${udf.minLength}',
//       );
//     }
//   }
//   client.close();
// }
