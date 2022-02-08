import 'package:flutter/material.dart';

class PulsingWidget extends StatefulWidget {
  final Widget child;

  const PulsingWidget({required this.child}) : assert(child != null);
  _PulsingWidget createState() => _PulsingWidget();
}

class _PulsingWidget extends State<PulsingWidget> with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Duration _duration = const Duration(milliseconds: 1000);
  Tween<double> _tween = Tween(begin: 0.975, end: 1.025);
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();


    _animationController = AnimationController(
      vsync: this,
      duration: _duration,
    );
    final CurvedAnimation curve = CurvedAnimation(
      parent: _animationController!,
      curve: Curves.linear,
    );
    _animation = _tween.animate(curve);
    _animation!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController!.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _animationController!.forward();
      }
    });
    _animationController!.forward();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation!,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }
}