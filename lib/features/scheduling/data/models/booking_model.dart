import 'package:ers_linux/features/scheduling/data/models/sections.dart';

class BookingModel {
  final List<SectionModel> sections;

  BookingModel({required this.sections});

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      sections: (json['sections'] as List<dynamic>)
          .map((e) => SectionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  String toString() {
    return 'BookingModel(sections: ${sections.length} sections)';
  }
}
