import 'package:ers_linux/features/scheduling/presentation/widgets/shared/CustomTextField.dart';
import 'package:flutter/material.dart';

class CustomRateSheet extends StatefulWidget {
  const CustomRateSheet({super.key});

  @override
  _CustomRateSheetState createState() => _CustomRateSheetState();
}

class _CustomRateSheetState extends State<CustomRateSheet> {
  final TextEditingController _customRatePerHourController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          controller: _customRatePerHourController,
          hintText: "Enter the custom rate per hour",
        ),
      ],
    );
  }
}
