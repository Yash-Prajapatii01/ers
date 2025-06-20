import 'dart:convert';
import 'package:ers_linux/features/scheduling/data/models/sections.dart';
import 'package:ers_linux/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/udfModel.dart';
import '../utils/BookingFormBloc/booking_form_bloc.dart';
import '../widgets/UdfTileBuider.dart';

enum FieldValueType {
  string,
  integer,
  doubleType,
  boolean,
  stringList,
  intList,
  datetime,
  unknown,
}

class BookingForm extends StatefulWidget {
  static const routePath = '/booking_form';

  const BookingForm({super.key});

  @override
  State<BookingForm> createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _fractionController = TextEditingController();

  // static const String _token = 'mco8u0yj7cahfojh6ey909ep4ajvu5';

  static const String _token = 'p0gqjthl00p11djt4btzpyqp2yvi4w';

  final Map<String, FieldValueType> _fieldTypeRegistry = {};
  final Map<String, dynamic> _formData = {};

  void _onUdfChanged(String code, dynamic value) {
    setState(() {
      _formData[code] = value;
    });
  }

  void _onSavePressed() {
    print('On save Pressed....');
    print(_formData);
  }

  void _registerFieldExpectation(String code, String fieldType) {
    switch (fieldType) {
      case 'TEXT':
      case 'MLTEXT':
      case 'EMAIL':
      case 'URL':
      case 'COLPICK':
        _fieldTypeRegistry[code] = FieldValueType.string;
        break;
      case 'INT':
      case 'EFFORT':
      case 'REQSS':
        _fieldTypeRegistry[code] = FieldValueType.integer;
        break;
      case 'FLOAT':
        _fieldTypeRegistry[code] = FieldValueType.doubleType;
        break;
      case 'CHK':
        _fieldTypeRegistry[code] = FieldValueType.boolean;
        break;
      case 'TAGS':
        _fieldTypeRegistry[code] = FieldValueType.stringList;
        break;
      case 'DDMS':
      case 'CHGRP':
      case 'UMS':
        _fieldTypeRegistry[code] = FieldValueType.intList;
        break;
      case 'DATE':
      case 'DATIM':
        _fieldTypeRegistry[code] = FieldValueType.datetime;
        break;
      case 'DDSS':
      case 'RDGRP':
      case 'USS':
      case 'LABL':
        _fieldTypeRegistry[code] = FieldValueType.string;
        break;
      default:
        _fieldTypeRegistry[code] = FieldValueType.unknown;
    }
  }


  void _initializeFormData(List<SectionModel> sections) {
    print("Form Data initialization start");
    for (var section in sections) {
      for (var udf in section.udfs) {
        _registerFieldExpectation(udf.code, udf.fieldType);
        switch (udf.fieldType) {
          case 'DDMS':
          case 'CHGRP':
          case 'UMS':
            _formData[udf.code] = <int>[];
            break;
          case 'TEXT':
          case 'MLTEXT':
          case 'EMAIL':
          case 'URL':
          case 'COLPICK':
            _formData[udf.code] = '';
            break;
          case 'INT':
          case 'FLOAT':
          case 'EFFORT':
          case 'REQSS':
            _formData[udf.code] = 0;
            break;
          case 'CHK':
            _formData[udf.code] = false;
            break;
          case 'DATE':
          case 'DATIM':
            _formData[udf.code] = null;
            break;
          case 'DDSS':
          case 'RDGRP':
          case 'USS':
          case 'LABL':

            _formData[udf.code] = 0;
            break;
          case 'TAGS':
            _formData[udf.code] = <String>[];
          default:
            _formData[udf.code] = null;
        }

        // Then override with selected values if they exist
        if (udf.udfOptionsList.isNotEmpty) {
          final selected =
              udf.udfOptionsList.where((v) => v.isSelected == true).toList();
          print(selected);
          if (selected.isNotEmpty) {
            if (selected.length > 1) {
              _formData[udf.code] = selected.map((item) => item.id).toList();
            } else {
              _formData[udf.code] = selected.first.id;
            }
          }
        }
      }
    }
    print("Form Data filled up: $_formData");
  }

  @override
  void dispose() {
    _emailController;
    _numberController;
    _fractionController;
    super.dispose();
  }

  @override
  void initState() {
    context.read<BookingFormBloc>().add(LoadBookingFormEvent(token: _token));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(245, 250, 255, 1),
        leadingWidth: MediaQuery.of(context).size.width,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 17.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        width: 30,
                        height: 30,
                        alignment: Alignment.centerLeft,
                        child: Icon(Icons.chevron_left_rounded, size: 30),
                        // Replace Icon with your SVG later:
                        // child: SvgPicture.asset('assets/icons/chevron_left'),
                      ),
                    ),
                    SizedBox(width: 4), // Adjust for visual spacing with text
                    Text(
                      'Booking',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: AppColors.darkBlack,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 20.0, bottom: 12),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromRGBO(16, 24, 40, 0.05),
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton(
                    onPressed: _onSavePressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(28, 121, 212, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          8,
                        ), // Rounded corners
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                    ),
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        // fontFamily: 'Inter'
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: BlocBuilder<BookingFormBloc, BookingFormState>(
        builder: (context, state) {
          if (state is BookingFormLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BookingFormErrorState) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is BookingFormLoadedState) {
            final sections = state.sections;
            if (_formData.isEmpty) {
              _initializeFormData(sections);
            }
            return ListView.builder(
              itemCount: sections.length,
              itemBuilder: (context, idx) {
                final section = sections[idx];
                final grouped = groupedUdfs(section.udfs);
                final displayUdfs = grouped.udfs;
                final originalFieldTypes = grouped.originalFieldTypes;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        section.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    ListView.builder(
                      itemCount: displayUdfs.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final udf = displayUdfs[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 4.0,
                          ),
                          child: UdfTileBuilder(
                            udf: udf,
                            onValueChanged: _onUdfChanged,
                            originalFieldTypes: originalFieldTypes,
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            );
          }
          return const SizedBox(); // Fallback
        },
      ),
    );
  }
}

class GroupedUdfResult {
  final List<UdfModel> udfs;
  final Map<String, List<UdfModel>>
  originalFieldTypes; // New field to track original types

  GroupedUdfResult({required this.udfs, required this.originalFieldTypes});
}

GroupedUdfResult groupedUdfs(List<UdfModel> original) {
  final Set<String> seenFieldTypes = {};
  final List<UdfModel> result = [];
  final Map<String, List<UdfModel>> originalFieldTypes = {};

  // Group original field types
  for (var udf in original) {
    if (!originalFieldTypes.containsKey(udf.fieldType)) {
      originalFieldTypes[udf.fieldType] = [];
    }
    originalFieldTypes[udf.fieldType]!.add(udf);
  }

  for (var udf in original) {
    if (['PRJSS', 'RSRSS'].contains(udf.fieldType)) {
      // Keep one representative but preserve the grouping info
      if (!seenFieldTypes.contains('RESOURCE_PROJECT_GROUP')) {
        result.add(
          udf.copyWith(
            fieldType: 'RESOURCE_PROJECT_GROUP', // Use a new group identifier
            // You can add any additional metadata here if needed
          ),
        );
        seenFieldTypes.add('RESOURCE_PROJECT_GROUP');
      }
    } else {
      result.add(udf);
    }
  }

  return GroupedUdfResult(udfs: result, originalFieldTypes: originalFieldTypes);
}
// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Color.fromRGBO(245, 250, 255, 1),
//         leadingWidth: MediaQuery.of(context).size.width,
//         leading: Padding(
//           padding: const EdgeInsets.only(left: 20.0),
//           child: Row(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(top: 5, bottom: 17.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     InkWell(
//                       onTap: () => Navigator.pop(context),
//                       borderRadius: BorderRadius.circular(100),
//                       child: Container(
//                         width: 30,
//                         height: 30,
//                         alignment: Alignment.centerLeft,
//                         child: Icon(Icons.chevron_left_rounded, size: 30),
//                         // Replace Icon with your SVG later:
//                         // child: SvgPicture.asset('assets/icons/chevron_left'),
//                       ),
//                     ),
//                     SizedBox(width: 4), // Adjust for visual spacing with text
//                     Text(
//                       'Booking',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w500,
//                         color: AppColors.darkBlack,
//                       ),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ],
//                 ),
//                 // child: Row(
//                 //   mainAxisAlignment: MainAxisAlignment.start,
//                 //   children: [
//                 //     //todo : to use the SVG icon rather than this
//                 //     InkWell(
//                 //       onTap : () => Navigator.pop(context),
//                 //       child: Container(
//                 //         alignment: Alignment.center,
//                 //         width: 18,
//                 //         height: 10,
//                 //         child: Icon(Icons.chevron_left_rounded),
//                 //       ),
//                 //     ),
//                 //     SizedBox(width: 10),
//                 //     Text(
//                 //       'Booking',
//                 //       style: TextStyle(
//                 //         fontSize: 18,
//                 //         fontWeight: FontWeight.w500,
//                 //         color: Color.fromRGBO(39, 39, 39, 1),
//                 //       ),
//                 //       overflow: TextOverflow.ellipsis,
//                 //     ),
//                 //   ],
//                 // ),
//               ),
//               Spacer(),
//               Padding(
//                 padding: const EdgeInsets.only(right: 20.0, bottom: 12),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     boxShadow: [
//                       BoxShadow(
//                         color: const Color.fromRGBO(16, 24, 40, 0.05),
//                         offset: const Offset(0, 1),
//                         blurRadius: 2,
//                       ),
//                     ],
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: ElevatedButton(
//                     onPressed: _onSavePressed,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color.fromRGBO(28, 121, 212, 1),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(
//                           8,
//                         ), // Rounded corners
//                       ),
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 14,
//                         vertical: 8,
//                       ),
//                     ),
//                     child: Text(
//                       'Save',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                         // fontFamily: 'Inter'
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       body: FutureBuilder<List<SectionModel>>(
//         future: _sectionsFuture,
//         builder: (context, snap) {
//           if (snap.connectionState != ConnectionState.done) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (snap.hasError) {
//             return Center(child: Text('Error: ${snap.error}'));
//           }
//           // final data = <dynamic>[];
//           final data = snap.data!;
//           print("data length - ${data.length}");
//           return ListView.builder(
//             itemCount: data.length,
//             itemBuilder: (context, idx) {
//               final section = data[idx];
//
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       section.title,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   ListView.builder(
//                     itemCount: section.udfs.length,
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemBuilder: (context, index) {
//                       final udf = section.udfs[index];
//                       final interactionType = getInteractionType(udf.fieldType);
//                       return GestureDetector(
//                         onTap: () => TileInteractionService.handle(context, udf, interactionType,),
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 12.0,
//                             vertical: 4.0,
//                           ),
//                           child: Text("${udf.displayName}  ---   ${interactionType}"),
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               );
//             },
//           );
//
//           // final interactionType = getInteractionType(udf.fieldType);
//           // return GestureDetector(
//           //   onTap: () =>  TileInteractionService.handle(context, udf, interactionType,),
//           //   child: Container(
//           //     margin: const EdgeInsets.symmetric(
//           //       vertical: 2,
//           //       horizontal: 25,
//           //     ),
//           //     child: Text(
//           //       "${udf.displayName} - ${interactionType}",
//           //       style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//           //         fontWeight: FontWeight.w400,
//           //         color: Color.fromRGBO(78, 78, 78, 1),
//           //       ),
//           //     ),
//           //   ),
//           // );
//           //   },
//           // );
//         },
//         // builder: (ctx, snap) {
//         //   if (snap.connectionState != ConnectionState.done) {
//         //     return const Center(child: CircularProgressIndicator());
//         //   }
//         //   if (snap.hasError) {
//         //     return Center(child: Text('Error: ${snap.error}'));
//         //   }
//         //   final sections = snap.data!;
//         //   // 1️⃣ Build one flat list mixing headers (String) and UDFs:
//         //   final items = <dynamic>[];
//         //   bool seenResource = false;
//         //   bool isTaskField = false;
//         //   for (var section in sections) {
//         //     items.add(section.title);
//         //     final raw = _udfExtractor.extractUdfs(section);
//         //     for (var udf in raw) {
//         //       // drop end_time
//         //       if (udf.fieldType == 'DATIM' && udf.code == 'end_time') continue;
//         //       // only first RSSRS
//         //       if (udf.fieldType == 'RSRSS') {
//         //         if (seenResource) continue;
//         //         seenResource = true;
//         //       }
//         //       // drop PRJSS/TSKSS always
//         //
//         //       if(udf.fieldType == 'PRJSS'){
//         //         continue;
//         //       }
//         //       //todo : We have to check internally
//         //       if (udf.fieldType == 'TSKSS') {
//         //         isTaskField = true;
//         //         continue;
//         //       }
//         //       items.add(udf);
//         //     }
//         //   }
//         //   return ListView.builder(
//         //     padding: const EdgeInsets.symmetric(horizontal: 16),
//         //     itemCount: items.length,
//         //     itemBuilder: (ctx, i) {
//         //       final item = items[i];
//         //       if (item is String) {
//         //         // section header
//         //         return Container(
//         //           margin: EdgeInsets.only(top: i == 0 ? 12 : 0, bottom: 8),
//         //           child: Text(
//         //             item,
//         //             style: Theme
//         //                 .of(ctx)
//         //                 .textTheme
//         //                 .bodyMedium
//         //                 ?.copyWith(
//         //                 fontWeight: FontWeight.w700,
//         //                 color: Color.fromRGBO(78, 78, 78, 1)
//         //             ),
//         //           ),
//         //         );
//         //       } else {
//         //         // a UDF tile
//         //         final udf = item as UdfModel;
//         //         return Container(
//         //           key: ValueKey(udf.id),
//         //           margin: const EdgeInsets.symmetric(vertical: 12),
//         //           child: UdfTileBuilder(udf: udf, onValueChanged: _onUdfChanged,isTaskField: isTaskField,),
//         //         );
//         //       }
//         //     },
//         //   );
//         // },
//       ),
//     );
// }

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     backgroundColor: Colors.white,
//     appBar: AppBar(
//       backgroundColor: Color.fromRGBO(245, 250, 255, 1),
//       leadingWidth: MediaQuery.of(context).size.width,
//       leading: Padding(
//         padding: const EdgeInsets.only(left: 20.0),
//         child: Row(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(top: 5, bottom: 17.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   InkWell(
//                     onTap: () => Navigator.pop(context),
//                     borderRadius: BorderRadius.circular(100),
//                     child: Container(
//                       width: 30,
//                       height: 30,
//                       alignment: Alignment.centerLeft,
//                       child: Icon(Icons.chevron_left_rounded, size: 30),
//                       // Replace Icon with your SVG later:
//                       // child: SvgPicture.asset('assets/icons/chevron_left'),
//                     ),
//                   ),
//                   SizedBox(width: 4), // Adjust for visual spacing with text
//                   Text(
//                     'Booking',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w500,
//                       color: Color.fromRGBO(39, 39, 39, 1),
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//               // child: Row(
//               //   mainAxisAlignment: MainAxisAlignment.start,
//               //   children: [
//               //     //todo : to use the SVG icon rather than this
//               //     InkWell(
//               //       onTap : () => Navigator.pop(context),
//               //       child: Container(
//               //         alignment: Alignment.center,
//               //         width: 18,
//               //         height: 10,
//               //         child: Icon(Icons.chevron_left_rounded),
//               //       ),
//               //     ),
//               //     SizedBox(width: 10),
//               //     Text(
//               //       'Booking',
//               //       style: TextStyle(
//               //         fontSize: 18,
//               //         fontWeight: FontWeight.w500,
//               //         color: Color.fromRGBO(39, 39, 39, 1),
//               //       ),
//               //       overflow: TextOverflow.ellipsis,
//               //     ),
//               //   ],
//               // ),
//             ),
//             Spacer(),
//             Padding(
//               padding: const EdgeInsets.only(right: 20.0, bottom: 12),
//               child: Container(
//                 decoration: BoxDecoration(
//                   boxShadow: [
//                     BoxShadow(
//                       color: const Color.fromRGBO(16, 24, 40, 0.05),
//                       offset: const Offset(0, 1),
//                       blurRadius: 2,
//                     ),
//                   ],
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: ElevatedButton(
//                   onPressed: () {},
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color.fromRGBO(28, 121, 212, 1),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(
//                         8,
//                       ), // Rounded corners
//                     ),
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 14,
//                       vertical: 8,
//                     ),
//                   ),
//                   child: Text(
//                     'Save',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                       // fontFamily: 'Inter'
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//     /*
//     AppBar(
//       backgroundColor: Color.fromRGBO(245, 250, 255, 1),
//       leading: IconButton(
//         onPressed: () => Navigator.pop(context),
//         icon: const Icon(Icons.chevron_left),
//       ),
//       title: Text(
//         'Booking',
//         style: TextStyle(
//           fontSize: 20,
//           fontWeight: FontWeight.w500,
//           color: Color.fromRGBO(78, 78, 78, 1),
//         ),
//       ),
//       centerTitle: false,
//       actions: [
//         Padding(
//           padding: const EdgeInsets.only(right: 20.0),
//           child: Container(
//             decoration: BoxDecoration(
//               boxShadow: [
//                 BoxShadow(
//                   color: const Color.fromRGBO(16, 24, 40, 0.05),
//                   offset: const Offset(0, 1),
//                   blurRadius: 2,
//                 ),
//               ],
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: ElevatedButton(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color.fromRGBO(28, 121, 212, 1),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8), // Rounded corners
//                 ),
//                 padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//               ),
//               child: Text(
//                 'Save',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: TextSizes().bodyMedium,
//                   fontWeight: FontWeight.w600,
//                   // fontFamily: 'Inter'
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     ),
//      */
//     // body: FutureBuilder<List<SectionModel>>(
//     //   future: _sectionsFuture,
//     //   builder: (context, snapshot) {
//     //     if (snapshot.connectionState != ConnectionState.done) {
//     //       return const Center(child: CircularProgressIndicator());
//     //     }
//     //     if (snapshot.hasError) {
//     //       return Center(
//     //         child: Text(
//     //           'Failed to load sections:\n${snapshot.error}',
//     //           textAlign: TextAlign.center,
//     //         ),
//     //       );
//     //     }
//     //     final sections = snapshot.data!;
//     //     final widgets = <Widget>[];
//     //     for (final section in sections) {
//     //       // 1️⃣ Section Header
//     //       widgets.add(
//     //         Text(
//     //           section.title,
//     //           style: Theme.of(
//     //             context,
//     //           ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
//     //         ),
//     //       );
//     //       final udfs = _udfExtractor.extractUdfs(section);
//     //
//     //       for (final udf in udfs) {
//     //         widgets.add(UdfTileBuilder(udf: udf));
//     //       }
//     //
//     //       // 2️⃣ UDF Tiles
//     //       // final udfs = _udfExtractor.extractUdfs(section);
//     //       // final udfTileBuilder = UdfTileBuilder(udf: udfs,);
//     //       //
//     //       // for (final udf in udfs) {
//     //       //   widgets.add(udfTileBuilder.build(context, udf));
//     //       // }
//     //
//     //       // ------
//     //       // for (final udf in udfs) {
//     //       //   widgets.add(
//     //       //     UnifiedContainerTile(
//     //       //       title: udf.fieldType,
//     //       //       interactionType: TileInteractionType.bottomSheet,
//     //       //     ),
//     //       //   );
//     //       // }
//     //     }
//     //     return ListView(
//     //       padding: const EdgeInsets.symmetric(horizontal: 16),
//     //       children:
//     //           widgets
//     //               .map(
//     //                 (widgets) => Container(
//     //                   margin: EdgeInsetsGeometry.symmetric(vertical: 12),
//     //                   child: widgets,
//     //                 ),
//     //               )
//     //               .toList(),
//     //     );
//     //   },
//     // ),
//     body: SingleChildScrollView(
//       child: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Text(
//                   'Details',
//                   style: TextStyle(
//                     fontSize: TextSizes().bodyMedium,
//                     fontWeight: FontWeight.w700,
//                     color: Color.fromRGBO(51, 51, 51, 1),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 8),
//             UnifiedContainerTile(
//               title: 'Requirement',
//               iconPath: 'requirements',
//               isRequired: true,
//               interactionType: TileInteractionType.bottomSheet,
//               fullSizeBottomSheet: true,
//               // isSearchEnabled: true,
//               bottomSheetContent: BottomSheetOptions(
//                 title: 'Requirements',
//                 isSearchEnabled: true,
//                 isDragHandleNeeded: true,
//                 options: [
//                   'ID 2 / Project b / 45 Hours',
//                   'ID 3 / Project A / 30 Hours',
//                   'ID 1 / Project X / 11 Hours',
//                   'ID 5 / Project C / 20 Hours',
//                 ],
//               ),
//             ),
//             SizedBox(height: 24),
//             ResourceSelector(),
//             SizedBox(height: 24),
//             UnifiedCalendar(
//               initialDate: DateTime.now(),
//               isRangePicker: true,
//               showTime: true,
//               initialFromTime: TimeOfDay(hour: 9, minute: 00),
//               repeatOptions: [
//                 'None',
//                 'Daily',
//                 'Weekly',
//                 'Monthly',
//                 'Yearly',
//                 'Custom',
//               ],
//               onRepeatSelected: (value) {
//                 if (value == 'Custom') {
//                   BottomSheetService.showCustomBottomSheet(
//                     context: context,
//                     child: BottomSheetOptions(
//                       title: 'Custom',
//                       unifiedcontainercontent: Column(
//                         children: [CustomTab()],
//                       ),
//                     ),
//                   );
//                 }
//               },
//             ),
//             SizedBox(height: 24),
//             UnifiedContainerTile(
//               title: 'Email',
//               itemText: _emailController.text,
//               iconPath: 'email',
//               interactionType: TileInteractionType.bottomSheet,
//               bottomSheetContent: BottomSheetOptions(
//                 title: 'Email',
//                 isTextFieldNeeded: true,
//                 customTextField: CustomTextField(
//                   hintText: 'Email',
//                   controller: _emailController,
//                   onChanged: (_) => setState(() {}),
//                 ),
//                 onDone: () {
//                   setState(() {});
//                 },
//               ),
//             ),
//             SizedBox(height: 24),
//             UnifiedContainerTile(
//               title: 'Performing Role',
//               iconPath: 'roles',
//               interactionType: TileInteractionType.bottomSheet,
//               bottomSheetContent: const BottomSheetOptions(
//                 isSearchEnabled: true,
//                 options: [
//                   'Software Engineer',
//                   'IT Engineer',
//                   'Quality Assurance Engineer',
//                   'Software Development Engineer',
//                 ],
//               ),
//             ),
//             SizedBox(height: 24),
//             UnifiedContainerTile(
//               title: 'Number',
//               iconPath: 'numbers',
//               interactionType: TileInteractionType.bottomSheet,
//               bottomSheetContent: BottomSheetOptions(
//                 title: 'Number',
//                 isTextFieldNeeded: true,
//                 customTextField: CustomTextField(
//                   hintText: 'Number',
//                   controller: _numberController,
//                   keyboardType: TextInputType.number,
//                   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                   onChanged: (_) => setState(() {}),
//                 ),
//                 onDone: () => setState(() {}),
//               ),
//             ),
//             SizedBox(height: 24),
//             UnifiedContainerTile(
//               title: 'Fractional Number',
//               iconPath: 'fraction',
//               interactionType: TileInteractionType.bottomSheet,
//               bottomSheetContent: BottomSheetOptions(
//                 title: 'Fractional Number',
//                 isTextFieldNeeded: true,
//                 customTextField: CustomTextField(
//                   controller: _fractionController,
//                   hintText: 'Fractional Number',
//                   keyboardType: TextInputType.number,
//                   inputFormatters: [
//                     FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
//                   ],
//                   onChanged: (_) => setState(() {}),
//                 ),
//                 onDone: () => setState(() {}),
//               ),
//             ),
//             SizedBox(height: 24),
//             UnifiedContainerTile(
//               title: 'Simple Text',
//               iconPath: 'text_format',
//               interactionType: TileInteractionType.bottomSheet,
//               bottomSheetContent: const BottomSheetOptions(
//                 title: 'Simple Text',
//                 isTextFieldNeeded: true,
//               ),
//             ),
//             SizedBox(height: 24),
//             UnifiedContainerTile(
//               title: 'Date',
//               iconPath: 'date',
//               interactionType: TileInteractionType.bottomSheet,
//               fullSizeBottomSheet: true,
//               bottomSheetContent: const BottomSheetOptions(
//                 title: 'Date',
//                 isDateWidget: true,
//               ),
//             ),
//             SizedBox(height: 24),
//             UnifiedContainerTile(
//               title: 'Progress',
//               iconPath: 'slider',
//               interactionType: TileInteractionType.expandable,
//             ),
//             SizedBox(height: 24),
//             UnifiedContainerTile(
//               title: 'Department',
//               iconPath: 'ddss',
//               interactionType: TileInteractionType.bottomSheet,
//               bottomSheetContent: const BottomSheetOptions(
//                 title: 'Department',
//                 isDonethere: false,
//                 isSearchEnabled: true,
//                 options: [
//                   'Research',
//                   'UI UX',
//                   'Software Development',
//                   'User Testing',
//                 ],
//               ),
//             ),
//             SizedBox(height: 24),
//             UnifiedContainerTile(
//               title: 'Skill',
//               iconPath: 'ddms',
//               interactionType: TileInteractionType.bottomSheet,
//               bottomSheetContent: const BottomSheetOptions(
//                 DDMS: true,
//                 title: 'Select the Skills',
//                 isSearchEnabled: true,
//                 options: [
//                   'Research',
//                   'UI UX',
//                   'Software Development',
//                   'User Testing',
//                 ],
//               ),
//             ),
//             SizedBox(height: 24),
//             UnifiedContainerTile(
//               title: 'Select an option',
//               iconPath: 'uss',
//               interactionType: TileInteractionType.bottomSheet,
//               bottomSheetContent: const BottomSheetOptions(
//                 isSearchEnabled: true,
//                 title: 'Select an option',
//                 isDonethere: false,
//                 options: [
//                   'Alex Martin',
//                   'Albert Murphy',
//                   'John Will',
//                   'Harsh Patel',
//                 ],
//               ),
//             ),
//             SizedBox(height: 24),
//             UnifiedContainerTile(
//               title: 'Select an options',
//               iconPath: 'ums',
//               interactionType: TileInteractionType.bottomSheet,
//               bottomSheetContent: const BottomSheetOptions(
//                 title: 'Select Options',
//                 isDonethere: true,
//                 isSearchEnabled: true,
//                 DDMS: true,
//                 options: [
//                   'Alex Martin',
//                   'Albert Murphy',
//                   'John Will',
//                   'Harsh Patel',
//                 ],
//               ),
//             ),
//             SizedBox(height: 24),
//             UnifiedContainerTile(
//               title: 'Priority',
//               iconPath: 'label',
//               interactionType: TileInteractionType.bottomSheet,
//               bottomSheetContent: BottomSheetOptions(isPriority: true),
//             ),
//             SizedBox(height: 24),
//             UnifiedContainerTile(
//               title: 'Colors',
//               iconPath: 'color',
//               interactionType: TileInteractionType.bottomSheet,
//               bottomSheetContent: BottomSheetOptions(
//                 isColorPalleteNeeded: true,
//               ),
//             ),
//             SizedBox(height: 24),
//             UnifiedContainerTile(
//               title: 'Time Zone',
//               iconPath: 'time_zone',
//               interactionType: TileInteractionType.bottomSheet,
//               bottomSheetContent: const BottomSheetOptions(
//                 isSearchEnabled: true,
//                 options: [
//                   '(UTC-11:00) Pacific/Midway (SST) ',
//                   '(UTC-11:00) Pacific/Samoa (SST)  ',
//                   '(UTC-11:00) US/Samoa (SST)',
//                   '(UTC-10:00) Pacific/Honolulu (HST)',
//                   '(UTC-09:00) US/Aleutian (HADT)',
//                 ],
//               ),
//             ),
//             SizedBox(height: 24),
//             UnifiedContainerTile(
//               title: 'Effort',
//               iconPath: 'efforts',
//               interactionType: TileInteractionType.popupMenu,
//               isPinTextNeeded: true,
//               popMenuOptions: ['% Capacity', 'Hours', 'FTE'],
//             ),
//             SizedBox(height: 24),
//             UnifiedContainerTile(
//               title: 'Confirmed',
//               iconPath: 'confirmed',
//               interactionType: TileInteractionType.popupMenu,
//               popMenuOptions: ['Yes', 'No'],
//             ),
//             SizedBox(height: 24),
//             UnifiedContainerTile(
//               title: 'Travel Required',
//               iconPath: 'confirmed',
//               interactionType: TileInteractionType.popupMenu,
//               popMenuOptions: ['Yes', 'No'],
//             ),
//             SizedBox(height: 24),
//             UnifiedContainerTile(
//               title: 'Date & Time',
//               iconPath: 'date',
//               interactionType: TileInteractionType.bottomSheet,
//               fullSizeBottomSheet: true,
//               bottomSheetContent: const BottomSheetOptions(
//                 title: 'Date & Time',
//                 isDateWidget: true,
//                 isTimeWidget: true,
//               ),
//             ),
//             SizedBox(height: 24),
//             Row(
//               children: [
//                 Text(
//                   'Financials',
//                   style: TextStyle(
//                     fontSize: TextSizes().bodyMedium,
//                     fontWeight: FontWeight.w700,
//                     color: Color.fromRGBO(51, 51, 51, 1),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 8),
//             UnifiedContainerTile(
//               title: 'Billing Status',
//               iconPath: 'projects',
//               interactionType: TileInteractionType.popupMenu,
//               popMenuOptions: ['Inherit from Project', 'Billable', 'Non Billable'],
//             ),
//             SizedBox(height: 24),
//             UnifiedContainerTile(
//               title: 'Billing Rate',
//               iconPath: 'requirements',
//               interactionType: TileInteractionType.bottomSheet,
//               bottomSheetContent: const BottomSheetOptions(
//                 isDonethere: true,
//                 options: [
//                   'Inherit from Project',
//                   'Inherit from Resource',
//                   'Inherit from Role',
//                   'Custom',
//                 ],
//               ),
//             ),
//             SizedBox(height: 24),
//             Row(
//               children: [
//                 Text(
//                   'Notes',
//                   style: TextStyle(
//                     fontSize: TextSizes().bodyMedium,
//                     fontWeight: FontWeight.w700,
//                     color: Color.fromRGBO(51, 51, 51, 1),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 8),
//             UnifiedContainerTile(
//               title: 'Notes',
//               iconPath: 'notes',
//               interactionType: TileInteractionType.navigation,
//               navigationTarget: NotesPageScreen(),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
