import 'package:flutter/material.dart';

class LikeAnimationWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final bool isAnimating;
  final VoidCallback? onAnimationComplete;

  const LikeAnimationWidget(
      {Key? key,
      required this.child,
      required this.duration,
      required this.isAnimating,
      this.onAnimationComplete})
      : super(key: key);

  @override
  State<LikeAnimationWidget> createState() => _LikeAnimationWidgetState();
}

class _LikeAnimationWidgetState extends State<LikeAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: widget.duration.inMilliseconds ~/ 2));
    scale = Tween<double>(begin: 1, end: 1.2).animate(_controller);
  }

  @override
  void didUpdateWidget(covariant LikeAnimationWidget oldWidget) {
    if (widget.isAnimating != oldWidget.isAnimating) {
      beginLikeAnimation();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    // Your custom disposal logic goes here, if needed
    _controller.dispose();
    super.dispose(); // Call super.dispose() at the end
  }

  beginLikeAnimation() async {
    if (widget.isAnimating) {
      await _controller.forward();
      await _controller.reverse();
      await Future.delayed(const Duration(milliseconds: 200));
      if (widget.onAnimationComplete != null) {
        widget.onAnimationComplete!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: widget.child,
    );
  }
}
