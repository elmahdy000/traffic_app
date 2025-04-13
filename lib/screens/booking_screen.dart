import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_app_bar.dart';

class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  String? selectedCarType;
  String? selectedCarModel;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  int _currentStep = 0;

  final List<Map<String, dynamic>> carTypes = [
    {
      'name': 'سيدان',
      'icon': Icons.directions_car,
      'description': 'سيارة عائلية مريحة',
    },
    {
      'name': 'SUV',
      'icon': Icons.directions_car,
      'description': 'سيارة رياضية متعددة الاستخدامات',
    },
    {
      'name': 'هاتشباك',
      'icon': Icons.directions_car,
      'description': 'سيارة مدمجة اقتصادية',
    },
    {
      'name': 'بيك أب',
      'icon': Icons.local_shipping,
      'description': 'شاحنة صغيرة للنقل',
    },
  ];

  final List<Map<String, dynamic>> carModels = [
    {
      'name': 'تويوتا كورولا',
      'year': '2024',
      'image': 'assets/toyota.png',
    },
    {
      'name': 'هيونداي النترا',
      'year': '2024',
      'image': 'assets/hyundai.png',
    },
    {
      'name': 'مرسيدس C200',
      'year': '2024',
      'image': 'assets/mercedes.png',
    },
    {
      'name': 'بي إم دبليو X5',
      'year': '2024',
      'image': 'assets/bmw.png',
    },
  ];

  bool isBooked = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF1E293B),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF1E293B),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  Widget _buildCarTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'اختر نوع السيارة',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Color(0xFF1E293B),
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: carTypes.length,
          itemBuilder: (context, index) {
            final type = carTypes[index];
            final isSelected = selectedCarType == type['name'];
            return FadeInUp(
              delay: Duration(milliseconds: 100 * index),
              child: InkWell(
                onTap: () {
                  setState(() {
                    selectedCarType = type['name'];
                  });
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? Theme.of(context).primaryColor : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? Theme.of(context).primaryColor : Color(0xFFE2E8F0),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        type['icon'],
                        size: 32,
                        color: isSelected ? Colors.white : Theme.of(context).primaryColor,
                      ),
                      SizedBox(height: 8),
                      Text(
                        type['name'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : Color(0xFF1E293B),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        type['description'],
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? Colors.white70 : Color(0xFF64748B),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCarModelSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'اختر موديل السيارة',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Color(0xFF1E293B),
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: carModels.length,
          itemBuilder: (context, index) {
            final model = carModels[index];
            final isSelected = selectedCarModel == model['name'];
            return FadeInUp(
              delay: Duration(milliseconds: 100 * index),
              child: Container(
                margin: EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      selectedCarModel = model['name'];
                    });
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected ? Theme.of(context).primaryColor : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? Theme.of(context).primaryColor : Color(0xFFE2E8F0),
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white24 : Theme.of(context).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.directions_car,
                            size: 32,
                            color: isSelected ? Colors.white : Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                model['name'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected ? Colors.white : Color(0xFF1E293B),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'موديل ${model['year']}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isSelected ? Colors.white70 : Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.check_circle,
                          color: isSelected ? Colors.white : Colors.transparent,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDateTimeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'اختر موعد الحجز',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Color(0xFF1E293B),
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 16),
        InkWell(
          onTap: () => _selectDate(context),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.calendar_today,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'التاريخ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        selectedDate != null
                            ? DateFormat('yyyy/MM/dd').format(selectedDate!)
                            : 'اختر التاريخ',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF64748B)),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
        InkWell(
          onTap: () => _selectTime(context),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.access_time,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'الوقت',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        selectedTime != null
                            ? selectedTime!.format(context)
                            : 'اختر الوقت',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF64748B)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'حجز موعد',
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white24,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.calendar_month, color: Colors.white, size: 24),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF8FAFC),
        ),
        child: Stepper(
          currentStep: _currentStep,
          onStepTapped: (step) => setState(() => _currentStep = step),
          controlsBuilder: (context, details) {
            return Padding(
              padding: EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    CustomButton(
                      text: 'السابق',
                      onPressed: details.onStepCancel ?? () {},
                      isOutlined: true,
                    ),
                  SizedBox(width: 16),
                  CustomButton(
                    text: _currentStep == 2 ? 'تأكيد الحجز' : 'التالي',
                    onPressed: details.onStepContinue ?? () {},
                  ),
                ],
              ),
            );
          },
          onStepContinue: () {
            if (_currentStep < 2) {
              setState(() => _currentStep++);
            } else {
              // Handle booking confirmation
              setState(() => isBooked = true);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم تأكيد الحجز بنجاح'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() => _currentStep--);
            }
          },
          steps: [
            Step(
              title: Text('نوع السيارة'),
              content: _buildCarTypeSelector(),
              isActive: _currentStep >= 0,
              state: _currentStep > 0 ? StepState.complete : StepState.indexed,
            ),
            Step(
              title: Text('موديل السيارة'),
              content: _buildCarModelSelector(),
              isActive: _currentStep >= 1,
              state: _currentStep > 1 ? StepState.complete : StepState.indexed,
            ),
            Step(
              title: Text('الموعد'),
              content: _buildDateTimeSelector(),
              isActive: _currentStep >= 2,
              state: _currentStep > 2 ? StepState.complete : StepState.indexed,
            ),
          ],
        ),
      ),
    );
  }
}
