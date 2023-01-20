import 'package:flutter/material.dart';

class LikeAnimation extends StatefulWidget {
  const LikeAnimation({
    super.key,
    required this.child,
    required this.isAnimating,
    this.onEnd,
    this.duration = const Duration(milliseconds: 150),
    this.isSmallLike = false,
  });
  final Widget child;
  final bool isAnimating;
  final bool isSmallLike;
  final Duration duration;
  final VoidCallback? onEnd;

  @override
  State<LikeAnimation> createState() => _LikeAnimationState();
}

class _LikeAnimationState extends State<LikeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: widget.duration.inMilliseconds ~/ 2,
      ),
    );
    scale = Tween<double>(
      begin: 1,
      end: 1.2,
    ).animate(_controller);
  }

  @override
  void didUpdateWidget(covariant LikeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isAnimating != oldWidget.isAnimating) {
      startAnimation();
    }
  }

  startAnimation() async {
    if (widget.isAnimating || widget.isSmallLike) {
      _controller.forward();
      _controller.reverse();
      await Future.delayed(
        const Duration(milliseconds: 400),
      );
      if (widget.onEnd != null) {
        widget.onEnd!();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: widget.child,
    );
  }
}
