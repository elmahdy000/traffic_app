import 'package:flutter/material.dart';
import 'package:chatbot/screens/chat_screen2.dart';
import 'package:chatbot/screens/gpt_screen.dart';
import 'package:chatbot/screens/special_licence.dart';
import 'package:chatbot/screens/booking_screen.dart';
import 'package:chatbot/screens/penalities_screen.dart';
import 'package:chatbot/screens/traffic_violation_screen.dart';
import 'package:chatbot/screens/annual_tax_screen.dart';
import 'package:chatbot/screens/chat_screen.dart';
import 'package:chatbot/screens/electronic_service_screen.dart';
import 'package:chatbot/screens/licence_screen.dart';
import 'package:chatbot/screens/vehicle_services_screen.dart';
import 'package:chatbot/screens/notifications_screen.dart';
import 'package:chatbot/screens/profile_screen.dart';
import 'package:animate_do/animate_do.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> _menuItems = [
    {
      'title': 'خدمات المركبات',
      'screen': VehicleServicesScreen(),
      'icon': Icons.directions_car,
      'color': Color(0xFF3B82F6),
      'description': 'إدارة جميع خدمات مركبتك',
    },
    {
      'title': 'حساب رسوم الترخيص',
      'screen': SpecialNeedsLicenseScreen(),
      'icon': Icons.calculate,
      'color': Color(0xFF10B981),
      'description': 'حساب رسوم ترخيص مركبتك',
    },
    {
      'title': 'المخالفات المرورية',
      'screen': TrafficViolationsScreen(),
      'icon': Icons.warning_rounded,
      'color': Color(0xFFF59E0B),
      'description': 'عرض وإدارة المخالفات',
    },
    {
      'title': 'الضرائب السنوية',
      'screen': AnnualTaxesScreen(),
      'icon': Icons.account_balance_wallet,
      'color': Color(0xFF8B5CF6),
      'description': 'حساب وعرض الضرائب',
    },
    {
      'title': 'الخدمات الإلكترونية',
      'screen': ElectronicServicesScreen(),
      'icon': Icons.devices,
      'color': Color(0xFFEC4899),
      'description': 'خدمات رقمية متكاملة',
    },
    {
      'title': 'العقوبات',
      'screen': PenaltiesScreen(),
      'icon': Icons.gavel,
      'color': Color(0xFFEF4444),
      'description': 'عرض وإدارة العقوبات',
    },
    {
      'title': 'حجز موعد',
      'screen': BookingScreen(),
      'icon': Icons.calendar_month,
      'color': Color(0xFF6366F1),
      'description': 'حجز موعد للخدمات',
    },
    {
      'title': 'تراخيص خاصة',
      'screen': SpecialNeedsLicenseScreen(),
      'icon': Icons.accessible,
      'color': Color(0xFF14B8A6),
      'description': 'خدمات ذوي الاحتياجات',
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0: // Home
        // Already on home screen
        break;
      case 1: // Notifications
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NotificationsScreen()),
        );
        break;
      case 2: // Assistant
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatScreen2()),
        );
        break;
      case 3: // Profile
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
        break;
    }
  }

  void _navigateToScreen(int index) {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => _menuItems[index]['screen']),
      ).then((_) => setState(() {}));
    } catch (e) {
      print('Error navigating to screen: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ أثناء فتح الشاشة'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor,
              Color(0xFFF8FAFC),
              Color(0xFFF8FAFC),
            ],
            stops: [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: FadeIn(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'مرحباً بك',
                                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'كيف يمكننا مساعدتك اليوم؟',
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.notifications_none,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24),
                        Container(
                          padding: EdgeInsets.all(16),
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
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Color(0xFFF59E0B).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.campaign,
                                  color: Color(0xFFF59E0B),
                                  size: 24,
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'هل تحتاج إلى مساعدة؟',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            color: Color(0xFF1E293B),
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'تحدث مع المساعد الذكي',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: Color(0xFF64748B),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ChatScreen2()),
                                  );
                                },
                                icon: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return FadeInUp(
                        delay: Duration(milliseconds: 100 * index),
                        child: InkWell(
                          onTap: () => _navigateToScreen(index),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: _menuItems[index]['color'].withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Icon(
                                    _menuItems[index]['icon'],
                                    color: _menuItems[index]['color'],
                                    size: 32,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: Text(
                                    _menuItems[index]['title'],
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          color: Color(0xFF1E293B),
                                          fontWeight: FontWeight.w600,
                                        ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: Text(
                                    _menuItems[index]['description'],
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: Color(0xFF64748B),
                                        ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: _menuItems.length,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: 20),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Color(0xFF64748B),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_rounded),
              label: 'الإشعارات',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_rounded),
              label: 'المساعد',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'حسابي',
            ),
          ],
        ),
      ),
    );
  }
}
