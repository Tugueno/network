import 'package:flutter/material.dart';
import 'package:liquid_glass_bar/liquid_glass_bar.dart' as lgb;
import 'package:ncapp/theme/app_theme.dart';

class LiquidGlassNavigationItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool destructive;
  final bool selected;

  const LiquidGlassNavigationItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.destructive = false,
    this.selected = false,
  });
}

class LiquidGlassNavigationBar extends StatefulWidget {
  final List<LiquidGlassNavigationItem> items;
  final int? currentIndex;
  final ValueChanged<int>? onItemSelected;
  final bool useSafeArea;
  final EdgeInsets safeAreaMinimum;
  final double? maxWidth;
  final double height;
  final double borderRadius;

  const LiquidGlassNavigationBar({
    super.key,
    required this.items,
    this.currentIndex,
    this.onItemSelected,
    this.useSafeArea = true,
    this.safeAreaMinimum = const EdgeInsets.fromLTRB(14, 0, 14, 18),
    this.maxWidth = 430,
    this.height = 62,
    this.borderRadius = 36,
  });

  @override
  State<LiquidGlassNavigationBar> createState() =>
      _LiquidGlassNavigationBarState();
}

class _LiquidGlassNavigationBarState extends State<LiquidGlassNavigationBar> {
  static const _selectedBlue = Color(0xFF0A84FF);
  static const _glassSettings = lgb.LiquidGlassSettings(
    glassColor: Color(0xB8FFFFFF),
    thickness: 28,
    blur: 16,
    chromaticAberration: 0.14,
    lightIntensity: 0.74,
    refractiveIndex: 1.34,
    saturation: 1.16,
    ambientStrength: 0.56,
    lightAngle: 0.78,
  );

  late int _selectedIndex = _initialSelectedIndex(widget.items);

  @override
  void didUpdateWidget(covariant LiquidGlassNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    final explicit =
        widget.currentIndex ?? widget.items.indexWhere((item) => item.selected);
    if (explicit >= 0 && explicit != _selectedIndex) {
      _selectedIndex = explicit;
    } else if (_selectedIndex >= widget.items.length) {
      _selectedIndex = _initialSelectedIndex(widget.items);
    }
  }

  static int _initialSelectedIndex(List<LiquidGlassNavigationItem> items) {
    if (items.isEmpty) return 0;
    final explicit = items.indexWhere((item) => item.selected);
    if (explicit >= 0) return explicit;
    return (items.length / 2).floor().clamp(0, items.length - 1);
  }

  void _handleTap(int index) {
    if (index < 0 || index >= widget.items.length) return;
    setState(() => _selectedIndex = index);
    widget.onItemSelected?.call(index);
    widget.items[index].onTap();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.length < 2) return const SizedBox.shrink();

    final bar = Center(
      heightFactor: 1,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: widget.maxWidth ?? double.infinity,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.16),
                blurRadius: 30,
                spreadRadius: -9,
                offset: const Offset(0, 16),
              ),
              BoxShadow(
                color: AppTheme.primary.withValues(alpha: 0.10),
                blurRadius: 22,
                spreadRadius: -12,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: lgb.LiquidGlassBar(
            items: [
              for (final item in widget.items)
                lgb.LiquidGlassBarItem(iconData: item.icon, label: item.label),
            ],
            currentIndex: _selectedIndex,
            onTap: _handleTap,
            style: lgb.LiquidGlassBarStyle(
              liquidGlassSettings: _glassSettings,
              activeColor: widget.items[_selectedIndex].destructive
                  ? AppTheme.error
                  : _selectedBlue,
              inactiveColor: const Color(0xFF17191D),
              borderRadius: widget.borderRadius,
              height: widget.height,
              padding: EdgeInsets.zero,
              animationDuration: const Duration(milliseconds: 260),
              animationCurve: Curves.easeOutCubic,
              iconSize: 25,
              selectedIconScale: 1.08,
              labelStyle: const TextStyle(
                fontSize: 10.5,
                height: 1.05,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );

    if (!widget.useSafeArea) return bar;

    return SafeArea(top: false, minimum: widget.safeAreaMinimum, child: bar);
  }
}
