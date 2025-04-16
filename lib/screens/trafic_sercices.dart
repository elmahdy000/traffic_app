import 'package:flutter/material.dart';

class TrafficServicesScreen extends StatelessWidget {
  final List<TrafficService> services = [
    TrafficService(
      title: 'خدمة نقل قيد أو ملكية مركبة',
      description:
          'نقل ملكية السيارة إلى شخص آخر بعد استيفاء الشروط القانونية.',
      steps: [
        '1. عقد بيع موثق أو إثبات نقل الملكية.',
        '2. بطاقة الرقم القومي للطرفين (المالك والمنقول إليه).',
        '3. شهادة بيانات من المرور التابع له.',
        '4. نموذج فحص فني للمركبة.',
        '5. تسديد المخالفات.',
        '6. دفع الرسوم المقررة.'
      ],
    ),
    TrafficService(
      title: 'استخراج رخصة القيادة',
      description: 'استخراج رخصة قيادة خاصة أو مهنية لأول مرة.',
      steps: [
        '1. صورة بطاقة الرقم القومي.',
        '2. المؤهل الدراسي.',
        '3. عدد 4 صور شخصية.',
        '4. كشف طبي (نظر وباطنة).',
        '5. تحليل مخدرات.',
        '6. اجتياز اختبار القيادة والاشارات.'
      ],
    ),
    TrafficService(
      title: 'إجراءات الحصول على ترخيص تجاري',
      description: 'الحصول على رخصة لتسيير مركبة بغرض تجاري (نقل أو أتوبيس).',
      steps: [
        '1. سجل تجاري وبطاقة ضريبية.',
        '2. بطاقة الرقم القومي.',
        '3. مستند ملكية أو عقد إيجار مقر.',
        '4. فحص فني شامل للمركبة.',
        '5. دفع رسوم التأمين الإجباري.'
      ],
    ),
    TrafficService(
      title: 'خدمة استخراج رخصة تسيير مركبة لأول مرة',
      description: 'ترخيص سيارة جديدة لأول مرة في المرور المصري.',
      steps: [
        '1. فاتورة شراء السيارة أو الإفراج الجمركي.',
        '2. شهادة بيانات من الوكيل.',
        '3. فحص فني للمركبة.',
        '4. دفع التأمين الإجباري والرسوم.',
        '5. صورة بطاقة الرقم القومي.'
      ],
    ),
    TrafficService(
      title: 'الحصول على بدل فاقد أو تالف لرخص تسيير المركبات',
      description: 'طلب بدل تالف أو فاقد لرخصة مركبة.',
      steps: [
        '1. إثبات شخصية (بطاقة رقم قومي).',
        '2. صورة من الرخصة التالفة إن وجدت.',
        '3. محضر فقد في قسم الشرطة.',
        '4. فحص فني للمركبة.',
        '5. دفع الرسوم.'
      ],
    ),
    TrafficService(
      title: 'الحصول على تجديد رخصة تسيير مركبة',
      description: 'تجديد رخصة السيارة المنتهية أو القريبة من الانتهاء.',
      steps: [
        '1. الرخصة القديمة.',
        '2. شهادة مخالفات.',
        '3. فحص فني ساري.',
        '4. تأمين إجباري ساري.',
        '5. سداد الرسوم.'
      ],
    ),
    TrafficService(
      title: 'استخراج شهادة بيانات للمركبات تقدم للشهر العقاري',
      description:
          'شهادة رسمية ببيانات السيارة لتقديمها لجهة حكومية أو الشهر العقاري.',
      steps: [
        '1. أصل الرخصة أو رقم اللوحة.',
        '2. بطاقة رقم قومي.',
        '3. دفع رسوم استخراج الشهادة.'
      ],
    ),
    TrafficService(
      title: 'الإفراج الجمركي',
      description: 'خدمة متعلقة بإخراج السيارات من الجمارك عند الاستيراد.',
      steps: [
        '1. مستند الإفراج الجمركي.',
        '2. بطاقة الرقم القومي.',
        '3. الفاتورة الأصلية وشهادة منشأ.',
        '4. التأمين وسداد الرسوم.'
      ],
    ),
  ];

  TrafficServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ما يقدمه المرور'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return Card(
            margin: EdgeInsets.all(10),
            elevation: 3,
            child: ExpansionTile(
              title: Text(service.title,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(service.description),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: service.steps
                        .map((step) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                children: [
                                  Icon(Icons.check_circle,
                                      color: Colors.green, size: 18),
                                  SizedBox(width: 8),
                                  Expanded(child: Text(step)),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class TrafficService {
  final String title;
  final String description;
  final List<String> steps;

  TrafficService(
      {required this.title, required this.description, required this.steps});
}
