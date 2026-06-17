import 'package:flutter/material.dart';

class AppCard extends StatelessWidget{
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double radius;
  final bool clip;
  final double? width;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.radius = 16,
    this.clip = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: padding,
      margin: margin,
      clipBehavior: clip ? Clip.antiAlias : Clip.none,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: child,
    );
  }
}