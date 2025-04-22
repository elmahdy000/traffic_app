import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';
import 'package:chatbot/screens/settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nationalIdController = TextEditingController();
  final _addressController = TextEditingController();
  String _selectedGender = 'ذكر';
  DateTime? _selectedBirthDate;
  bool _isLoading = false;
  bool _isEditing = false;

  final List<String> _genders = ['ذكر', 'أنثى'];

  final List<Map<String, dynamic>> _documents = [
    {
      'title': 'صورة البطاقة الشخصية',
      'icon': Icons.credit_card,
      'uploaded': false
    },
    {'title': 'رخصة القيادة', 'icon': Icons.drive_eta, 'uploaded': false},
    {'title': 'رخصة السيارة', 'icon': Icons.directions_car, 'uploaded': false},
    {'title': 'وثيقة التأمين', 'icon': Icons.security, 'uploaded': false},
  ];

  @override
  void initState() {
    super.initState();
    // Simulate loading profile data
    _loadProfileData();
  }

  void _loadProfileData() {
    // Simulate API call to load profile data
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _nameController.text = 'أحمد محمد';
        _emailController.text = 'ahmed@example.com';
        _phoneController.text = '0123456789';
        _nationalIdController.text = '1234567890';
        _addressController.text = 'القاهرة، مصر';
        _selectedGender = 'ذكر';
        _selectedBirthDate = DateTime(1990, 1, 1);
      });
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime.now(),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedBirthDate) {
      setState(() {
        _selectedBirthDate = picked;
      });
    }
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    String? hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    bool isMultiLine = false,
  }) {
    return FadeInUp(
      duration: Duration(milliseconds: 500),
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: Theme.of(context).primaryColor),
                SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: _isEditing ? Colors.white : Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                boxShadow: _isEditing
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: TextFormField(
                controller: controller,
                keyboardType: keyboardType,
                maxLines: isMultiLine ? 3 : 1,
                enabled: _isEditing,
                validator: validator,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF1E293B),
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: hint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color:
                          _isEditing ? Color(0xFFE2E8F0) : Colors.transparent,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color:
                          _isEditing ? Color(0xFFE2E8F0) : Colors.transparent,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  filled: true,
                  fillColor: _isEditing ? Colors.white : Color(0xFFF8FAFC),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
          _isEditing = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم حفظ الملف الشخصي بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
      });
    }
  }

  void _handleDocumentUpload(int index) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'رفع ${_documents[index]['title']}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _uploadOption(
                  icon: Icons.camera_alt,
                  title: 'الكاميرا',
                  onTap: () {
                    // Handle camera capture
                    Navigator.pop(context);
                    setState(() {
                      _documents[index]['uploaded'] = true;
                    });
                  },
                ),
                _uploadOption(
                  icon: Icons.photo_library,
                  title: 'المعرض',
                  onTap: () {
                    // Handle gallery pick
                    Navigator.pop(context);
                    setState(() {
                      _documents[index]['uploaded'] = true;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _uploadOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Theme.of(context).primaryColor, size: 32),
          ),
          SizedBox(height: 8),
          Text(title),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF8FAFC),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Theme.of(context).primaryColor, Color(0xFF3B82F6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Text(
                          'الملف الشخصي',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            _isEditing ? Icons.check : Icons.edit,
                            color: Colors.white,
                          ),
                          onPressed: _isEditing ? _saveProfile : _toggleEdit,
                        ),
                      ],
                    ),
                  ),
                  FadeIn(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                  image: DecorationImage(
                                    image:
                                        AssetImage('assets/default_avatar.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              if (_isEditing)
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 8,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.camera_alt,
                                    size: 20,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Text(
                            _nameController.text,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            _emailController.text,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    _buildInputField(
                      label: 'الاسم الكامل',
                      controller: _nameController,
                      icon: Icons.person_outline,
                      hint: 'أدخل اسمك الكامل',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال الاسم';
                        }
                        return null;
                      },
                    ),
                    _buildInputField(
                      label: 'البريد الإلكتروني',
                      controller: _emailController,
                      icon: Icons.email_outlined,
                      hint: 'أدخل بريدك الإلكتروني',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال البريد الإلكتروني';
                        }
                        return null;
                      },
                    ),
                    _buildInputField(
                      label: 'رقم الهاتف',
                      controller: _phoneController,
                      icon: Icons.phone_outlined,
                      hint: 'أدخل رقم هاتفك',
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال رقم الهاتف';
                        }
                        return null;
                      },
                    ),
                    _buildInputField(
                      label: 'الرقم القومي',
                      controller: _nationalIdController,
                      icon: Icons.badge_outlined,
                      hint: 'أدخل رقمك القومي',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال الرقم القومي';
                        }
                        return null;
                      },
                    ),
                    FadeInUp(
                      duration: Duration(milliseconds: 500),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.person_outline,
                                    size: 20,
                                    color: Theme.of(context).primaryColor),
                                SizedBox(width: 8),
                                Text(
                                  'الجنس',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Container(
                              decoration: BoxDecoration(
                                color: _isEditing
                                    ? Colors.white
                                    : Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: _isEditing
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 10,
                                          offset: Offset(0, 4),
                                        ),
                                      ]
                                    : [],
                              ),
                              child: DropdownButtonFormField<String>(
                                value: _selectedGender,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: _isEditing
                                          ? Color(0xFFE2E8F0)
                                          : Colors.transparent,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: _isEditing
                                          ? Color(0xFFE2E8F0)
                                          : Colors.transparent,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  filled: true,
                                  fillColor: _isEditing
                                      ? Colors.white
                                      : Color(0xFFF8FAFC),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                ),
                                items: _genders.map((String gender) {
                                  return DropdownMenuItem<String>(
                                    value: gender,
                                    child: Text(gender),
                                  );
                                }).toList(),
                                onChanged: _isEditing
                                    ? (String? newValue) {
                                        if (newValue != null) {
                                          setState(() {
                                            _selectedGender = newValue;
                                          });
                                        }
                                      }
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    FadeInUp(
                      duration: Duration(milliseconds: 500),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.calendar_today_outlined,
                                    size: 20,
                                    color: Theme.of(context).primaryColor),
                                SizedBox(width: 8),
                                Text(
                                  'تاريخ الميلاد',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            InkWell(
                              onTap: _isEditing
                                  ? () => _selectDate(context)
                                  : null,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                                decoration: BoxDecoration(
                                  color: _isEditing
                                      ? Colors.white
                                      : Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: _isEditing
                                        ? Color(0xFFE2E8F0)
                                        : Colors.transparent,
                                  ),
                                  boxShadow: _isEditing
                                      ? [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.05),
                                            blurRadius: 10,
                                            offset: Offset(0, 4),
                                          ),
                                        ]
                                      : [],
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      size: 20,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      _selectedBirthDate != null
                                          ? '${_selectedBirthDate!.year}/${_selectedBirthDate!.month}/${_selectedBirthDate!.day}'
                                          : 'اختر تاريخ الميلاد',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF1E293B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    _buildInputField(
                      label: 'العنوان',
                      controller: _addressController,
                      icon: Icons.location_on_outlined,
                      hint: 'أدخل عنوانك',
                      isMultiLine: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال العنوان';
                        }
                        return null;
                      },
                    ),
                    FadeInUp(
                      duration: Duration(milliseconds: 500),
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.folder_outlined,
                                    size: 20,
                                    color: Theme.of(context).primaryColor),
                                SizedBox(width: 8),
                                Text(
                                  'الوثائق والمستندات',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: _documents.length,
                              itemBuilder: (context, index) => Card(
                                margin: EdgeInsets.only(bottom: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  leading: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      _documents[index]['icon'],
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  title: Text(_documents[index]['title']),
                                  trailing: _documents[index]['uploaded']
                                      ? Icon(Icons.check_circle,
                                          color: Colors.green)
                                      : Icon(Icons.upload_file,
                                          color:
                                              Theme.of(context).primaryColor),
                                  onTap: () => _handleDocumentUpload(index),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    FadeInUp(
                      delay: Duration(milliseconds: 400),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              leading: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Color(0xFF3B82F6).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.settings,
                                  color: Color(0xFF3B82F6),
                                ),
                              ),
                              title: Text(
                                'الإعدادات',
                                style: TextStyle(
                                  color: Color(0xFF1E293B),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Color(0xFF64748B),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SettingsScreen(),
                                  ),
                                );
                              },
                            ),
                            Divider(height: 1),
                            ListTile(
                              leading: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Color(0xFFEF4444).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.logout,
                                  color: Color(0xFFEF4444),
                                ),
                              ),
                              title: Text(
                                'تسجيل الخروج',
                                style: TextStyle(
                                  color: Color(0xFFEF4444),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onTap: () {
                                Navigator.pushReplacementNamed(
                                    context, '/login');
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_isEditing)
                      FadeInUp(
                        duration: Duration(milliseconds: 500),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                  onPressed: () {
                                    setState(() {
                                      _isEditing = false;
                                      // Reset form
                                      _loadProfileData();
                                    });
                                  },
                                  text: 'إلغاء',
                                  backgroundColor: Colors.white,
                                  textColor: Theme.of(context).primaryColor,
                                  borderColor: Theme.of(context).primaryColor,
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: CustomButton(
                                  onPressed: _saveProfile,
                                  text: 'حفظ',
                                  isLoading: _isLoading,
                                ),
                              ),
                            ],
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
