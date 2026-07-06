import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LiquidGlassTabIndicatorState {
  final double position;
  final int activeIndex;
  final bool animate;
  final double stretch;
  final int reactionId;

  const LiquidGlassTabIndicatorState({
    required this.position,
    required this.activeIndex,
    required this.animate,
    this.stretch = 0,
    this.reactionId = 0,
  });

  const LiquidGlassTabIndicatorState.centered(int index)
    : position = index * 1.0,
      activeIndex = index,
      animate = false,
      stretch = 0,
      reactionId = 0;
}

class LiquidGlassNavigationItem {
  final String symbolName;
  final String? selectedSymbolName;
  final IconData fallbackIcon;
  final IconData? selectedFallbackIcon;
  final String label;
  final VoidCallback onTap;
  final bool destructive;

  const LiquidGlassNavigationItem({
    required this.symbolName,
    required this.fallbackIcon,
    required this.label,
    required this.onTap,
    this.selectedSymbolName,
    this.selectedFallbackIcon,
    this.destructive = false,
  });
}

class LiquidGlassNavigationBar extends StatelessWidget {
  final List<LiquidGlassNavigationItem> items;
  final ValueListenable<LiquidGlassTabIndicatorState> indicatorState;
  final ValueChanged<int>? onItemSelected;
  final bool useSafeArea;
  final EdgeInsets safeAreaMinimum;
  final double? maxWidth;
  final double height;
  final double borderRadius;
  final Color? tint;
  final Color? backgroundColor;

  const LiquidGlassNavigationBar({
    super.key,
    required this.items,
    required this.indicatorState,
    this.onItemSelected,
    this.useSafeArea = true,
    this.safeAreaMinimum = const EdgeInsets.fromLTRB(14, 0, 14, 18),
    this.maxWidth = 430,
    this.height = 85,
    this.borderRadius = 36,
    this.tint,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    if (items.length < 2) return const SizedBox.shrink();

    final trailingItem = items.last.destructive ? items.last : null;
    final tabItems = trailingItem == null
        ? items
        : items.sublist(0, items.length - 1);

    Widget bar = ValueListenableBuilder<LiquidGlassTabIndicatorState>(
      valueListenable: indicatorState,
      builder: (context, state, _) {
        final currentIndex = state.activeIndex
            .clamp(0, tabItems.length - 1)
            .toInt();

        return _LiquidGlassFallbackTabBar(
          items: tabItems,
          trailingItem: trailingItem,
          currentIndex: currentIndex,
          height: height,
          borderRadius: borderRadius,
          backgroundColor: backgroundColor,
          onTap: _handleTap,
        );
      },
    );

    if (maxWidth != null) {
      bar = ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth!),
        child: bar,
      );
    }

    bar = Align(alignment: Alignment.bottomCenter, heightFactor: 1, child: bar);

    if (!useSafeArea) return bar;

    return SafeArea(top: false, minimum: safeAreaMinimum, child: bar);
  }

  void _handleTap(int index) {
    if (index < 0 || index >= items.length) return;
    HapticFeedback.selectionClick();
    onItemSelected?.call(index);
    items[index].onTap();
  }
}

class _LiquidGlassFallbackTabBar extends StatelessWidget {
  final List<LiquidGlassNavigationItem> items;
  final LiquidGlassNavigationItem? trailingItem;
  final int currentIndex;
  final double height;
  final double borderRadius;
  final Color? backgroundColor;
  final ValueChanged<int> onTap;

  const _LiquidGlassFallbackTabBar({
    required this.items,
    required this.trailingItem,
    required this.currentIndex,
    required this.height,
    required this.borderRadius,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final trailingItem = this.trailingItem;
    final trailingIndex = items.length;

    return SizedBox(
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _LiquidGlassPillSurface(
              borderRadius: borderRadius,
              backgroundColor: backgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    for (var index = 0; index < items.length; index++)
                      Expanded(
                        child: _LiquidGlassFallbackTabItem(
                          item: items[index],
                          selected: index == currentIndex,
                          onTap: () => onTap(index),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          if (trailingItem != null) ...[
            const SizedBox(width: 16),
            SizedBox.square(
              dimension: height,
              child: _LiquidGlassPillSurface(
                borderRadius: borderRadius,
                backgroundColor: backgroundColor,
                child: _LiquidGlassFallbackTabItem(
                  item: trailingItem,
                  selected: false,
                  iconOnly: true,
                  onTap: () => onTap(trailingIndex),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _LiquidGlassPillSurface extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final Color? backgroundColor;

  const _LiquidGlassPillSurface({
    required this.child,
    required this.borderRadius,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fill =
        backgroundColor ??
        (isDark
            ? CupertinoColors.white.withValues(alpha: 0.16)
            : CupertinoColors.white.withValues(alpha: 0.20));
    final borderColor = isDark
        ? CupertinoColors.white.withValues(alpha: 0.12)
        : CupertinoColors.white.withValues(alpha: 0.42);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 20,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              color: fill,
              border: Border.all(color: borderColor, width: 0.8),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _LiquidGlassFallbackTabItem extends StatelessWidget {
  final LiquidGlassNavigationItem item;
  final bool selected;
  final bool iconOnly;
  final VoidCallback onTap;

  const _LiquidGlassFallbackTabItem({
    required this.item,
    required this.selected,
    required this.onTap,
    this.iconOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = selected
        ? CupertinoColors.systemBlue
        : (isDark
              ? CupertinoColors.white.withValues(alpha: 0.62)
              : CupertinoColors.black.withValues(alpha: 0.50));
    final labelColor = isDark
        ? CupertinoColors.white.withValues(alpha: 0.82)
        : CupertinoColors.black;
    final icon = selected
        ? item.selectedFallbackIcon ?? item.fallbackIcon
        : item.fallbackIcon;
    final selectedFill = isDark
        ? CupertinoColors.white.withValues(alpha: 0.12)
        : const Color(0xFFEDEDED);

    return Semantics(
      button: true,
      selected: selected && !iconOnly,
      label: item.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: selected ? selectedFill : Colors.transparent,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: iconOnly ? 8 : 6,
            vertical: iconOnly ? 8 : 7,
          ),
          child: iconOnly
              ? Center(child: Icon(icon, color: color, size: 24))
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, color: color, size: 19),
                    const SizedBox(height: 2),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        item.label,
                        maxLines: 1,
                        style: TextStyle(
                          color: labelColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.06,
                          height: 13 / 11,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
