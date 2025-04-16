import 'package:chatbot/screens/violations_query.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class TrafficQueriesScreen extends StatefulWidget {
  @override
  _TrafficQueriesScreenState createState() => _TrafficQueriesScreenState();
}

class _TrafficQueriesScreenState extends State<TrafficQueriesScreen> {
  final List<Map<String, dynamic>> _queries = [
    {
      'title': 'الاستعلام عن المخالفات',
      'icon': Icons.warning_rounded,
      'color': Colors.orange,
    },
    {
      'title': 'رخصة القيادة',
      'icon': Icons.credit_card,
      'color': Colors.blue,
    },
    {
      'title': 'رخصة المركبة',
      'icon': Icons.directions_car,
      'color': Colors.green,
    },
    {
      'title': 'النقاط المرورية',
      'icon': Icons.star_border,
      'color': Colors.red,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('خدمة الاستعلامات',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF10B981), Color(0xFF059669)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: _queries
              .map(
                (query) => FadeInUp(
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
                        backgroundColor: query['color'].withOpacity(0.1),
                        child: Icon(query['icon'], color: query['color']),
                      ),
                      title: Text(
                        query['title'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        if (_queries.indexOf(query) == 0) {
                          // Navigate to the violations screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViolationInquiryScreen(),
                            ),
                          );
                        } else if (_queries.indexOf(query) == 1) {
                          // Navigate to the driving license screen
                          Navigator.pushNamed(context, '/driving_license');
                        } else if (_queries.indexOf(query) == 2) {
                          // Navigate to the vehicle license screen
                          Navigator.pushNamed(context, '/vehicle_license');
                        } else if (_queries.indexOf(query) == 3) {
                          // Navigate to the traffic points screen
                          Navigator.pushNamed(context, '/traffic_points');
                        }

                        // Handle query selection
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('سيتم إضافة هذه الخدمة قريباً'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
