import 'package:flutter/material.dart';
import 'package:ncapp/core/widgets/app_card.dart';
import 'package:ncapp/features/advance_req/widgets/advance_req_document_controls.dart';
import 'package:ncapp/features/advance_req/widgets/advance_req_document_dialogs.dart';
import 'package:ncapp/features/advance_req/widgets/advance_req_document_fields.dart';



// ════════════════════════════════════════════════════════════
//  Info card — Үлдэгдэл / Нийт хаах
// ════════════════════════════════════════════════════════════


class AdvanceReqDocumentFormCard extends StatefulWidget {
  final bool isSubmitted;
  const AdvanceReqDocumentFormCard({required this.isSubmitted});

  @override
  State<AdvanceReqDocumentFormCard> createState() => _AdvanceReqDocumentFormCardState();
}

class _AdvanceReqDocumentFormCardState extends State<AdvanceReqDocumentFormCard> {
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
    SuggestedAdvanceDoc(
      amount: "300'000₮",
      account: '025100986783001096430017710041821',
    ),
    SuggestedAdvanceDoc(
      amount: "100'000₮",
      account: '025100986783001096430017710041821',
    ),
    SuggestedAdvanceDoc(
      amount: "60'000₮",
      account: '025100986783001096430017710041821',
    ),
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
      final isImage =
          lower.contains('img') ||
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
      builder: (_) => AdvanceReqSuggestedDocsDialog(
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
      builder: (_) => AdvanceReqFilePickerDialog(
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
          AdvanceReqDocumentTabSelector(
            tabs: _tabs,
            selectedIndex: _selectedTab,
            onSelect: (i) => setState(() => _selectedTab = i),
          ),
          const SizedBox(height: 10),
          SuggestedAdvanceDocsRow(
            count: _suggestedDocs.length,
            onTap: _openSuggestedDocs,
          ),
          const SizedBox(height: 10),
          AdvanceReqFileUploadBox(
            attachedFile: _attachedFile,
            onPick: _openFilePicker,
            onRemove: _removeFile,
          ),
          if (_isReadFailed) ...[
            const SizedBox(height: 10),
            const AdvanceReqOcrWarningBox(),
          ],
          const SizedBox(height: 12),
          AdvanceReqLabelField(
            label: 'Хаах дүн',
            controller: _haakhDunCtrl,
            placeholder: 'Файлаа хавсарган уу',
          ),
          const SizedBox(height: 8),
          AdvanceReqLabelField(
            label: 'ДДТД',
            controller: _ddtdCtrl,
            placeholder: 'Файлаа хавсарган уу',
          ),
          if (widget.isSubmitted) ...[
            const SizedBox(height: 12),
            AdvanceReqPartialSection(
              isPartial: _isPartial,
              onToggle: (v) => setState(() => _isPartial = v),
              partialCtrl: _partialCtrl,
              haakhDunCtrl: _haakhDunCtrl,
            ),
          ],
          const SizedBox(height: 12),
          AdvanceReqCommentBox(controller: _commentCtrl),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  Tab selector — horizontal scrolling chips
// ════════════════════════════════════════════════════════════
