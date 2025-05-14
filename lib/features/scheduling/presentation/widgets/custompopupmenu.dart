import 'package:flutter/material.dart';

class CustomPopupMenu {
  static Future<String?> show({
    required BuildContext context,
    required List<String> options,
    GlobalKey? widgetKey,
    required String? selectedOption,
    required void Function(String selected)? onSelected,
    double width = 170,
    double itemHeight = 48,
    double separatorHeight = 0.7,
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
    double verticalOffset = 7.0,
    bool isReverse = false,
  }) async {
    if (options.isEmpty) return null;

    final RenderBox box = widgetKey?.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = box.localToGlobal(Offset.zero);
    final Size size = box.size;

    final RenderBox overlay =
    Overlay.of(context).context.findRenderObject() as RenderBox;

    final RelativeRect position = isReverse
        ? RelativeRect.fromLTRB(
      offset.dx + size.width - width,
      offset.dy - ((itemHeight + separatorHeight) * options.length) - 10.0,
      overlay.size.width - offset.dx - size.width,
      offset.dy,
    )
        : RelativeRect.fromLTRB(
      offset.dx,
      offset.dy + size.height + verticalOffset,
      overlay.size.width - offset.dx - size.width - 10,
      offset.dy,
    );

    final items = <PopupMenuEntry<String>>[];

    for (int i = 0; i < options.length; i++) {
      final opt = options[i];

      items.add(
        PopupMenuItem<String>(
          padding: padding,
          height: itemHeight,
          value: opt,
          child: SizedBox(
            width: width,
            child: Row(
              children: [
                if (opt == selectedOption)
                  const Icon(Icons.check, size: 16, color: Colors.black)
                else
                  const SizedBox(width: 16),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    opt,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: opt == selectedOption
                          ? FontWeight.w400
                          : FontWeight.normal,
                      color: const Color.fromRGBO(39, 39, 39, 1),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      if (i < options.length - 1) {
        items.add(
          PopupMenuItem<String>(
            enabled: false,
            height: separatorHeight,
            padding: EdgeInsets.zero,
            child: Container(
              height: separatorHeight,
              color: const Color.fromRGBO(102, 112, 133, 0.2),
            ),
          ),
        );
      }
    }

    final choice = await showMenu<String>(
      context: context,
      position: position,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      elevation: 4,
      items: items,
    );

    if (choice != null && choice != selectedOption) {
      onSelected?.call(choice);
    }

    return choice;
  }
}
