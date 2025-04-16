import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class TrafficServicesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> _services = [
    {
      'title': 'طلب المساعدة المرورية',
      'icon': Icons.help_outline,
      'color': Colors.blue,
    },
    {
      'title': 'تحويل مسار',
      'icon': Icons.route,
      'color': Colors.green,
    },
    {
      'title': 'الإبلاغ عن مشكلة مرورية',
      'icon': Icons.report_problem,
      'color': Colors.orange,
    },
    {
      'title': 'خدمات النقل الثقيل',
      'icon': Icons.local_shipping,
      'color': Colors.purple,
    },
    {
      'title': 'طلب مرافقة مرورية',
      'icon': Icons.follow_the_signs,
      'color': Colors.red,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('خدمات المرور', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: _services.length,
        itemBuilder: (context, index) {
          final service = _services[index];
          return FadeInUp(
            delay: Duration(milliseconds: index * 100),
            duration: Duration(milliseconds: 500),
            child: Card(
              margin: EdgeInsets.only(bottom: 16),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(16),
                leading: CircleAvatar(
                  backgroundColor: service['color'].withOpacity(0.1),
                  radius: 30,
                  child:
                      Icon(service['icon'], color: service['color'], size: 30),
                ),
                title: Text(
                  service['title'],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('سيتم إضافة هذه الخدمة قريباً'),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
