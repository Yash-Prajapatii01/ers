import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../shared/theme/app_colors.dart';

class OTPInputField extends StatefulWidget {
  final TextEditingController controller;
  final int length;

  const OTPInputField({super.key, required this.controller, this.length = 6});

  @override
  State<OTPInputField> createState() => _OTPInputFieldState();
}

class _OTPInputFieldState extends State<OTPInputField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    widget.controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Widget _buildOTPBox(int index) {
    final text = widget.controller.text;
    final isActive = index == text.length;

    return Container(
      width: 45,
      height: 50,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: index < text.length ? AppColors.primary : AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isActive ? AppColors.black : AppColors.buttonDisable,
          width: 1.5,
        ),
      ),
      child:
          index < text.length
              ? Text(
                text[index],
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              )
              : Text(
                '-',
                style: TextStyle(fontSize: 20, color: AppColors.lightText),
              ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_focusNode),
      child: Stack(
        alignment: Alignment.center,
        children: [

          Opacity(
            opacity: 0.0,
            child: TextField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(6),
                FilteringTextInputFormatter.digitsOnly,
              ],
              focusNode: _focusNode,
              controller: widget.controller,
              keyboardType: TextInputType.number,
              maxLength: widget.length,
              style: const TextStyle(letterSpacing: 32),
              // Space out a bit
              decoration: const InputDecoration(
                border: InputBorder.none,
                counterText: "",
              ),
            ),
          ),
          // Custom OTP UI
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.length, _buildOTPBox),
          ),
        ],
      ),
    );
  }
}
