import 'package:ers_linux/features/scheduling/presentation/widgets/containerTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'CustomTextfield.dart';
import 'DateSelector.dart';

class PopupmenuTile extends StatefulWidget {
  final String title;
  final String iconPath;
  final String itemText;
  final List<String> options;
  final bool? isPinTextNeeded;

  const PopupmenuTile({
    super.key,
    required this.title,
    required this.iconPath,
    required this.options,
    this.isPinTextNeeded = false,
    this.itemText = '',
  });

  @override
  State<PopupmenuTile> createState() => _PopupmenuTileState();
}

class _PopupmenuTileState extends State<PopupmenuTile> {
  late String selectedValueDropdown;
  String textFieldValue = '';

  @override
  void initState() {
    super.initState();
    selectedValueDropdown = '';
  }

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
    return Container(
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
          SvgPicture.asset(widget.iconPath),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF212121),
              ),
            ),
          ),
          (widget.isPinTextNeeded!)
              ? GestureDetector(
                onTap:
                    () => showCustomBottomSheet(
                      context,
                      BottomSheetOptions(
                        isDonethere: true,
                        isTextFieldNeeded: true,
                        customTextField: CustomTextField(
                          hintText: 'Effort',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                child: PillText(
                  textFieldValue.isNotEmpty ? textFieldValue : "Add",
                  Colors.black,
                ),
              )
              : Spacer(),
          (widget.isPinTextNeeded!)?
          InkWell(
            onTap: () async {
              final RenderBox box = context.findRenderObject() as RenderBox;
              final Offset offset = box.localToGlobal(Offset.zero);
              final Size size = box.size;
              final RenderBox overlay =
                  Overlay.of(context).context.findRenderObject() as RenderBox;

              final RelativeRect pos = RelativeRect.fromLTRB(
                offset.dx + size.width - 200,
                offset.dy - (65.0 * widget.options.length) - 5.0,
                overlay.size.width - offset.dx - size.width,
                offset.dy,
              );

              final items = <PopupMenuEntry<String>>[];
              for (var i = 0; i < widget.options.length; i++) {
                if (i > 0) items.add(const PopupMenuDivider());
                items.add(
                  PopupMenuItem<String>(
                    value: widget.options[i],
                    child: Text(
                      widget.options[i],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            widget.options[i] == selectedValueDropdown
                                ? FontWeight.w500
                                : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }

              final choice = await showMenu<String>(
                context: context,
                position: pos,
                items: items,
              );

              if (choice != null && choice != selectedValueDropdown) {
                setState(() {
                  selectedValueDropdown = choice;
                });
              }
            },
            child: Row(
              children: [
                const SizedBox(width: 8),
                PillText(selectedValueDropdown.isEmpty? widget.options[0] : selectedValueDropdown, Colors.black),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ) : InkWell(
            onTap: () async {
              final RenderBox box = context.findRenderObject() as RenderBox;
              final Offset offset = box.localToGlobal(Offset.zero);
              final Size size = box.size;
              final RenderBox overlay =
              Overlay.of(context).context.findRenderObject() as RenderBox;

              final RelativeRect pos = RelativeRect.fromLTRB(
                offset.dx + size.width - 200,
                offset.dy - (65.0 * widget.options.length) - 5.0,
                overlay.size.width - offset.dx - size.width,
                offset.dy,
              );

              final items = <PopupMenuEntry<String>>[];
              for (var i = 0; i < widget.options.length; i++) {
                if (i > 0) items.add(const PopupMenuDivider());
                items.add(
                  PopupMenuItem<String>(
                    value: widget.options[i],
                    child: Text(
                      widget.options[i],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                        widget.options[i] == selectedValueDropdown
                            ? FontWeight.w500
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }

              final choice = await showMenu<String>(
                context: context,
                position: pos,
                items: items,
              );

              if (choice != null && choice != selectedValueDropdown) {
                setState(() {
                  selectedValueDropdown = choice;
                });
              }
            },
            child: Row(
              children: [
                Text(selectedValueDropdown.isEmpty ? "Select" : selectedValueDropdown, style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey
                ),),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
