import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationHelper {
  /// Navigate to a route, using context.go() for web and context.push() for mobile
  static void navigateTo(BuildContext context, String route, {Object? extra}) {
    if (kIsWeb) {
      context.go(route, extra: extra);
    } else {
      context.push(route, extra: extra);
    }
  }

  /// Navigate back, using context.go() for web and context.pop() for mobile
  static void navigateBack(BuildContext context) {
    if (kIsWeb) {
      // For web, go back to previous route in history
      if (context.canPop()) {
        context.pop();
      } else {
        // If can't pop, go to dashboard
        context.go('/dash_board');
      }
    } else {
      context.pop();
    }
  }
}
