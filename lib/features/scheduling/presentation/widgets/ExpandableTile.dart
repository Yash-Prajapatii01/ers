import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ExpandableTile extends StatefulWidget {
  final String title;
  final String iconPath;

  const ExpandableTile({
    super.key,
    required this.title,
    required this.iconPath,
  });

  @override
  State<ExpandableTile> createState() => _ExpandableTileState();
}

class _ExpandableTileState extends State<ExpandableTile> {
  bool isExpanded = false;
  double sliderValue = 0; // 0 to 100

  void toggleExpand() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleExpand,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(widget.iconPath),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    '${sliderValue.toInt()}%',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color.fromRGBO(102, 112, 133, 0.5),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Icon(
                  isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: Colors.grey,
                ),
              ],
            ),
            if (isExpanded) ...[
              const SizedBox(height: 16),
              const Divider(thickness: 1, color: Color(0xFFE0E0E0)),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text(
                    'Your progress',
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const Spacer(),
                  Text(
                    '${sliderValue.toInt()}%',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff0072C3),
                    ),
                  ),
                ],
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: const Color(0xff1C79D4),
                  inactiveTrackColor: const Color(0xffF4F4F4),
                  thumbColor: Colors.white,
                  overlayColor: const Color(0x330B5FFF),
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 13.5),
                  trackHeight: 4,
                ),
                child: Slider(
                  value: sliderValue,
                  min: 0,
                  max: 100,
                  divisions: 100,
                  onChanged: (value) {
                    setState(() {
                      sliderValue = value;
                    });
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
