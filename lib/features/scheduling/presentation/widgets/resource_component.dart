import 'package:ers_linux/features/scheduling/presentation/utils/showBottomSheet.dart';
import 'package:ers_linux/features/scheduling/presentation/widgets/unifiedContainerTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../shared/constants/text_sizes.dart';
import '../../data/models/resource.dart';

class ResourceSelector extends StatefulWidget {
  final List<String> avatarUrls;

  const ResourceSelector({super.key, required this.avatarUrls});

  @override
  State<ResourceSelector> createState() => _ResourceSelectorState();
}

class _ResourceSelectorState extends State<ResourceSelector> {
  String? selectedAvatarUrl;
  String? selectedName;
  String? selectedRole;

  void _onAvatarTap(String url) {
    setState(() {
      selectedAvatarUrl = url;
      selectedName = 'Yash';
      selectedRole = 'Flutter Developer';
    });
  }
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
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color.fromRGBO(208, 213, 221, 1),
          width: 0.5,
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
          const SizedBox(height: 8),
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
                  radius: 20,
                  backgroundColor: const Color.fromRGBO(244, 244, 244, 1),
                  child: SvgPicture.asset(
                    'assets/icons/scheduling/booking/add_resource.svg',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 1,
                height: 21,
                color: const Color.fromRGBO(82, 82, 82, 0.6),
              ),
              const SizedBox(width: 8),
              if (selectedAvatarUrl == null)
                ...widget.avatarUrls.map(
                  (url) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: GestureDetector(
                      onTap: () => _onAvatarTap(url),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(url),
                      ),
                    ),
                  ),
                )
              else
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(selectedAvatarUrl!),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedName ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          selectedRole ?? '',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromRGBO(165, 165, 165, 1),
                            fontWeight: FontWeight.w400
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 24),

          // Project tile
          UnifiedContainerTile(
            title: 'Project',
            iconPath: 'assets/icons/scheduling/booking/projects.svg',
            interactionType: TileInteractionType.bottomSheet,
            bottomSheetContent: BottomSheetOptions(
              isSearchEnabled: true,
              title: 'Projects',
              showCheckboxes: false,
              DDMS: true,
              options: ['FocusFlow', 'FitLoop', 'LearnMate', 'StreakSync'],
            ),
          ),
          const SizedBox(height: 12),

          // Task tile
          UnifiedContainerTile(
            title: 'Task',
            iconPath: 'assets/icons/scheduling/booking/ddss.svg',
            interactionType: TileInteractionType.bottomSheet,
            bottomSheetContent: BottomSheetOptions(
              isSearchEnabled: true,
              title: 'Tasks',
              options: ['Task A', 'Task B', 'Task C', 'Task D'],
            ),
          ),
        ],
      ),
    );
  }
}
