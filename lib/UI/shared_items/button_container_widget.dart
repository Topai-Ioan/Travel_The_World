import 'package:flutter/material.dart';

class ButtonContainerWidget extends StatefulWidget {
  final TextStyle textStyle;
  final Color? backgroundColor;
  final String? text;
  final VoidCallback? onTapListener;

  const ButtonContainerWidget({
    super.key,
    this.text,
    this.onTapListener,
    required this.textStyle,
    this.backgroundColor,
  });

  @override
  ButtonContainerWidgetState createState() => ButtonContainerWidgetState();
}

class ButtonContainerWidgetState extends State<ButtonContainerWidget> {
  bool isButtonActive = true;

  void _onButtonPressed() {
    if (isButtonActive) {
      setState(() {
        isButtonActive = false;
      });

      if (widget.onTapListener != null) {
        widget.onTapListener!();
      }

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            isButtonActive = true;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onButtonPressed,
      child: Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            widget.text ?? "",
            style: widget.textStyle.copyWith(color: widget.textStyle.color),
          ),
        ),
      ),
    );
  }
}
