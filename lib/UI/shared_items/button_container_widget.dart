import 'package:flutter/material.dart';

class ButtonContainerWidget extends StatefulWidget {
  final Color? color;
  final Color? textColor;
  final String? text;
  final VoidCallback? onTapListener;
  final FontWeight? fontWeight;

  const ButtonContainerWidget({
    Key? key,
    this.color,
    this.text,
    this.textColor,
    this.fontWeight,
    this.onTapListener,
  }) : super(key: key);

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
          color: widget.color,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            widget.text ?? "",
            style: TextStyle(
              color: isButtonActive
                  ? widget.textColor
                  : widget.textColor?.withOpacity(0.5),
              fontWeight: widget.fontWeight ?? FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
