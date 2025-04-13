import 'package:chatbot/screens/license_renewal_screen.dart';
import 'package:flutter/material.dart';

class VehicleServicesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> services = [
    {
      'title': 'تجديد رخصة السيارة',
      'description': 'تجديد رخصة السيارة إلكترونياً',
      'icon': Icons.car_rental,
      'color': Color(0xFF1E88E5),
    },
    {
      'title': 'نقل ملكية السيارة',
      'description': 'إجراءات نقل ملكية السيارة',
      'icon': Icons.swap_horiz,
      'color': Color(0xFF43A047),
    },
    {
      'title': 'فحص السيارة',
      'description': 'حجز موعد فحص السيارة',
      'icon': Icons.build,
      'color': Color(0xFFE53935),
    },
    {
      'title': 'حاسبة التأمين',
      'description': 'حساب قيمة تأمين السيارة',
      'icon': Icons.security,
      'color': Color(0xFF8E24AA),
    },
    {
      'title': 'حاسبة قيمة السيارة',
      'description': 'تقدير قيمة السيارة',
      'icon': Icons.attach_money,
      'color': Color(0xFFFB8C00),
    },
    {
      'title': 'طلب لوحات معدنية',
      'description': 'طلب لوحات معدنية جديدة',
      'icon': Icons.directions_car,
      'color': Color(0xFF00ACC1),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white24,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.directions_car, color: Colors.white, size: 24),
            ),
            SizedBox(width: 12),
            Text(
              'خدمات المركبات',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Theme.of(context).primaryColor, Color(0xFF3B82F6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF8FAFC),
        ),
        child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          itemCount: services.length,
          itemBuilder: (context, index) {
            final service = services[index];
            return Container(
              margin: EdgeInsets.only(bottom: 16),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                elevation: 2,
                child: InkWell(
                  onTap: () {
                    _navigateToService(context, service);
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: service['color'].withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            service['icon'],
                            color: service['color'],
                            size: 28,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                service['title'],
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: Color(0xFF1E293B),
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                service['description'],
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Color(0xFF64748B),
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Color(0xFF64748B),
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Handle emergency service
        },
        icon: Icon(Icons.emergency),
        label: Text('خدمة طارئة'),
        backgroundColor: Color(0xFFDC2626),
      ),
    );
  }

  void _navigateToService(BuildContext context, Map<String, dynamic> service) {
    if (service['title'] == 'تجديد رخصة السيارة') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LicenseRenewalScreen()),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Icon(service['icon'], color: service['color']),
              SizedBox(width: 8),
              Text(service['title']),
            ],
          ),
          content: Text('سيتم إضافة هذه الخدمة قريباً'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('حسناً'),
            ),
          ],
        ),
      );
    }
  }
}
