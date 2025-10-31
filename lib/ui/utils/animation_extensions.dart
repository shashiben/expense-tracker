import 'package:flutter/material.dart';

extension WidgetAnimationX on Widget {
  Widget fadeIn({
    Duration duration = const Duration(milliseconds: 360),
    Duration delay = Duration.zero,
    Curve curve = Curves.easeOutCubic,
  }) {
    return _DelayedTween(
      delay: delay,
      duration: duration,
      builder: (t) => Opacity(opacity: t, child: this),
      curve: curve,
    );
  }

  Widget fadeSlide({
    Offset beginOffset = const Offset(0, 16),
    Duration duration = const Duration(milliseconds: 460),
    Duration delay = Duration.zero,
    Curve curve = Curves.easeOutCubic,
  }) {
    return _DelayedTween(
      delay: delay,
      duration: duration,
      curve: curve,
      builder: (t) => Opacity(
        opacity: t,
        child: Transform.translate(
          offset: Offset.lerp(beginOffset, Offset.zero, t)!,
          child: this,
        ),
      ),
    );
  }
}

class _DelayedTween extends StatefulWidget {
  final Duration delay;
  final Duration duration;
  final Curve curve;
  final Widget Function(double t) builder;

  const _DelayedTween({
    required this.delay,
    required this.duration,
    required this.builder,
    this.curve = Curves.linear,
  });

  @override
  State<_DelayedTween> createState() => _DelayedTweenState();
}

class _DelayedTweenState extends State<_DelayedTween>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );
  late final Animation<double> _anim = CurvedAnimation(
    parent: _controller,
    curve: widget.curve,
  );

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, _) => widget.builder(_anim.value),
    );
  }
}
