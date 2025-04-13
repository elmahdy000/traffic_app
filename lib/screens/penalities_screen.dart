import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../widgets/custom_app_bar.dart';

class PenaltiesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> penalties = [
    {
      'type': 'السير دون رخصة قيادة',
      'fine': '1000 - 3000 جنيه',
      'icon': Icons.drive_eta_outlined,
      'severity': 'خطير',
      'color': Color(0xFFEF4444),
    },
    {
      'type': 'القيادة تحت تأثير المخدرات',
      'fine': '5000 - 10000 جنيه',
      'icon': Icons.warning_rounded,
      'severity': 'خطير جداً',
      'color': Color(0xFFDC2626),
    },
    {
      'type': 'تجاوز السرعة المقررة',
      'fine': '100 - 3000 جنيه',
      'icon': Icons.speed,
      'severity': 'متوسط',
      'color': Color(0xFFF59E0B),
    },
    {
      'type': 'التوقف المتعمد على الكوبري',
      'fine': '100 - 500 جنيه',
      'icon': Icons.no_crash_outlined,
      'severity': 'منخفض',
      'color': Color(0xFF3B82F6),
    },
    {
      'type': 'عدم اتباع تعليمات رجال المرور',
      'fine': '200 - 500 جنيه',
      'icon': Icons.person_outline,
      'severity': 'منخفض',
      'color': Color(0xFF3B82F6),
    },
    {
      'type': 'كسر إشارة المرور',
      'fine': '100 - 2000 جنيه',
      'icon': Icons.traffic,
      'severity': 'متوسط',
      'color': Color(0xFFF59E0B),
    },
    {
      'type': 'استخدام الهاتف أثناء القيادة',
      'fine': '100 - 500 جنيه',
      'icon': Icons.phone_android,
      'severity': 'منخفض',
      'color': Color(0xFF3B82F6),
    },
    {
      'type': 'المشي ببطء شديد على الجسر',
      'fine': '100 - 500 جنيه',
      'icon': Icons.directions_walk,
      'severity': 'منخفض',
      'color': Color(0xFF3B82F6),
    },
    {
      'type': 'الوقوف في المحظور',
      'fine': '100 - 500 جنيه',
      'icon': Icons.do_not_disturb_on_outlined,
      'severity': 'منخفض',
      'color': Color(0xFF3B82F6),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'العقوبات المرورية',
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white24,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.gavel, color: Colors.white, size: 24),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF8FAFC),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Theme.of(context).primaryColor, Color(0xFF3B82F6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'تعرف على العقوبات المرورية',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'احترام قوانين المرور يحمي الجميع',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.security,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: penalties.length,
                itemBuilder: (context, index) {
                  final penalty = penalties[index];
                  return FadeInUp(
                    delay: Duration(milliseconds: 100 * index),
                    child: Container(
                      margin: EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              // Show more details if needed
                            },
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: penalty['color'].withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      penalty['icon'],
                                      color: penalty['color'],
                                      size: 24,
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          penalty['type'],
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF1E293B),
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'الغرامة: ${penalty['fine']}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF64748B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: penalty['color'].withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      penalty['severity'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: penalty['color'],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
