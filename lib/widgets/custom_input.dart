import 'package:flutter/material.dart';

class Custominput extends StatelessWidget {
  final String hintText;
  final Function(String) onChanged;
  final Function(String) onSubmitted;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final bool isPasswordField;
  Custominput(
      {this.hintText,
      this.onChanged,
      this.onSubmitted,
      this.focusNode,
      this.textInputAction,
      this.isPasswordField});
  @override
  Widget build(BuildContext context) {
    bool _isPasswordField = isPasswordField ?? false;

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 24.0,
      ),
      decoration: BoxDecoration(
          color: Color(0xFFF2F2F2), borderRadius: BorderRadius.circular(12)),
      child: TextField(
          obscureText: _isPasswordField,
          focusNode: focusNode,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          textInputAction: textInputAction,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText ?? 'Hint Text...',
              contentPadding: EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 18.0,
              )),
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black)),
    );
  }
}
