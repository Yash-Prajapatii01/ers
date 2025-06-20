import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;

  // final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final bool autofocus;
  final InputDecoration? decoration;
  final String? regex;
  final double? maxInputLength;
  final double? minInputLength;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final int? minLines;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.onChanged,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    // this.validator,
    this.regex,
    this.focusNode,
    this.autofocus = false,
    this.decoration,
    this.maxInputLength,
    this.minInputLength,
    this.textInputAction,
    this.maxLines = 1,
    this.minLines,
    this.inputFormatters,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 16.w),
      child: TextFormField(
        validator: (value) {
          final input = value ?? '';
          final minLength = widget.minInputLength?.toInt() ?? 0;
          final maxLength = widget.maxInputLength?.toInt();

          if (input.length < minLength) {
            return 'Minimum $minLength characters required';
          }

          if (maxLength != null && input.length > maxLength) {
            return 'Maximum $maxLength characters allowed';
          }

          if (widget.regex != null) {
            final regex = RegExp(widget.regex!);
            if (!regex.hasMatch(input)) {
              return 'Invalid input format';
            }
          }
          return null;
        },
        autovalidateMode: AutovalidateMode.always,
        style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w400),
        controller: _controller,
        inputFormatters: widget.inputFormatters,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        textInputAction: widget.textInputAction,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        decoration:
            (widget.decoration ??
                InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  suffixIcon:
                      _controller.text.isNotEmpty
                          ? GestureDetector(
                            onTap:
                                () => setState(() {
                                  _controller.clear();
                                  widget.onChanged?.call('');
                                }),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SvgPicture.asset(
                                'assets/icons/scheduling/booking/close.svg',
                                width: 16.w,
                                height: 16.h,
                                fit: BoxFit.contain,
                              ),
                            ),
                          )
                          : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 11.5.h,
                  ),
                )),
        onChanged: (value) {
          setState(() {});
          widget.onChanged?.call(value);
        },
      ),
    );
  }
}
