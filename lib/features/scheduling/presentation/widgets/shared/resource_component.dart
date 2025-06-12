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
  final bool isTasksFieldNeeded;

  const ResourceSelector({super.key, this.onValueChanged, required this.isTasksFieldNeeded});

  @override
  State<ResourceSelector> createState() => _ResourceSelectorState();
}

class _ResourceSelectorState extends State<ResourceSelector> {
  String? selectedAvatarUrl;
  String? selectedName;
  String? selectedRole;


  final List<Resource> resources = [
    Resource(name: 'Yash', designation: 'Flutter Developer', imageUrl: 'https://xsgames.co/randomusers/assets/avatars/male/1.jpg'),
    Resource(name: 'Albert', designation: 'Backend Engineer', imageUrl: 'https://xsgames.co/randomusers/assets/avatars/male/2.jpg'),
    Resource(name: 'Siyahi', designation: 'AI Engineer', imageUrl: 'https://xsgames.co/randomusers/assets/avatars/male/3.jpg'),
    Resource(name: 'Deep', designation: 'ML Engineer', imageUrl: 'https://xsgames.co/randomusers/assets/avatars/male/4.jpg'),
    Resource(name: 'Aye Dante', designation: 'Operation Head', imageUrl: 'https://xsgames.co/randomusers/avatar.php?g=male'),
    Resource(name: 'Emilio', designation: 'Frontend Engineer', imageUrl: 'https://xsgames.co/randomusers/avatar.php?g=female'),
    Resource(name: 'John', designation: 'Business Analyst Engineer', imageUrl: 'https://xsgames.co/randomusers/assets/avatars/male/6.jpg'),
    Resource(name: 'Dennis', designation: 'UI UX Engineer', imageUrl: 'https://xsgames.co/randomusers/assets/avatars/male/7.jpg'),
    Resource(name: 'Obama', designation: 'UI UX', imageUrl: 'https://xsgames.co/randomusers/assets/avatars/male/8.jpg'),
    Resource(name: 'Clinton', designation: 'ITya Engineer', imageUrl: 'https://xsgames.co/randomusers/assets/avatars/male/9.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
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
                    () => BottomSheetService.showCustomBottomSheet(
                      context: context,
                      child: BottomSheetOptions(
                        title: 'Resources',
                        isSearchEnabled: true,
                        isDonethere: false,
                        SearchHintText: 'Search for Resources',
                        DDMS: false,
                        resourceOptions: resources,
                      ),
                      onSelected: (result) {
                        if (result['type'] == 'resource') {
                          Resource selected = result['resource'];
                          setState(() {
                            selectedAvatarUrl = selected.imageUrl;
                            selectedName = selected.name;
                            selectedRole = selected.designation;
                          });
                          // Use the resource object as needed
                        }
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
                            fontSize: 14.sp,
                          ),
                        ),
                        Text(
                          selectedRole ?? '',
                          style: TextStyle(
                              fontSize: 12.sp,
                              color: Color.fromRGBO(165, 165, 165, 1),
                              fontWeight: FontWeight.w400
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ]
            ],
          ),
          SizedBox(height: 16.h ),

          // Project tile
          UnifiedContainerTile(
            title: 'Project',
            iconPath: 'projects',
            interactionType: TileInteractionType.bottomSheet,
            isRequired: true,
            bottomSheetContent: BottomSheetOptions(
              isSearchEnabled: true,
              title: 'Projects',
              showCheckboxes: false,
              DDMS: true,
              options: []
            ),
          ),
          // Task tile
          if(widget.isTasksFieldNeeded) ...[
            SizedBox(height: 16.h),
            UnifiedContainerTile(
              title: 'Task',
              iconPath: 'ddss',
              interactionType: TileInteractionType.bottomSheet,
              bottomSheetContent: BottomSheetOptions(
                  isSearchEnabled: true,
                  title: 'Tasks',
                  options: []
              ),
            ),
          ]
        ],
      ),
    );
  }
}
