import 'package:flutter/material.dart';

class Bottom2TopRouter<T> extends PageRouteBuilder<T> {
  final Widget child;
  final int duration_ms;
  final Curve curve;

  Bottom2TopRouter(
      {this.child, this.duration_ms = 500, this.curve = Curves.fastOutSlowIn})
      : super(
            transitionDuration: Duration(milliseconds: duration_ms),
            pageBuilder: (ctx, c1, c2) {
              return child;
            },
            transitionsBuilder: (ctx, c1, c2, Widget child) {
              return SlideTransition(
                position: Tween(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
                    .animate(CurvedAnimation(parent: c1, curve: curve)),
                child: child,
              );
            });
}
