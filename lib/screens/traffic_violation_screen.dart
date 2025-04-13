import 'package:flutter/material.dart';

class TrafficViolationsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> violations = [
    {
      'violation': 'السير دون رخصة قيادة',
      'fine': '1000 - 3000 جنيه',
      'icon': Icons.drive_eta
    },
    {
      'violation': 'القيادة تحت تأثير المخدرات',
      'fine': '5000 - 10000 جنيه',
      'icon': Icons.warning
    },
    {
      'violation': 'تجاوز السرعة المقررة',
      'fine': '100 - 3000 جنيه',
      'icon': Icons.speed
    },
    {
      'violation': 'التوقف المتعمد على الكوبري',
      'fine': '100 - 500 جنيه',
      'icon': Icons.stop
    },
    {
      'violation': 'عدم اتباع تعليمات رجال المرور',
      'fine': '200 - 500 جنيه',
      'icon': Icons.security
    },
    {
      'violation': 'كسر إشارة المرور',
      'fine': '100 - 2000 جنيه',
      'icon': Icons.traffic
    },
    {
      'violation': 'استخدام الهاتف أثناء القيادة',
      'fine': '100 - 500 جنيه',
      'icon': Icons.phone_android
    },
    {
      'violation': 'المشي ببطء شديد على الجسر',
      'fine': '100 - 500 جنيه',
      'icon': Icons.directions_car
    },
    {
      'violation': 'الوقوف في المحظور',
      'fine': '100 - 500 جنيه',
      'icon': Icons.local_parking
    },
    {
      'violation': 'عدم تثبيت اللوحات المعدنية',
      'fine': '500 - 1500 جنيه',
      'icon': Icons.car_rental
    },
    {
      'violation': 'عدم وضوح اللوحات المعدنية',
      'fine': '200 - 500 جنيه',
      'icon': Icons.visibility
    },
    {
      'violation': 'استخدام لوحات غير خاصة بالمركبة',
      'fine': '300 - 1500 جنيه',
      'icon': Icons.car_repair
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Light background
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Blue Card Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[700], // Blue card color
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'المخالفات المرورية',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'تعرف على المخالفات المرورية والغرامات المرتبطة بها',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              // List of Violations
              ListView.builder(
                shrinkWrap: true, // To fit inside SingleChildScrollView
                physics: NeverScrollableScrollPhysics(), // Disable inner scrolling
                itemCount: violations.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: Icon(
                        violations[index]['icon'] as IconData,
                        color: Colors.grey[800],
                        size: 24,
                      ),
                      title: Text(
                        violations[index]['violation'] as String,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                      subtitle: Text(
                        'الغرامة: ${violations[index]['fine']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.red[600], // Red for fine amount
                        ),
                      ),
                      trailing: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[200],
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      onTap: () {
                        // Add navigation or details if needed
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}