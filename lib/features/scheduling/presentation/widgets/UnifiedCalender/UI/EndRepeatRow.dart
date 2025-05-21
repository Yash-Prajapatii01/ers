import 'package:flutter/material.dart';
class EndRepeatRow extends StatelessWidget {
  final List<String> options;
  final String label, value;
  final String selectedValue;
  final ValueChanged<String> onSelected;

  const EndRepeatRow({
    super.key,
    required this.options,
    required this.label,
    required this.value,
    required this.selectedValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final RenderBox box = context.findRenderObject() as RenderBox;
        final Offset offset = box.localToGlobal(Offset.zero);
        final Size size = box.size;
        final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

        // Popup menu positioned above the widget
        final RelativeRect pos = RelativeRect.fromLTRB(
          offset.dx + size.width - 200,
          offset.dy - (51.2 * options.length) - 10.5,
          overlay.size.width - offset.dx - size.width - 16.5,
          offset.dy,
        );

        final items = <PopupMenuEntry<String>>[];

        for (var i = 0; i < options.length; i++) {
          items.add(
            PopupMenuItem<String>(
              // padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              height: 48, // Based on 10 vertical padding + font height
              value: options[i],
              child: SizedBox(
                width: 170,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // const SizedBox(width: 8), // Left margin before icon
                    if (options[i] == selectedValue)
                      const Icon(Icons.check, size: 16, color: Colors.black)
                    else
                      const SizedBox(width: 16),
                    // Placeholder to align text
                    const SizedBox(width: 4),
                    // Right margin after icon
                    // const SizedBox(width: 0), // Optional: spacing fine-tuning
                    Expanded(
                      child: Text(
                        options[i],
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(39, 39, 39, 1),
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
                enabled: false, // Prevent selection
                height: 0.7,
                padding: EdgeInsets.zero,
                child: Container(
                  height: 0.7,
                  color: const Color.fromRGBO(102, 112, 133, 0.2),
                ),
              ),
            );
          }
        }

        final choice = await showMenu<String>(
          context: context,
          position: pos,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          elevation: 4,
          items: items,
        );
        if (choice != null) onSelected(choice);
      },
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Text(label, style: const TextStyle(fontSize: 16, fontFamily: 'Inter')),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(fontSize: 16, color: Color(0xFF444444), fontFamily: 'Inter'),
            ),
            // const SizedBox(width: 4),
            Padding(
              padding: EdgeInsets.fromLTRB(8.0, 5.0, 0, 5.0),
              child: Image.asset(
                'assets/icons/scheduling/booking/img.png',
                width: 8,
                height: 20,
              ),
              // child: SvgPicture.asset('assets/icons/scheduling/booking/updownarrow.svg'),
            ),
            // const Icon(CupertinoIcons.chevron_up_chevron_down, size: 20 , color: Color.fromRGBO(102, 112, 133, 0.5),),
          ],
        ),
      ),
    );
  }
}