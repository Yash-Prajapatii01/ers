import 'package:ers_linux/features/scheduling/presentation/widgets/unifiedContainerTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../shared/constants/text_sizes.dart';

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
      // Ideally fetch name/role from a model map or API here
      selectedName = 'Yash'; // placeholder
      selectedRole = 'Flutter Developer';   // placeholder
    });
  }

  @override
  Widget build(BuildContext context) {
    final showSeparator = selectedAvatarUrl == null;

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
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color.fromRGBO(244, 244, 244, 1),
                backgroundImage: selectedAvatarUrl != null
                    ? NetworkImage(selectedAvatarUrl!)
                    : null,
                child: selectedAvatarUrl == null
                    ? SvgPicture.asset(
                  'assets/icons/scheduling/booking/add_resource.svg',
                )
                    : null,
              ),
              const SizedBox(width: 15),
              if (showSeparator)
                Container(
                  width: 1,
                  height: 21,
                  color: const Color.fromRGBO(82, 82, 82, 0.6),
                ),
              if (showSeparator) const SizedBox(width: 7),
              if (!showSeparator)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedName!,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      selectedRole!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              if (showSeparator)
                ...widget.avatarUrls.map(
                      (url) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: GestureDetector(
                      onTap: () => _onAvatarTap(url),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(url),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          UnifiedContainerTile(
            title: 'Project',
            iconPath: 'assets/icons/scheduling/booking/projects.svg',
            interactionType: TileInteractionType.bottomSheet,
            bottomSheetContent: BottomSheetOptions(
              isSearchEnabled: true,
              title: 'Projects',
              options: ['FocusFlow', 'FitLoop', 'LearnMate', 'StreakSync'],
            ),
          ),
          const SizedBox(height: 12),
          UnifiedContainerTile(
            title: 'Task',
            iconPath: 'assets/icons/scheduling/booking/ddss.svg',
            interactionType: TileInteractionType.bottomSheet,
            bottomSheetContent: BottomSheetOptions(
              isSearchEnabled: true,
              title: 'Tasks',
              options: [
                'Task A',
                'Task B',
                'Task C',
                'Task D',
              ],
            ),
          ),
        ],
      ),
    );
  }
}
