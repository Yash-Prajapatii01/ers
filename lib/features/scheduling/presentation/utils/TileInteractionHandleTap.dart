import 'package:ers_linux/features/scheduling/presentation/screens/NotesPageScreen.dart';
import 'package:ers_linux/features/scheduling/presentation/utils/BookingFormBloc/booking_form_bloc.dart';
import 'package:ers_linux/features/scheduling/presentation/utils/showBottomSheet.dart';
import 'package:ers_linux/features/scheduling/presentation/utils/udfOptionProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/udfModel.dart';
import '../widgets/UnifiedContainerTile/tile_interaction_type.dart';

// class TileInteractionService {
//   static Future<void> handle(
//     BuildContext context,
//     UdfModel udf,
//     TileInteractionType type,
//   ) async {
//     switch (type) {
//       case TileInteractionType.navigation:
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => NotesPageScreen()),
//         );
//         break;
//       case TileInteractionType.bottomSheet:
//         await BottomSheetService.showCustomBottomSheet(
//           context: context,
//           child: await UdfOptionProvider.provide(
//             context: context,
//             fieldType: udf.fieldType,
//             udfOptionsList: udf.udfOptionsList,
//             onSelect: (name, id) {
//               print("fieldType");
//               print(udf.fieldType);
//               print("Name - ${name} , id - ${id}");
//               context.read<BookingFormBloc>().add(
//                 SelectOptionEvent(
//                   name: udf.displayName,
//                   id: id,
//                   fieldType: udf.fieldType,
//                 ),
//               );
//             },
//           ),
//         );
//         break;
//       case TileInteractionType.popupMenu:
//         print("Here PopUp menu will be shown");
//         break;
//       case TileInteractionType.expandable:
//         print("Here the expandable will expand");
//         break;
//       case TileInteractionType.none:
//         // fallback
//         break;
//     }
//   }
// }
