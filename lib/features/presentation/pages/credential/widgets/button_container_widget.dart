import 'package:flutter/material.dart';

class ButtonContainerWidget extends StatefulWidget {
  final Color? color;
  final String? text;
  final VoidCallback? onTapListener;

  const ButtonContainerWidget({
    Key? key,
    this.color,
    this.text,
    this.onTapListener,
  }) : super(key: key);

  @override
  _ButtonContainerWidgetState createState() => _ButtonContainerWidgetState();
}

class _ButtonContainerWidgetState extends State<ButtonContainerWidget> {
  bool isButtonActive = true;

  void _onButtonPressed() {
    if (isButtonActive) {
      setState(() {
        isButtonActive = false; // Disable the button
      });

      if (widget.onTapListener != null) {
        widget.onTapListener!();
      }

      // Enable the button after a delay (2 seconds in this case)
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            isButtonActive = true; // Re-enable the button
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
              color: isButtonActive ? Colors.white : Colors.white60,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
