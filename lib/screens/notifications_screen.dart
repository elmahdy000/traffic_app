import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'تذكير بموعد تجديد الرخصة',
      'description': 'موعد تجديد رخصة القيادة بعد 3 أيام',
      'time': 'منذ ساعة',
      'icon': Icons.directions_car,
      'color': Color(0xFF3B82F6),
      'isRead': false,
    },
    {
      'title': 'مخالفة مرورية جديدة',
      'description': 'تم تسجيل مخالفة تجاوز السرعة',
      'time': 'منذ 3 ساعات',
      'icon': Icons.warning_rounded,
      'color': Color(0xFFF59E0B),
      'isRead': false,
    },
    {
      'title': 'تحديث حالة الطلب',
      'description': 'تم الموافقة على طلب تجديد الرخصة',
      'time': 'منذ يوم',
      'icon': Icons.check_circle,
      'color': Color(0xFF10B981),
      'isRead': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          'الإشعارات',
          style: TextStyle(color: Color(0xFF1E293B)),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Color(0xFF64748B)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          return FadeInUp(
            delay: Duration(milliseconds: 100 * index),
            child: Card(
              margin: EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(16),
                leading: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: notification['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    notification['icon'],
                    color: notification['color'],
                  ),
                ),
                title: Text(
                  notification['title'],
                  style: TextStyle(
                    fontWeight: notification['isRead'] ? FontWeight.normal : FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    Text(
                      notification['description'],
                      style: TextStyle(color: Color(0xFF64748B)),
                    ),
                    SizedBox(height: 8),
                    Text(
                      notification['time'],
                      style: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  setState(() {
                    notification['isRead'] = true;
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
