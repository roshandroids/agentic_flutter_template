import 'package:flutter/widgets.dart';

/// Width breakpoints - the values themselves, kept separate from the enum
/// below so a consuming app can reference the raw numbers (e.g. for a
/// custom layout) without needing [deviceTypeOf].
abstract final class AppBreakpoints {
  static const double tablet = 600;
  static const double desktop = 1024;
}

enum DeviceType { mobile, tablet, desktop }

/// Classifies the current width into a [DeviceType] - the single place
/// every adaptive layout decision in the app should read from, so bumping
/// a breakpoint is a one-file change.
DeviceType deviceTypeOf(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  if (width >= AppBreakpoints.desktop) return DeviceType.desktop;
  if (width >= AppBreakpoints.tablet) return DeviceType.tablet;
  return DeviceType.mobile;
}

/// Picks one of three builders based on the current [DeviceType] - the
/// standard shape for "this screen looks structurally different on
/// desktop," as opposed to a `LayoutBuilder` reimplemented per screen.
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    required this.mobile,
    super.key,
    this.tablet,
    this.desktop,
  });

  final WidgetBuilder mobile;

  /// Falls back to [mobile] if not provided.
  final WidgetBuilder? tablet;

  /// Falls back to [tablet], then [mobile], if not provided.
  final WidgetBuilder? desktop;

  @override
  Widget build(BuildContext context) {
    switch (deviceTypeOf(context)) {
      case DeviceType.desktop:
        return (desktop ?? tablet ?? mobile)(context);
      case DeviceType.tablet:
        return (tablet ?? mobile)(context);
      case DeviceType.mobile:
        return mobile(context);
    }
  }
}
