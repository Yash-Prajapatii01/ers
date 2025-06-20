import 'package:ers_linux/features/scheduling/data/models/udfModel.dart';
import 'package:ers_linux/features/scheduling/presentation/utils/TileInteractionHandleTap.dart';
import 'package:ers_linux/features/scheduling/presentation/utils/showBottomSheet.dart';
import 'package:ers_linux/features/scheduling/presentation/widgets/UnifiedContainerTile/unifiedContainerTile.dart';
import 'package:ers_linux/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../shared/constants/text_sizes.dart';
import '../../../data/models/resource_model.dart';
import '../UnifiedContainerTile/tile_interaction_type.dart';

class ResourceSelector extends StatefulWidget {
  final void Function(String)? onValueChanged;
  final void Function(String, dynamic)? onProjectValueChanged;
  final bool showTaskField;
  final UdfModel? ResourceProjectUdf;
  final Map<String, List<UdfModel>>? originalFieldTypes;

  const ResourceSelector({
    super.key,
    this.onValueChanged,
    this.onProjectValueChanged,
    this.showTaskField = false,
    this.ResourceProjectUdf,
    this.originalFieldTypes,
  });

  @override
  State<ResourceSelector> createState() => _ResourceSelectorState();
}

class _ResourceSelectorState extends State<ResourceSelector> {
  String? selectedAvatarUrl;
  String? selectedName;
  int? selectedResourceId;

  @override
  Widget build(BuildContext context) {
    final resourceUdfs = widget.originalFieldTypes?['RSRSS'] ?? [];
    final projectUdfs = widget.originalFieldTypes?['PRJSS'] ?? [];
    String projectResult = '';
    return Container(
      padding: const EdgeInsets.all(15.5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: AppColors.bookingContainerTileBorder,
          width: 0.5.w,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resource',
            style: TextStyle(
              fontSize: TextSizes().bodyMedium,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap:
                    () =>
                    BottomSheetService.showCustomBottomSheet(
                      context: context,
                      child: BottomSheetOptions(
                        title: 'Resources',
                        isSearchEnabled: true,
                        isDonethere: false,
                        SearchHintText: 'Search for Resources',
                        DDMS: false,
                        udfModel: resourceUdfs.first,
                      ),
                      onSelected: (result) {
                        print("Here in the RSRSS Selector");
                        if (result['type'] == 'resource') {
                          ResourceModel selected = result['resource'];
                          setState(() {
                            selectedAvatarUrl = selected.imageUrl;
                            selectedName = selected.name;
                            selectedResourceId = selected.id;
                          });
                        }
                        widget.onValueChanged?.call(selectedResourceId.toString());
                      },
                    ),
                child: CircleAvatar(
                  radius: 20.r,
                  backgroundColor: AppColors.calenderPillColor,
                  child: SvgPicture.asset(
                    'assets/icons/scheduling/booking/add_resource.svg',
                  ),
                ),
              ),
              if (selectedAvatarUrl != null) ...[
                SizedBox(width: 12.w),
                Container(
                  width: 1.w,
                  height: 21.h,
                  color: const Color.fromRGBO(82, 82, 82, 0.6),
                ),
                SizedBox(width: 8.w),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20.r,
                      backgroundImage: NetworkImage(selectedAvatarUrl!),
                    ),
                    SizedBox(width: 8.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedName ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.selectedResourceName,
                            fontSize: 12.sp,
                          ),
                        ),
                        // Text(
                        //   selectedRole ?? '',
                        //   style: TextStyle(
                        //     fontSize: 12.sp,
                        //     color: Color.fromRGBO(165, 165, 165, 1),
                        //     fontWeight: FontWeight.w400,
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
              ],
            ],
          ),
          SizedBox(height: 16.h),
          UnifiedContainerTile(
              title: 'Project',
              itemText: projectResult,
              iconPath: 'projects',
              interactionType: TileInteractionType.bottomSheet,
              isRequired: true,
              bottomSheetContent: BottomSheetOptions(
                isSearchEnabled: true,
                udfModel: projectUdfs.first,
                title: 'Projects',
                showCheckboxes: false,
                DDMS: false,
                isDonethere: false,
                options: widget.ResourceProjectUdf!.udfOptionsList,
              ),
              onOptionSelected: (value) {
                //todo : project id not saving there as it should be;;;;
                // widget.onValueChanged?.call(value);
                widget.onProjectValueChanged?.call(projectUdfs.first.code, value);
              },
          ),
          // GestureDetector(
          //   onTap:
          //       () => TileInteractionService.handle(
          //         context,
          //         projectUdfs.first,
          //         TileInteractionType.bottomSheet,
          //       ),
          //   child: Container(
          //     height: 44.w,
          //     padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 9.h),
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(8.r),
          //       border: Border.all(
          //         color: AppColors.bookingContainerTileBorder,
          //         width: 0.5.w,
          //       ),
          //     ),
          //     child: Column(
          //       mainAxisSize: MainAxisSize.min,
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Row(
          //           children: [
          //             SvgPicture.asset(
          //               'assets/icons/scheduling/booking/projects.svg',
          //             ),
          //             SizedBox(width: 8.w),
          //             Expanded(
          //               child: Text.rich(
          //                 TextSpan(
          //                   text: 'Project',
          //                   style: TextStyle(
          //                     fontSize: 14.sp,
          //                     fontWeight: FontWeight.w400,
          //                     color: AppColors.darkBlack,
          //                   ),
          //                   children:
          //                       true
          //                           ? [
          //                             TextSpan(
          //                               text: '*',
          //                               style: TextStyle(color: Colors.red),
          //                             ),
          //                           ]
          //                           : [],
          //                 ),
          //               ),
          //             ),
          //           ],
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
