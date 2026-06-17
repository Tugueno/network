import 'package:flutter/material.dart';
import 'package:ncapp/theme/app_text_styles.dart';

/// Энгийн `Text`-д зориулсан тав тухтай widget. Загварыг [AppTextStyles]-аас
/// нэрлэсэн constructor-аар сонгоно:
///
/// ```dart
/// AppText.title('Гарчиг')
/// AppText.body('Тэмдэглэл', color: AppTheme.primary)
/// AppText.caption('Урт текст', align: TextAlign.center, maxLines: 2)
/// ```
///
/// `Text`-ээс өөр газар (TextField hintStyle, button textStyle, RichText)
/// энэ widget биш, [AppTextStyles].xxx тогтмолыг шууд ашиглана.
class AppText extends StatelessWidget {
  final String data;
  final TextStyle style;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const AppText._(
    this.data,
    this.style, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  // ── Утгаар нэрлэсэн constructor-ууд ([AppTextStyles]-аас) ──
  const AppText.headline(String data,
      {Key? key, Color? color, TextAlign? align, int? maxLines})
      : this._(data, AppTextStyles.headline,
            key: key, color: color, textAlign: align, maxLines: maxLines);

  const AppText.largeTitle(String data,
      {Key? key, Color? color, TextAlign? align, int? maxLines})
      : this._(data, AppTextStyles.largeTitle,
            key: key, color: color, textAlign: align, maxLines: maxLines);

  const AppText.title(String data,
      {Key? key, Color? color, TextAlign? align, int? maxLines})
      : this._(data, AppTextStyles.title,
            key: key, color: color, textAlign: align, maxLines: maxLines);

  const AppText.heading(String data,
      {Key? key, Color? color, TextAlign? align, int? maxLines})
      : this._(data, AppTextStyles.heading,
            key: key, color: color, textAlign: align, maxLines: maxLines);

  const AppText.subtitle(String data,
      {Key? key, Color? color, TextAlign? align, int? maxLines})
      : this._(data, AppTextStyles.subtitle,
            key: key, color: color, textAlign: align, maxLines: maxLines);

  const AppText.body(String data,
      {Key? key, Color? color, TextAlign? align, int? maxLines, TextOverflow? overflow})
      : this._(data, AppTextStyles.body,
            key: key,
            color: color,
            textAlign: align,
            maxLines: maxLines,
            overflow: overflow);

  const AppText.bodyBold(String data,
      {Key? key, Color? color, TextAlign? align, int? maxLines})
      : this._(data, AppTextStyles.bodyBold,
            key: key, color: color, textAlign: align, maxLines: maxLines);

  const AppText.label(String data, {Key? key, Color? color, TextAlign? align})
      : this._(data, AppTextStyles.label,
            key: key, color: color, textAlign: align);

  const AppText.bodyHeavy(String data,
      {Key? key, Color? color, TextAlign? align, int? maxLines})
      : this._(data, AppTextStyles.bodyHeavy,
            key: key, color: color, textAlign: align, maxLines: maxLines);

  const AppText.amount(String data, {Key? key, Color? color, TextAlign? align})
      : this._(data, AppTextStyles.amount,
            key: key, color: color, textAlign: align);

  const AppText.bodyGrey(String data,
      {Key? key, Color? color, TextAlign? align, int? maxLines})
      : this._(data, AppTextStyles.bodyGrey,
            key: key, color: color, textAlign: align, maxLines: maxLines);

  const AppText.caption(String data,
      {Key? key, Color? color, TextAlign? align, int? maxLines})
      : this._(data, AppTextStyles.caption,
            key: key, color: color, textAlign: align, maxLines: maxLines);

  const AppText.captionBold(String data,
      {Key? key, Color? color, TextAlign? align})
      : this._(data, AppTextStyles.captionBold,
            key: key, color: color, textAlign: align);

  const AppText.bodyBoldGrey(String data,
      {Key? key, Color? color, TextAlign? align, int? maxLines})
      : this._(data, AppTextStyles.bodyBoldGrey,
            key: key, color: color, textAlign: align);

  const AppText.small(String data, {Key? key, Color? color, TextAlign? align})
      : this._(data, AppTextStyles.small,
            key: key, color: color, textAlign: align);

  const AppText.tiny(String data, {Key? key, Color? color, TextAlign? align})
      : this._(data, AppTextStyles.tiny,
            key: key, color: color, textAlign: align);

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: color == null ? style : style.copyWith(color: color),
    );
  }
}
