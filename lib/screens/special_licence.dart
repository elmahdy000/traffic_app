import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SpecialNeedsLicenseScreen extends StatefulWidget {
  @override
  _SpecialNeedsLicenseScreenState createState() =>
      _SpecialNeedsLicenseScreenState();
}

class _SpecialNeedsLicenseScreenState extends State<SpecialNeedsLicenseScreen>
    with SingleTickerProviderStateMixin {
  String selectedTab = 'رخصة مركبة';
  String? selectedVehicleType;
  String? selectedBookingDate;
  bool showBookingSection = false;
  bool showResult = false;

  String? fullName, nationalId, trafficClass, medicalType, medicalDate;

  final List<String> tabs = ['رخصة مركبة', 'رخصة شخصية', 'كارت فحص فني'];
  final List<String> vehicleTypes = ['ملاكي', 'أجرة', 'نقل', 'دراجة نارية'];

  double calculatePrice(String? type) {
    switch (type) {
      case 'ملاكي':
        return 250.0;
      case 'أجرة':
        return 300.0;
      case 'نقل':
        return 350.0;
      case 'دراجة نارية':
        return 200.0;
      default:
        return 0.0;
    }
  }

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025, 12, 31),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF1E88E5),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedBookingDate = DateFormat('yyyy-MM-dd').format(picked);
        showBookingSection = true;
        showResult = false;
        _animationController.reset();
        _animationController.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'الحجز',
            style: TextStyle(color: Colors.white),
          ),
          bottom: TabBar(
            onTap: (index) {
              setState(() {
                selectedTab = tabs[index];
                showBookingSection = false;
                showResult = false;
              });
            },
            tabs: tabs.map((tab) => Tab(text: tab)).toList(),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E88E5), Color(0xFF3B82F6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: tabs.map((tab) {
            if (tab == 'رخصة شخصية') {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'الاسم',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (val) => fullName = val,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'الرقم القومي',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (val) => nationalId = val,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'الفئة المرورية',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (val) => trafficClass = val,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'نوع الفحص الطبي',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (val) => medicalType = val,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'موعد الفحص الطبي',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (val) => medicalDate = val,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showResult = true;
                          _animationController.forward();
                        });
                      },
                      child: const Text('حجز'),
                    ),
                    const SizedBox(height: 20),
                    if (showResult)
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            border: Border.all(color: Colors.blue),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '📋 الأوراق المطلوبة:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              SizedBox(height: 8),
                              Text('• بطاقة الرقم القومي سارية'),
                              Text('• إثبات محل الإقامة'),
                              Text('• عدد 2 صورة شخصية حديثة'),
                              Text('• نتيجة الفحص الطبي'),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }

            // رخصة مركبة
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'نوع المركبة',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        value: selectedVehicleType,
                        items: vehicleTypes.map((type) {
                          return DropdownMenuItem(
                              value: type, child: Text(type));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedVehicleType = value;
                            showBookingSection = false;
                            showResult = false;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (selectedVehicleType != null) {
                        _selectDate(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('اختر نوع المركبة أولًا')),
                        );
                      }
                    },
                    icon: Icon(Icons.calendar_today),
                    label: Text('اختيار موعد حجز'),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (showBookingSection) ...[
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text(
                                'تم اختيار الموعد: $selectedBookingDate',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    showResult = true;
                                    _animationController.reset();
                                    _animationController.forward();
                                  });
                                },
                                icon: Icon(Icons.check_circle),
                                label: Text('تأكيد الحجز'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  if (showResult)
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '📋 الأوراق المطلوبة:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            const Text('• بطاقة الرقم القومي سارية'),
                            const Text('• صورة شخصية'),
                            const Text('• تقرير طبي معتمد'),
                            const SizedBox(height: 16),
                            Text(
                              '💰 السعر: ${calculatePrice(selectedVehicleType).toStringAsFixed(2)} جنيه',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
