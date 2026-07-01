class AppBreakpoints {
  const AppBreakpoints._();

  static const double compact = 600;
  static const double splitPane = 720;
  static const double desktop = 1200;

  static const double shellListPaneWidth = 380;
  static const double paymentListPaneWidth = 455;
  static const double maxShellWidth = 1600;

  static bool isCompact(double width) => width < compact;
  static bool supportsSplitPane(double width) => width >= splitPane;
  static bool isDesktop(double width) => width >= desktop;
  static bool shouldOpenDetailInRoute(double width) => width < splitPane;
}
