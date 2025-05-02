import 'package:ers_linux/features/scheduling/presentation/widgets/ColorPicker.dart';
import 'package:ers_linux/features/scheduling/presentation/widgets/CustomTextfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../screens/NotesPageScreen.dart';
import 'CustomCalender.dart';

class ContainerTile extends StatelessWidget {
  final String title;
  final String itemText;
  final String iconPath;
  final Widget? bottomSheetContent;
  final bool? isDonethere;
  final bool? nextpageto;

  const ContainerTile({
    super.key,
    required this.title,
    required this.itemText,
    required this.iconPath,
    this.bottomSheetContent,
    this.isDonethere,
    this.nextpageto = false
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
        if (nextpageto == true) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NotesPageScreen()),
          );
          return; // Prevents executing any other logic
        }

        if (bottomSheetContent != null) {
          showCustomBottomSheet(context, bottomSheetContent!);
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

// @override
  // Widget build(BuildContext context) {
  //   if (nextpageto == true) {
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => const NotesPageScreen()),
  //       );
  //     });
  //   }
  //   return GestureDetector(
  //     onTap: () {
  //       if (bottomSheetContent != null) {
  //         showCustomBottomSheet(context, bottomSheetContent!);
  //       } else {}
  //     },
  //     child: Container(
  //       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(8),
  //         border: Border.all(
  //           color: const Color.fromRGBO(208, 213, 221, 1),
  //           width: 0.5,
  //         ),
  //       ),
  //       child: Row(
  //         children: [
  //           SvgPicture.asset(iconPath),
  //           const SizedBox(width: 12),
  //           Expanded(
  //             child: Text(
  //               title,
  //               style: const TextStyle(
  //                 fontSize: 16,
  //                 fontWeight: FontWeight.w400,
  //                 color: Color(0xFF212121),
  //               ),
  //             ),
  //           ),
  //           Text(
  //             itemText,
  //             style: const TextStyle(
  //               fontSize: 14,
  //               color: Color.fromRGBO(102, 112, 133, 0.5),
  //               overflow: TextOverflow.ellipsis,
  //             ),
  //           ),
  //           const Icon(Icons.chevron_right, color: Colors.grey),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}

class BottomSheetOptions extends StatelessWidget {
  final String title;
  final List<String>? options;
  final VoidCallback? onDone;
  final bool? isSearchEnabled;
  final bool? isTextFieldNeeded;
  final CustomTextField? customTextField;
  final bool? isDateWidget;
  final bool? isTimeWidget;
  final bool? isDonethere;
  final bool? DDMS;
  final bool? isColorPalleteNeeded;


  const BottomSheetOptions({
    super.key,
    this.title = 'Choose',
    this.options,
    this.onDone,
    this.isSearchEnabled,
    this.isTextFieldNeeded,
    this.customTextField,
    this.isDateWidget = false,
    this.isTimeWidget,
    this.isDonethere = true,
    this.DDMS = false,
    this.isColorPalleteNeeded = false,

  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:Column(
        children: [
          _buildHeader(context),
          const Divider(height: 1),
          if (isSearchEnabled == true) _buildSearchField(),
          _buildContent(),
        ],
      ),
    );
  }

  // Header with Cancel and Done buttons
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
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
              color: Color.fromRGBO(51, 51, 51, 1),
            ),
          ),
          if (isDonethere == true)
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                onDone?.call();
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'Done',
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ),
              ),
            )
          else
            Spacer(),
          // const SizedBox(width: 60), // or use Spacer() if you prefer balanced layout
        ],
      ),
    );
  }

  // Search field
  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color.fromRGBO(102, 112, 133, 0.5),
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
      ),
    );
  }

  // Widget _buildContent() {
  //   if(isColorPalleteNeeded!){
  //     return ColorPickerGrid(
  //       onColorSelected: (color) {
  //       },
  //     );
  //   }
  //   if (isDateWidget! && isTimeWidget!) {
  //     return StandaloneCalendar(isTimeShow: true);
  //   }
  //
  //   if (isDateWidget!) {
  //     return StandaloneCalendar(isTimeShow: false);
  //   }
  //
  //   final bool showEmptyField = isTextFieldNeeded ?? false;
  //
  //   if (showEmptyField) {
  //     if (customTextField != null) {
  //       return customTextField!;
  //     } else {
  //       return const Expanded(
  //         child: Padding(
  //           padding: EdgeInsets.all(16),
  //           child: TextField(
  //             keyboardType: TextInputType.multiline,
  //             maxLines: null,
  //             expands: true,
  //             style: TextStyle(fontSize: 16),
  //             decoration: InputDecoration.collapsed(hintText: 'Type Something'),
  //           ),
  //         ),
  //       );
  //     }
  //   }
  //
  //   return _buildOptionsList();
  // }
  Widget _buildContent() {
    if (isColorPalleteNeeded!) {
      return Expanded(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ColorPickerGrid(
            onColorSelected: (color) {
              // You can add logic here if needed
              print("Selected color: $color");
            },
          ),
        ),
      );
    }

    if (isDateWidget! && isTimeWidget!) {
      return StandaloneCalendar(isTimeShow: true);
    }

    if (isDateWidget!) {
      return StandaloneCalendar(isTimeShow: false);
    }

    final bool showEmptyField = isTextFieldNeeded ?? false;

    if (showEmptyField) {
      if (customTextField != null) {
        return customTextField!;
      } else {
        return const Expanded(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              expands: true,
              style: TextStyle(fontSize: 16),
              decoration: InputDecoration.collapsed(hintText: 'Type Something'),
            ),
          ),
        );
      }
    }
    return _buildOptionsList();
  }

  Widget _buildOptionsList() {
    if (options == null || options!.isEmpty) {
      return const Expanded(child: Center(child: Text('No data !!')));
    }

    return DDMS == true
        ? _DDMSSelectableList(options: options!)
        : Expanded(
          child: ListView.separated(
            separatorBuilder:
                (_, __) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: const Divider(thickness: 1),
                ),
            itemCount: options!.length,
            itemBuilder: (context, index) {
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                title: Text(
                  options![index],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context, options![index]);
                },
              );
            },
          ),
        );
  }

  // Email field
}

// -----------------------------------------

class _DDMSSelectableList extends StatefulWidget {
  final List<String> options;

  const _DDMSSelectableList({required this.options});

  @override
  State<_DDMSSelectableList> createState() => _DDMSSelectableListState();
}

class _DDMSSelectableListState extends State<_DDMSSelectableList> {
  final List<String> _selectedItems = [];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // Align content to the start
        children: [
          // Selected tags
          if (_selectedItems.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Align(
                alignment: Alignment.topLeft,
                // Ensure alignment starts from left
                child: Wrap(
                  alignment: WrapAlignment.start,
                  // Align chips to start from left
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      _selectedItems.map((item) {
                        // Using custom chip implementation with text properly contained
                        return Container(
                          margin: const EdgeInsets.only(right: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Stack(
                            clipBehavior: Clip.none, // Allow overflow
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                child: Text(
                                  item,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                              Positioned(
                                top: -6,
                                right: -6,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(8),
                                  onTap: () {
                                    setState(() {
                                      _selectedItems.remove(item);
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.grey.shade100.withOpacity(
                                          0.5,
                                        ),
                                        width: 0.5,
                                      ),
                                      color:
                                          Colors
                                              .grey
                                              .shade200, // Optional: contrast background
                                    ),
                                    child: const Icon(Icons.close, size: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                ),
              ),
            ),

          // Options list with checkboxes
          Expanded(
            child: ListView.separated(
              itemCount: widget.options.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = widget.options[index];
                final isSelected = _selectedItems.contains(item);

                return CheckboxListTile(
                  title: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  checkboxShape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                  value: isSelected,
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _selectedItems.add(item);
                      } else {
                        _selectedItems.remove(item);
                      }
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
