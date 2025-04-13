import 'package:flutter/material.dart';

class SpecialNeedsLicenseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'تراخيص ذوي الاحتياجات الخاصة',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[700]!, Colors.cyan[400]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // قسم الترحيب
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              color: Colors.cyan[50],
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مرحبًا بذوي الاحتياجات الخاصة!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'نقدم لكم تسهيلات خاصة للحصول على رخصة قيادة تناسب احتياجاتكم. يرجى الاطلاع على التفاصيل أدناه.',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // قسم الشروط
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الشروط',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                    ),
                    SizedBox(height: 10),
                    ListTile(
                      leading: Icon(Icons.check_circle, color: Colors.green[700]),
                      title: Text('العمر لا يقل عن 18 سنة.'),
                    ),
                    ListTile(
                      leading: Icon(Icons.check_circle, color: Colors.green[700]),
                      title: Text('تقرير طبي من مستشفى معتمد يوضح نوع الإعاقة ومدى القدرة على القيادة.'),
                    ),
                    ListTile(
                      leading: Icon(Icons.check_circle, color: Colors.green[700]),
                      title: Text('اجتياز فحص عملي خاص بذوي الاحتياجات الخاصة.'),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // قسم المستندات
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'المستندات المطلوبة',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                    ),
                    SizedBox(height: 10),
                    ListTile(
                      leading: Icon(Icons.description, color: Colors.blue[700]),
                      title: Text('بطاقة الرقم القومي سارية.'),
                    ),
                    ListTile(
                      leading: Icon(Icons.description, color: Colors.blue[700]),
                      title: Text('4 صور شخصية حديثة.'),
                    ),
                    ListTile(
                      leading: Icon(Icons.description, color: Colors.blue[700]),
                      title: Text('تقرير طبي من لجنة التحكيم الطبي.'),
                    ),
                    ListTile(
                      leading: Icon(Icons.description, color: Colors.blue[700]),
                      title: Text('شهادة إثبات الإعاقة من الجهة المختصة.'),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // قسم الإجراءات
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الإجراءات',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                    ),
                    SizedBox(height: 10),
                    ListTile(
                      leading: Icon(Icons.play_arrow, color: Colors.blue[700]),
                      title: Text('زيارة أقرب وحدة مرور مختصة بذوي الاحتياجات.'),
                    ),
                    ListTile(
                      leading: Icon(Icons.play_arrow, color: Colors.blue[700]),
                      title: Text('تقديم المستندات المطلوبة للموظف المختص.'),
                    ),
                    ListTile(
                      leading: Icon(Icons.play_arrow, color: Colors.blue[700]),
                      title: Text('اجتياز الفحص العملي مع مرشد مختص.'),
                    ),
                    ListTile(
                      leading: Icon(Icons.play_arrow, color: Colors.blue[700]),
                      title: Text('استلام الرخصة بعد الموافقة.'),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // يمكن ربطها بزيارة موقع إلكتروني أو صفحة حجز
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('جارٍ التوجيه إلى بوابة المرور...')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyan[300],
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        child: Text(
                          'توجيه إلى الموقع الرسمي',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}