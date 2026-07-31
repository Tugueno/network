import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:ncapp/core/widgets/app_card.dart';
import 'package:ncapp/features/advance_req/widgets/advance_req_document_controls.dart';
import 'package:ncapp/features/advance_req/widgets/advance_req_document_dialogs.dart';
import 'package:ncapp/features/advance_req/widgets/advance_req_document_fields.dart';

// ════════════════════════════════════════════════════════════
//  Info card — Үлдэгдэл / Нийт хаах
// ════════════════════════════════════════════════════════════

class AdvanceReqDocumentFormCard extends StatefulWidget {
  final bool isSubmitted;
  const AdvanceReqDocumentFormCard({super.key, required this.isSubmitted});

  @override
  State<AdvanceReqDocumentFormCard> createState() => AdvanceReqDocumentFormCardState();
}

class AdvanceReqDocumentFormCardState extends State<AdvanceReqDocumentFormCard> {
  // ⚠️ ӨӨРИЙН МАС-ЫН ЖИНХЭНЭ IP ХАЯГИЙГ ЭНД БИЧЭЭРЭЙ
  final String _serverIp = "10.0.19.106"; 

  int _selectedTab = 0;
  String? _attachedFile;
  String? _rawTextFromServer; // Серверээс ирэх түүхий текстийг хадгалах хувьсагч
  bool _isReadFailed = false;
  bool _isPartial = false;
  bool _isLoading = false; 

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

  // Зураг/PDF уншуулах үндсэн API функц
  Future<void> _onFilePicked(String filePath) async {
    if (filePath.isEmpty) return;

    final fileName = filePath.split('/').last;

    setState(() {
      _attachedFile = fileName;
      _isReadFailed = false;
      _rawTextFromServer = null;
      _haakhDunCtrl.clear();
      _ddtdCtrl.clear();
      _isLoading = true; 
    });

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://$_serverIp:8000/extract-receipt'),
      );
      
      request.files.add(await http.MultipartFile.fromPath('file', filePath));
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        
        if (responseData['status'] == 'success') {
          _rawTextFromServer = responseData['raw_text']; // Түүхий текстийг хадгалж авна
          Map<String, dynamic> targetData = responseData['data'];
          
          String ddtd = targetData['ddtd'];
          String amount = targetData['ebarimt_amount'];

          setState(() {
            _ddtdCtrl.text = ddtd == "Not found" ? "" : ddtd;
            _haakhDunCtrl.text = amount == "Not found" ? "" : amount;
            
            if (ddtd == "Not found" || amount == "Not found") {
              _isReadFailed = true;
            }
          });
        } else {
          setState(() => _isReadFailed = true);
        }
      } else {
        setState(() => _isReadFailed = true);
      }
    } catch (e) {
      setState(() => _isReadFailed = true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // 🌟 ХЭРЭГЛЭГЧИЙН ГАРААР ЗАССАН ӨГӨГДЛИЙГ (FEEDBACK) СЕРВЕР ЛҮҮ ИЛГЭЭХ ФУНКЦ
  Future<void> sendFeedbackToServer() async {
    if (_rawTextFromServer == null) return; // Баримт уншуулаагүй бол хүсэлт илгээхгүй

    try {
      await http.post(
        Uri.parse('http://$_serverIp:8000/feedback'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "raw_text": _rawTextFromServer,
          "corrected_ddtd": _ddtdCtrl.text,       
          "corrected_amount": _haakhDunCtrl.text, 
        }),
      );
    } catch (e) {
      print("Feedback илгээхэд алдаа гарлаа: $e");
    }
  }

  void _removeFile() => setState(() {
    _attachedFile = null;
    _rawTextFromServer = null;
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
          
          _isLoading
              ? const SizedBox(
                  height: 52,
                  child: Center(child: CircularProgressIndicator()),
                )
              : AdvanceReqFileUploadBox(
                  attachedFile: _attachedFile,
                  onPick: _onFilePicked,
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
