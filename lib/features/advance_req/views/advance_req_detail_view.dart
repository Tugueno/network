import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ncapp/features/advance_req/advance_req_controller.dart';
import 'package:ncapp/features/advance_req/advance_req_model.dart';
import 'package:ncapp/core/utils/format.dart';
import 'package:ncapp/core/widgets/app_card.dart';
import 'package:ncapp/core/widgets/bottom_sheet_container.dart';
import 'package:ncapp/theme/app_text_styles.dart';
import 'package:ncapp/theme/app_theme.dart';
import 'package:ncapp/widgets/app_scaffold.dart';

// ════════════════════════════════════════════════════════════
//  Entry point
// ════════════════════════════════════════════════════════════

class AdvanceReqDetailView extends GetView<AdvanceReqController> {
  const AdvanceReqDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final item = controller.selectedItem.value;
      if (item == null) return const SizedBox.shrink();
      return _DetailBody(item: item);
    });
  }
}

// ════════════════════════════════════════════════════════════
//  Detail body — scaffold + top-level state only
// ════════════════════════════════════════════════════════════

class _DetailBody extends StatefulWidget {
  final AdvanceReqModel item;
  const _DetailBody({required this.item});

  @override
  State<_DetailBody> createState() => _DetailBodyState();
}

class _DetailBodyState extends State<_DetailBody> {
  bool _isSubmitted = false;
  int _extraAttachmentCount = 0;
  bool _showToast = false;

  int get _totalCount => widget.item.attachmentCount + _extraAttachmentCount;

  void _submit() {
    setState(() {
      _isSubmitted = true;
      _extraAttachmentCount++;
      _showToast = true;
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showToast = false);
    });
  }

  void _openAttachments() {
    if (_totalCount == 0) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _AttachmentSheet(count: _totalCount),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: widget.item.id,
      onBack: () => Get.find<AdvanceReqController>().closeDetail(),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
            children: [
              _InfoCard(item: widget.item),
              const SizedBox(height: 12),
              _AttachmentHeader(
                count: _totalCount,
                hasNew: _extraAttachmentCount > 0,
                onTap: _openAttachments,
              ),
              const SizedBox(height: 12),
              _DocumentFormCard(isSubmitted: _isSubmitted),
            ],
          ),
          if (_showToast)
            const Positioned(
              top: 12,
              left: 24,
              right: 24,
              child: _SuccessToast(),
            ),
        ],
      ),
      bottomNavigationBar: _SubmitBar(
        isSubmitted: _isSubmitted,
        onSubmit: _submit,
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  Data
// ════════════════════════════════════════════════════════════

class _SuggestedDoc {
  final String amount;
  final String account;
  const _SuggestedDoc({required this.amount, required this.account});
}

// ════════════════════════════════════════════════════════════
//  Info card — Үлдэгдэл / Нийт хаах
// ════════════════════════════════════════════════════════════

class _InfoCard extends StatelessWidget {
  final AdvanceReqModel item;
  const _InfoCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Row(
              children: [
                Container(
                  width: 25,
                  height: 25,
                  decoration: const BoxDecoration(
                      color: Color(0xFFFF9500), shape: BoxShape.circle),
                  child: const Icon(Icons.access_time,
                      size: 14, color: Colors.white),
                ),
                const SizedBox(width: 10),
                const Text('Үлдэгдэл:',
                    style:
                        TextStyle(fontSize: 14, color: AppTheme.textDark)),
                const Spacer(),
                Text(
                  formatTugrik(item.remainingAmount),
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textDark),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Row(
              children: [
                const Text('Нийт хаах:',
                    style:
                        TextStyle(fontSize: 14, color: AppTheme.textDark)),
                const Spacer(),
                Text(
                  formatTugrik(item.totalCloseAmount),
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textDark),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  Attachment header — count badge, opens sheet on tap
// ════════════════════════════════════════════════════════════

class _AttachmentHeader extends StatelessWidget {
  final int count;
  final bool hasNew;
  final VoidCallback onTap;

  const _AttachmentHeader({
    required this.count,
    required this.hasNew,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AppCard(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Row(
          children: [
            if (hasNew) ...[
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(right: 8),
                decoration: const BoxDecoration(
                    color: AppTheme.primary, shape: BoxShape.circle),
              ),
            ],
            const Text(
              'Хавсаргасан баримтууд',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textDark),
            ),
            const Spacer(),
            Text(
              '$count',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: hasNew ? AppTheme.primary : AppTheme.textGrey),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down,
                size: 20, color: AppTheme.textGrey),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  Document form card — owns all form state
// ════════════════════════════════════════════════════════════

class _DocumentFormCard extends StatefulWidget {
  final bool isSubmitted;
  const _DocumentFormCard({required this.isSubmitted});

  @override
  State<_DocumentFormCard> createState() => _DocumentFormCardState();
}

class _DocumentFormCardState extends State<_DocumentFormCard> {
  int _selectedTab = 0;
  String? _attachedFile;
  bool _isReadFailed = false;
  bool _isPartial = false;

  late final _haakhDunCtrl = TextEditingController();
  late final _ddtdCtrl = TextEditingController();
  late final _partialCtrl = TextEditingController();
  late final _commentCtrl = TextEditingController();

  static const _tabs = [
    'иБаримт',
    'Акт',
    'Нэхэмжлэх',
    'Гэрээ',
    'Гадаад худалдан авалт',
  ];

  static const _suggestedDocs = [
    _SuggestedDoc(amount: "300'000₮", account: '025100986783001096430017710041821'),
    _SuggestedDoc(amount: "100'000₮", account: '025100986783001096430017710041821'),
    _SuggestedDoc(amount: "60'000₮",  account: '025100986783001096430017710041821'),
  ];

  @override
  void dispose() {
    _haakhDunCtrl.dispose();
    _ddtdCtrl.dispose();
    _partialCtrl.dispose();
    _commentCtrl.dispose();
    super.dispose();
  }

  void _onFilePicked(String filename) {
    setState(() {
      _attachedFile = filename;
      final lower = filename.toLowerCase();
      final isImage = lower.contains('img') ||
          lower.contains('photo') ||
          lower.endsWith('.jpg') ||
          lower.endsWith('.jpeg') ||
          lower.endsWith('.png');
      _isReadFailed = isImage;
      if (!isImage) {
        _haakhDunCtrl.text = "300'000₮";
        _ddtdCtrl.text = '13768593012847192842933';
      } else {
        _haakhDunCtrl.clear();
        _ddtdCtrl.clear();
      }
    });
  }

  void _removeFile() => setState(() {
        _attachedFile = null;
        _isReadFailed = false;
        _haakhDunCtrl.clear();
        _ddtdCtrl.clear();
      });

  void _onSuggestedSelect(String amount, String account) => setState(() {
        _haakhDunCtrl.text = amount;
        _ddtdCtrl.text = account;
      });

  void _openSuggestedDocs() {
    showDialog(
      context: context,
      barrierColor: Colors.black26,
      builder: (_) => _SuggestedDocsDialog(
        docs: _suggestedDocs,
        onSelect: (doc) {
          Navigator.pop(context);
          _onSuggestedSelect(doc.amount, doc.account);
        },
      ),
    );
  }

  void _openFilePicker() {
    showDialog(
      context: context,
      barrierColor: Colors.black26,
      builder: (_) => _FilePickerDialog(
        onPick: (filename) {
          Navigator.pop(context);
          _onFilePicked(filename);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TabSelector(
            tabs: _tabs,
            selectedIndex: _selectedTab,
            onSelect: (i) => setState(() => _selectedTab = i),
          ),
          const SizedBox(height: 10),
          _SuggestedDocsRow(
            count: _suggestedDocs.length,
            onTap: _openSuggestedDocs,
          ),
          const SizedBox(height: 10),
          _FileUploadBox(
            attachedFile: _attachedFile,
            onPick: _openFilePicker,
            onRemove: _removeFile,
          ),
          if (_isReadFailed) ...[
            const SizedBox(height: 10),
            const _OcrWarningBox(),
          ],
          const SizedBox(height: 12),
          _LabelField(
            label: 'Хаах дүн',
            controller: _haakhDunCtrl,
            placeholder: 'Файлаа хавсарган уу',
          ),
          const SizedBox(height: 8),
          _LabelField(
            label: 'ДДТД',
            controller: _ddtdCtrl,
            placeholder: 'Файлаа хавсарган уу',
          ),
          if (widget.isSubmitted) ...[
            const SizedBox(height: 12),
            _PartialSection(
              isPartial: _isPartial,
              onToggle: (v) => setState(() => _isPartial = v),
              partialCtrl: _partialCtrl,
              haakhDunCtrl: _haakhDunCtrl,
            ),
          ],
          const SizedBox(height: 12),
          _CommentBox(controller: _commentCtrl),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  Tab selector — horizontal scrolling chips
// ════════════════════════════════════════════════════════════

class _TabSelector extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const _TabSelector({
    required this.tabs,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final selected = i == selectedIndex;
          return GestureDetector(
            onTap: () => onSelect(i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: selected ? AppTheme.primary : AppTheme.borderColor,
                  width: selected ? 1.3 : 1,
                ),
              ),
              child: Text(
                tabs[i],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: selected ? AppTheme.primary : AppTheme.textGrey,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  Suggested docs row — grey box, opens dialog on tap
// ════════════════════════════════════════════════════════════

class _SuggestedDocsRow extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const _SuggestedDocsRow({required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F6FC),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const Text(
              'Санал болгож буй баримтууд',
              style: TextStyle(fontSize: 14, color: AppTheme.textGrey),
            ),
            const Spacer(),
            Text('$count',
                style: const TextStyle(
                    fontSize: 14, color: AppTheme.textGrey)),
            const SizedBox(width: 4),
            const Icon(Icons.unfold_more,
                size: 18, color: AppTheme.textGrey),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  File upload box — dashed border, shows attached file
// ════════════════════════════════════════════════════════════

class _FileUploadBox extends StatelessWidget {
  final String? attachedFile;
  final VoidCallback onPick;
  final VoidCallback onRemove;

  const _FileUploadBox({
    required this.attachedFile,
    required this.onPick,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final hasFile = attachedFile != null;

    return GestureDetector(
      onTap: hasFile ? null : onPick,
      child: CustomPaint(
        painter: _DashedBorderPainter(color: AppTheme.primary, radius: 10),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: hasFile ? _AttachedFileRow(file: attachedFile!, onRemove: onRemove)
                           : const _UploadPrompt(),
          ),
        ),
      ),
    );
  }
}

class _UploadPrompt extends StatelessWidget {
  const _UploadPrompt();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(Icons.upload_outlined, size: 20, color: AppTheme.primary),
        SizedBox(width: 10),
        Text(
          'Файл хавсаргах',
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.primary),
        ),
      ],
    );
  }
}

class _AttachedFileRow extends StatelessWidget {
  final String file;
  final VoidCallback onRemove;

  const _AttachedFileRow({required this.file, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.insert_drive_file_outlined,
            size: 18, color: AppTheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            file,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.primary,
              decoration: TextDecoration.underline,
              decorationColor: AppTheme.primary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        GestureDetector(
          onTap: onRemove,
          child: const Icon(Icons.close, size: 18, color: AppTheme.textGrey),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════
//  OCR warning box — shown when image file cannot be parsed
// ════════════════════════════════════════════════════════════

class _OcrWarningBox extends StatelessWidget {
  const _OcrWarningBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3CD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: const Color(0xFFFFCC00).withValues(alpha: 0.4)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded,
              size: 18, color: Color(0xFFFF9500)),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Дүн болон ДДТД таньж чадсангүй. Зургийг дахин авах эсвэл гараар оруулна уу.',
              style: TextStyle(fontSize: 13, color: Color(0xFF7A5C00)),
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  Partial section — toggle + amount input + computed total
// ════════════════════════════════════════════════════════════

class _PartialSection extends StatelessWidget {
  final bool isPartial;
  final ValueChanged<bool> onToggle;
  final TextEditingController partialCtrl;
  final TextEditingController haakhDunCtrl;

  const _PartialSection({
    required this.isPartial,
    required this.onToggle,
    required this.partialCtrl,
    required this.haakhDunCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Хэсэгчилж оруулах',
                style: TextStyle(fontSize: 14, color: AppTheme.textDark)),
            const Spacer(),
            Switch(
              value: isPartial,
              onChanged: onToggle,
              activeThumbColor: AppTheme.primary,
              activeTrackColor: AppTheme.primary.withValues(alpha: 0.4),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
        if (isPartial) ...[
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F6FC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        '₮',
                        style: TextStyle(fontSize: 14, color: AppTheme.textGrey),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: partialCtrl,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontSize: 14, color: AppTheme.textDark),
                          decoration: const InputDecoration(
                            hintText: 'Хэсэгчилсэн дүн оруулах',
                            hintStyle: TextStyle(fontSize: 14, color: AppTheme.textGrey),
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedBuilder(
                  animation: Listenable.merge([partialCtrl, haakhDunCtrl]),
                  builder: (_, _) {
                    final partial = int.tryParse(
                            partialCtrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
                    final haakh = int.tryParse(
                            haakhDunCtrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
                    final newAmt = (haakh - partial).clamp(0, haakh);
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
                      child: Text(
                        'Шинэ хаах дүн: ${formatTugrik(newAmt)}',
                        style: const TextStyle(fontSize: 14, color: AppTheme.textGrey),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ] else
          const SizedBox(height: 4),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════
//  Comment box — Тайлбар text area
// ════════════════════════════════════════════════════════════

class _CommentBox extends StatelessWidget {
  final TextEditingController controller;
  const _CommentBox({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      minLines: 3,
      maxLines: 5,
      style: AppTextStyles.body,
      decoration: InputDecoration(
        hintText: 'Тайлбар оруулах',
        hintStyle: AppTextStyles.hint,
        filled: true,
        fillColor: const Color(0xFFF5F6FC),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.primary, width: 1.5),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  Label + inline editable field (Хаах дүн / ДДТД)
// ════════════════════════════════════════════════════════════

class _LabelField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String placeholder;

  const _LabelField({
    required this.label,
    required this.controller,
    required this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$label:',
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textDark),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: controller,
            style: const TextStyle(fontSize: 14, color: AppTheme.textDark),
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: const TextStyle(
                  fontSize: 14, color: AppTheme.textGrey),
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════
//  Submit bar — Шалгах / Шинээр шалгах button
// ════════════════════════════════════════════════════════════

class _SubmitBar extends StatelessWidget {
  final bool isSubmitted;
  final VoidCallback onSubmit;

  const _SubmitBar({required this.isSubmitted, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
      color: Colors.white,
      child: ElevatedButton(
        onPressed: onSubmit,
        child: Text(isSubmitted ? 'Шинээр шалгах' : 'Шалгах'),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  Success toast — floating pill shown after submit
// ════════════════════════════════════════════════════════════

class _SuccessToast extends StatelessWidget {
  const _SuccessToast();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, size: 22, color: Color(0xFF34C759)),
            SizedBox(width: 8),
            Text(
              'Урдчилгаа амжилттай хаагдлаа.',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textDark),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  Suggested docs dialog — positioned dropdown at top
// ════════════════════════════════════════════════════════════

class _SuggestedDocsDialog extends StatelessWidget {
  final List<_SuggestedDoc> docs;
  final ValueChanged<_SuggestedDoc> onSelect;

  const _SuggestedDocsDialog({required this.docs, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 180, 16, 0),
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 14, 16, 10),
                  child: Text(
                    'Санал болгож буй баримтууд',
                    style: TextStyle(fontSize: 14, color: AppTheme.textGrey),
                  ),
                ),
                const Divider(
                    height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
                for (int i = 0; i < docs.length; i++) ...[
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onSelect(docs[i]),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            docs[i].amount,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textDark),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            docs[i].account,
                            style: const TextStyle(
                                fontSize: 14, color: AppTheme.textGrey),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (i < docs.length - 1)
                    const Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFFF0F0F0)),
                ],
                const SizedBox(height: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  File picker dialog — right-aligned popup with 3 options
// ════════════════════════════════════════════════════════════

class _FilePickerDialog extends StatelessWidget {
  final ValueChanged<String> onPick;
  const _FilePickerDialog({required this.onPick});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 16, top: 40),
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _PickerOption(
                  icon: Icons.photo_library_outlined,
                  label: 'Зургын цомог',
                  onTap: () => onPick('IMG.2424.pdf'),
                ),
                const Divider(
                    height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
                _PickerOption(
                  icon: Icons.camera_alt_outlined,
                  label: 'Камер',
                  onTap: () => onPick('PHOTO.jpg'),
                ),
                const Divider(
                    height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
                _PickerOption(
                  icon: Icons.folder_outlined,
                  label: 'Файл сонгох',
                  onTap: () => onPick('document.pdf'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PickerOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _PickerOption(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 14, color: AppTheme.textDark)),
            const Spacer(),
            Icon(icon, size: 22, color: AppTheme.textGrey),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  Attachment bottom sheet — grid of uploaded files
// ════════════════════════════════════════════════════════════

class _AttachmentSheet extends StatelessWidget {
  final int count;
  const _AttachmentSheet({required this.count});

  @override
  Widget build(BuildContext context) {
    return BottomSheetContainer(
      maxHeightFactor: 0.75,
      children: [
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Хавсаргасан баримтууд',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Flexible(
            child: GridView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.8,
              ),
              itemCount: count,
              itemBuilder: (_, i) => _AttachmentTile(index: i),
            ),
          ),
        ],
    );
  }
}

class _AttachmentTile extends StatelessWidget {
  final int index;
  const _AttachmentTile({required this.index});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              color: const Color(0xFFF2F2F7),
              width: double.infinity,
              child: const Center(
                child: Icon(Icons.receipt_long_outlined,
                    size: 32, color: AppTheme.textGrey),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          "27'000₮",
          style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppTheme.textDark),
        ),
        const Text(
          '05/20/2026',
          style: TextStyle(fontSize: 10, color: AppTheme.textGrey),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════
//  Dashed border painter
// ════════════════════════════════════════════════════════════

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;
  const _DashedBorderPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const dash = 6.0;
    const gap = 4.0;
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(radius),
      ));

    for (final metric in path.computeMetrics()) {
      double d = 0;
      while (d < metric.length) {
        canvas.drawPath(metric.extractPath(d, d + dash), paint);
        d += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) =>
      old.color != color || old.radius != radius;
}
