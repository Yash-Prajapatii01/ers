// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
//
// class ContainerTile extends StatelessWidget {
//   final String title;
//   final String itemText;
//   final String iconPath;
//   final VoidCallback? onTap;
//
//   const ContainerTile({super.key, required this.title, required this.itemText, required this.iconPath, this.onTap});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(
//           color: const Color.fromRGBO(208, 213, 221, 1),
//           width: 0.5
//         ),
//       ),
//       child: Row(
//         children: [
//           SvgPicture.asset(iconPath),
//           const SizedBox(width: 12),
//            Expanded(
//             child: Text(
//               title,
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w400,
//                 color: Color(0xFF212121),
//               ),
//             ),
//           ),
//            Text(
//             itemText,
//             style: TextStyle(
//               fontSize: 14,
//               color: Color.fromRGBO(102, 112, 133, 0.5),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//           GestureDetector(onTap: onTap,  child: Icon(Icons.chevron_right, color: Colors.grey)),
//         ],
//       ),
//     );
//   }
// }

//
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
//
// class ContainerTile extends StatelessWidget {
//   final String title;
//   final String itemText;
//   final String iconPath;
//   final Widget? bottomSheetContent; // New parameter for custom sheet content
//
//   const ContainerTile({
//     super.key,
//     required this.title,
//     required this.itemText,
//     required this.iconPath,
//     this.bottomSheetContent,
//   });
//
//   void showCustomBottomSheet(BuildContext context, Widget child) {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       isScrollControlled: true,
//       builder: (context) => Padding(
//         padding: EdgeInsets.only(
//           bottom: MediaQuery.of(context).viewInsets.bottom,
//         ),
//         child: child,
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         if (bottomSheetContent != null) {
//           showCustomBottomSheet(context, bottomSheetContent!);
//         }
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(
//             color: const Color.fromRGBO(208, 213, 221, 1),
//             width: 0.5,
//           ),
//         ),
//         child: Row(
//           children: [
//             SvgPicture.asset(iconPath),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w400,
//                   color: Color(0xFF212121),
//                 ),
//               ),
//             ),
//             Text(
//               itemText,
//               style: const TextStyle(
//                 fontSize: 14,
//                 color: Color.fromRGBO(102, 112, 133, 0.5),
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//             const Icon(Icons.chevron_right, color: Colors.grey),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class BottomSheetOptions extends StatelessWidget {
//   final BottomSheetTitle;
//   const BottomSheetOptions({super.key, this.BottomSheetTitle});
//
//   @override
//   Widget build(BuildContext context) {
//     final options = [
//       'Research',
//       'User Interface Design',
//       'Wireframing',
//       'Prototyping',
//       'User Testing',
//     ];
//
//     return SafeArea(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//            Padding(
//             padding: EdgeInsets.symmetric(vertical: 16),
//             child: Text(
//                 (BottomSheetTitle != null) ? BottomSheetTitle : 'Choose',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//           ),
//           ...options.map((item) => ListTile(
//             title: Text(item),
//             onTap: () {
//               Navigator.pop(context); // close sheet on selection
//               // You can also return selected value here with a callback
//             },
//           )),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'customCalender.dart';

class ContainerTile extends StatelessWidget {
  final String title;
  final String itemText;
  final String iconPath;
  final Widget? bottomSheetContent;

  const ContainerTile({
    super.key,
    required this.title,
    required this.itemText,
    required this.iconPath,
    this.bottomSheetContent,
  });

  void showCustomBottomSheet(BuildContext context, Widget child) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (_) => DraggableScrollableSheet(
            initialChildSize: 0.95,
            minChildSize: 0.3,
            maxChildSize: 0.98,
            expand: false,
            builder:
                (context, scrollController) => Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                  ),
                  child: child,
                ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (bottomSheetContent != null) {
          showCustomBottomSheet(context, bottomSheetContent!);
        }
        else{

        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color.fromRGBO(208, 213, 221, 1),
            width: 0.5,
          ),
        ),
        child: Row(
          children: [
            SvgPicture.asset(iconPath),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF212121),
                ),
              ),
            ),
            Text(
              itemText,
              style: const TextStyle(
                fontSize: 14,
                color: Color.fromRGBO(102, 112, 133, 0.5),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class BottomSheetOptions extends StatelessWidget {
  final String title;
  final List<String>? options;
  final VoidCallback? onDone;
  final bool? isSearchEnabled;
  final bool? isEmptyFieldNeeded;


  const BottomSheetOptions({
    super.key,
    this.title = 'Choose',
    this.options,
    this.onDone, this.isSearchEnabled,
    this.isEmptyFieldNeeded
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Color.fromRGBO(242, 48, 48, 1),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Color.fromRGBO(51, 51, 51, 1)
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    if (onDone != null) onDone!();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: const Text(
                      'Done',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          if (isSearchEnabled == true)
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(102, 112, 133, 0.5)
                  ),
                  prefixIcon: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: const BoxDecoration(
                      border: Border(
                        right: BorderSide(color: Color(0xFFE0E0E0), width: 1),
                      ),
                    ),
                    child: const Icon(CupertinoIcons.search, color: Colors.grey),
                  ),
                  filled: true,
                  fillColor: const Color.fromRGBO(245, 246, 248, 1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                // Still no search logic because it's stateless
              ),
            ),

          // List of options
          Expanded(
            child: (options != null) ? ListView.separated(
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemCount: options!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    title: Text(options![index],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),),
                    onTap: () {
                      // handle option tap if needed
                    },
                  ),
                );
              },
            ) : Center(child: Text('No data !!'))
          ),
        ],
      ),
    );
  }
}
