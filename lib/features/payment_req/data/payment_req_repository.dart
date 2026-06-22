import 'package:ncapp/features/payment_req/models/payment_req_model.dart';

abstract class PaymentReqRepository {
  Future<List<PaymentReqModel>> fetchRequests();
  Future<void> approve(String id);
  Future<void> reject(String id);
}

class PaymentReqRepositoryImpl implements PaymentReqRepository {
  @override
  Future<List<PaymentReqModel>> fetchRequests() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockData;
  }

  @override
  Future<void> approve(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // TODO: replace with real API call.
  }

  @override
  Future<void> reject(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // TODO: replace with real API call.
  }
}

final _mockData = [
  PaymentReqModel(
    id: 'FPR01866',
    department: 'PUR',
    date: '06/22/2026',
    amount: 5000000,
    assignee: 'А. Жавхлан',
    assigneeRole: 'Дижитал бутээгдэхүүний удирлага, инновац...',
    assigneeLore: 'Газрын захирал',
    paymentDate: '06/22/2026',
    company: 'Нэткaпитал Финанс Корпораци...',
    description:
        'Удирлагын зөвлөлийн ээлжит уулзалтын зохион байгуулат болон логистикийн зардал (хоол унд, хэвлэл ба сургалтын материал).',
    attachmentCount: 5,
    attachmentGroups: const [
      AttachmentGroup(
        personName: 'Д. Баяржаргал',
        personRole: 'Хүсэгч',
        date: '05/20/2026',
        files: [
          AttachmentFile(
            name: 'sample_payment_request.pdf',
            assetPath: 'assets/files/sample_payment_request.pdf',
          ),
          AttachmentFile(
            name: 'sample_payment_request.pdf',
            assetPath: 'assets/files/sample_payment_request.pdf',
          ),
          AttachmentFile(
            name: 'sample_payment_request.pdf',
            assetPath: 'assets/files/sample_payment_request.pdf',
          ),
        ],
      ),
      AttachmentGroup(
        personName: 'Б. Алдар',
        personRole: '',
        date: '05/20/2026',
        files: [
          AttachmentFile(
            name: 'sample_payment_request.pdf',
            assetPath: 'assets/files/sample_payment_request.pdf',
          ),
          AttachmentFile(
            name: 'sample_payment_request.pdf',
            assetPath: 'assets/files/sample_payment_request.pdf',
          ),
        ],
      ),
    ],
    status: PaymentReqStatus.pending,
    requestDetails: const [
      DetailItem(subtitle: 'Хүсэлтийн дугаар', info: 'FPR01866'),
      DetailItem(subtitle: 'Хүсэлтийн огноо', info: '06/22/2026'),
      DetailItem(subtitle: 'Хэлтэс', info: 'PUR'),
      DetailItem(subtitle: 'Хариуцагч', info: 'А. Жавхлан'),
      DetailItem(subtitle: 'Компани', info: 'Нэткапитал Финанс'),
      DetailItem(subtitle: 'Статус', info: 'Хүлээгдэж буй'),
    ],
    budgetDetails: const [
      DetailItem(subtitle: 'Нийт төсөвлөсөн', info: "5'000'000₮"),
      DetailItem(subtitle: 'Хоол унд', info: "1'500'000₮"),
      DetailItem(subtitle: 'Хэвлэл материал', info: "800'000₮"),
      DetailItem(subtitle: 'Сургалтын материал', info: "700'000₮"),
      DetailItem(subtitle: 'Логистик', info: "2'000'000₮"),
    ],
    approvalSteps: [
      ApprovalStepModel(
        label: 'СТУНИШГ Хянасан',
        person: 'Д. Баяржаргал',
        comment: 'Баталсан',
        date: '06/22 12:20',
        status: ApprovalStepStatus.done,
      ),
      ApprovalStepModel(
        label: 'СТУНИШГ Хянасан',
        person: 'А. Жавхлан',
        comment:
            'Худалдан авалтын хянал хийгдсэн. Үнийн харьцуулалт болон баримтууд шаардлага хангаж байна.',
        date: '06/22 12:20',
        status: ApprovalStepStatus.done,
        isReturned: true,
      ),
      ApprovalStepModel(
        label: 'СТУНИШГ Хянасан',
        person: 'С. Болд',
        comment: 'Баталсан',
        date: '06/22 12:20',
        status: ApprovalStepStatus.done,
      ),
      ApprovalStepModel(
        label: 'СТУНИШГ Хянасан',
        person: 'М. Энхбаяр',
        comment: 'Баталсан',
        date: '06/22 12:20',
        status: ApprovalStepStatus.done,
      ),
      ApprovalStepModel(
        label: 'Зөвшөөрсөн',
        person: 'Б. Баянбат',
        comment: null,
        date: '',
        status: ApprovalStepStatus.pending,
      ),
    ],
  ),
  PaymentReqModel(
    id: 'FPR01866',
    department: 'NPL',
    date: '06/22/2026',
    amount: 16000000,
    assignee: 'Д. Эрдэм-Од',
    assigneeRole: '',
    assigneeLore: '',
    paymentDate: '06/22/2026',
    company: '',
    description: '',
    attachmentCount: 0,
    status: PaymentReqStatus.pending,
  ),
  PaymentReqModel(
    id: 'FPR01866',
    department: 'PUR',
    date: '06/22/2026',
    amount: 4000000,
    assignee: 'А. Жавхлан',
    assigneeRole: '',
    assigneeLore: '',
    paymentDate: '06/22/2026',
    company: '',
    description: '',
    attachmentCount: 0,
    status: PaymentReqStatus.approved,
    decisionDate: '06/23/2026',
  ),
  PaymentReqModel(
    id: 'FPR01867',
    department: 'PUR',
    date: '06/22/2026',
    amount: 740100,
    assignee: 'А. Жавхлан',
    assigneeRole: '',
    assigneeLore: '',
    paymentDate: '06/22/2026',
    company: '',
    description: '',
    attachmentCount: 1,
    status: PaymentReqStatus.pending,
  ),
  PaymentReqModel(
    id: 'FPR01868',
    department: 'FAD',
    date: '06/22/2026',
    amount: 1500000,
    assignee: 'М. Баасанжаргал',
    assigneeRole: '',
    assigneeLore: '',
    paymentDate: '06/22/2026',
    company: '',
    description: '',
    attachmentCount: 2,
    status: PaymentReqStatus.pending,
  ),
  PaymentReqModel(
    id: 'FPR01869',
    department: 'NPL',
    date: '06/23/2026',
    amount: 3200000,
    assignee: 'Б. Баянбат',
    assigneeRole: '',
    assigneeLore: '',
    paymentDate: '06/23/2026',
    company: '',
    description: '',
    attachmentCount: 0,
    status: PaymentReqStatus.pending,
  ),
  PaymentReqModel(
    id: 'FPR01866',
    department: 'FAD',
    date: '06/22/2026',
    amount: 1010200,
    assignee: 'М. Баасанжаргал',
    assigneeRole: '',
    assigneeLore: '',
    paymentDate: '06/23/2026',
    company: '',
    description: '',
    attachmentCount: 0,
    status: PaymentReqStatus.approved,
    decisionDate: '06/25/2026',
  ),
  PaymentReqModel(
    id: 'FPR01871',
    department: 'FAD',
    date: '06/23/2026',
    amount: 6750000,
    assignee: 'Д. Эрдэм-Од',
    assigneeRole: '',
    assigneeLore: '',
    paymentDate: '06/23/2026',
    company: '',
    description: '',
    attachmentCount: 4,
    status: PaymentReqStatus.pending,
  ),
  PaymentReqModel(
    id: 'FPR01872',
    department: 'PUR',
    date: '06/24/2026',
    amount: 12000000,
    assignee: 'А. Жавхлан',
    assigneeRole: '',
    assigneeLore: '',
    paymentDate: '06/24/2026',
    company: '',
    description: '',
    attachmentCount: 0,
    status: PaymentReqStatus.pending,
  ),
  PaymentReqModel(
    id: 'FPR01866',
    department: 'FAD',
    date: '06/22/2026',
    amount: 1010200,
    assignee: 'М. Баасанжаргал',
    assigneeRole: '',
    assigneeLore: '',
    paymentDate: '06/24/2026',
    company: '',
    description: '',
    attachmentCount: 0,
    status: PaymentReqStatus.rejected,
    decisionDate: '06/25/2026',
  ),
];
