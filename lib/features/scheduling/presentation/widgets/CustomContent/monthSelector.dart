import 'package:flutter/material.dart';
class MonthSelector extends StatelessWidget {
  /// Now a set of selected month abbreviations
  final Set<String> selectedMonths;
  /// Emits the new set whenever the user toggles one
  final ValueChanged<Set<String>> onChanged;

  const MonthSelector({
    Key? key,
    required this.selectedMonths,
    required this.onChanged,
  }) : super(key: key);

  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr',
    'May', 'Jun', 'Jul', 'Aug',
    'Sep', 'Oct', 'Nov', 'Dec'
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(3, (rowIndex) {
        final start = rowIndex * 4;
        final end = start + 4;
        final rowItems = _months.sublist(start, end);

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(4, (colIndex) {
            final month = rowItems[colIndex];
            final isSelected = selectedMonths.contains(month);

            return GestureDetector(
              onTap: () {
                final newSet = Set<String>.from(selectedMonths);
                if (isSelected) {
                  newSet.remove(month);
                } else {
                  newSet.add(month);
                }
                onChanged(newSet);
              },
              child: Container(
                width: 77,
                height: isSelected ? 36 : 44,
                margin: EdgeInsets.only(
                    left:  colIndex == 0 ? 0 : 11.5,
                    right: colIndex == 3 ? 0 : 11.5,
                    top: isSelected? 4 : 0,
                    bottom: isSelected? 4 : 0
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color.fromRGBO(28, 121, 212, 1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  month,
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ),
            );
          }),
        );
      }),
    );
  }
}