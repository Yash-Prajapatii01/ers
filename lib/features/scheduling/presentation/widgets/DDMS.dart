import 'package:flutter/material.dart';

class DDMSSelectableList extends StatelessWidget {
  final List<String> options;
  final List<String> selectedItems;
  final ValueChanged<List<String>> onSelectionChanged;
  final bool showCheckboxes;

  const DDMSSelectableList({super.key,
    required this.options,
    required this.selectedItems,
    required this.onSelectionChanged,
    this.showCheckboxes = true,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (selectedItems.isNotEmpty && showCheckboxes)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    selectedItems.map((item) {
                      return Container(
                        margin: const EdgeInsets.only(right: 4),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: Color.fromRGBO(0, 0, 0, 0.12),
                          ),
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
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
                                  final newSel = List<String>.from(
                                    selectedItems,
                                  )..remove(item);
                                  onSelectionChanged(newSel);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                      width: 1,
                                    ),
                                    color: Color.fromRGBO(233, 233, 233, 1),
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.separated(
                separatorBuilder:
                    (_, __) => const Divider(
                      height: 0.5,
                      color: Color.fromRGBO(0, 0, 0, 0.12),
                    ),
                itemCount: options.length,
                padding: EdgeInsets.zero,
                itemBuilder: (ctx, i) {
                  final opt = options[i];
                  final isSel = selectedItems.contains(opt);
                  if (showCheckboxes) {
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          final newSel = List<String>.from(selectedItems);
                          if (isSel) {
                            newSel.remove(opt);
                          } else {
                            newSel.add(opt);
                          }
                          onSelectionChanged(newSel);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            children: [
                              // Checkbox
                              Theme(
                                data: Theme.of(context).copyWith(
                                  checkboxTheme: CheckboxThemeData(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    side: const BorderSide(
                                      color: Color.fromRGBO(39, 39, 39, 1),
                                      width: 1,
                                    ),
                                    fillColor: WidgetStateProperty.resolveWith<
                                      Color
                                    >((states) {
                                      if (states.contains(
                                        WidgetState.selected,
                                      )) {
                                        return Color.fromRGBO(28, 121, 212, 1);
                                      }
                                      return Colors.white;
                                    }),
                                    checkColor: WidgetStateProperty.all<Color>(
                                      Colors.white,
                                    ),
                                    // Check mark color
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                ),
                                child: SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: Checkbox(
                                    value: isSel,
                                    onChanged: (b) {
                                      final newSel = List<String>.from(
                                        selectedItems,
                                      );
                                      if (b == true) {
                                        newSel.add(opt);
                                      } else {
                                        newSel.remove(opt);
                                      }
                                      onSelectionChanged(newSel);
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              // Text
                              Expanded(
                                child: Text(
                                  opt,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    // New non-checkbox multiple selection mode with check icons on right
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          final newSel = List<String>.from(selectedItems);
                          if (isSel) {
                            newSel.remove(opt);
                          } else {
                            newSel.add(opt);
                          }
                          onSelectionChanged(newSel);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  opt,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              if (isSel)
                                const Icon(Icons.check, color: Colors.black),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class CustomCheckbox extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool> onChanged;

  const CustomCheckbox({
    Key? key,
    required this.initialValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  late bool isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = widget.initialValue;
  }

  void _toggleCheckbox() {
    setState(() => isChecked = !isChecked);
    widget.onChanged(isChecked);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){},
      child: Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(
          color: isChecked ? Colors.blue : Colors.transparent,
          border: Border.all(
            color: Colors.grey,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
              Icons.check,
              size: 10,
              color: Colors.white,),
      ),
    );
  }
}

