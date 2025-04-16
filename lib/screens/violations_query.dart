import 'package:flutter/material.dart';
import 'dart:async';
import 'package:animate_do/animate_do.dart';

class ViolationInquiryScreen extends StatefulWidget {
  @override
  _ViolationInquiryScreenState createState() => _ViolationInquiryScreenState();
}

class _ViolationInquiryScreenState extends State<ViolationInquiryScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _plateLettersController = TextEditingController();
  final TextEditingController _plateNumbersController = TextEditingController();
  bool _loading = false;
  bool _hasResult = false;
  List<String> _violations = [];

  void _submitInquiry() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
        _hasResult = false;
        _violations = [];
      });
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _loading = false;
          _hasResult = true;
          _violations = [
            'تجاوز السرعة - 300 جنيه',
            'ركن صف ثاني - 100 جنيه',
            'عدم ارتداء حزام الأمان - 50 جنيه'
          ];
        });
      });
    }
  }

  void _payViolations() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.3),
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ZoomIn(
                duration: Duration(milliseconds: 400),
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.green[50],
                  child: Icon(
                    Icons.check_circle,
                    size: 48,
                    color: Colors.green[600],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'تم الدفع',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[900],
                ),
              ),
              SizedBox(height: 12),
              Text(
                'تم دفع جميع المخالفات بنجاح.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _hasResult = false;
                    _violations = [];
                    _plateLettersController.clear();
                    _plateNumbersController.clear();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF388E3C),
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'تم',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'استعلام ودفع المخالفات',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF388E3C), Color(0xFF66BB6A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FadeInUp(
                duration: Duration(milliseconds: 600),
                child: Card(
                  elevation: 12,
                  shadowColor: Colors.green.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor:
                                    Color(0xFF388E3C).withOpacity(0.1),
                                child: Icon(
                                  Icons.directions_car,
                                  size: 28,
                                  color: Color(0xFF388E3C),
                                ),
                              ),
                              SizedBox(width: 16),
                              Text(
                                'إدخال بيانات اللوحة',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey[900],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _plateLettersController,
                                  maxLength: 3,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[900],
                                  ),
                                  decoration: _buildInputDecoration(
                                      'حروف اللوحة', 'أ ب ج'),
                                  validator: (value) =>
                                      value == null || value.length != 3
                                          ? 'أدخل 3 حروف'
                                          : null,
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: _plateNumbersController,
                                  maxLength: 4,
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[900],
                                  ),
                                  decoration: _buildInputDecoration(
                                      'أرقام اللوحة', '1234'),
                                  validator: (value) =>
                                      value == null || value.length != 4
                                          ? 'أدخل 4 أرقام'
                                          : null,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24),
                          _buildSubmitButton('استعلام', _submitInquiry),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
              _loading
                  ? FadeIn(
                      duration: Duration(milliseconds: 400),
                      child: Column(
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF388E3C)),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'جاري الاستعلام عن المخالفات...',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                  : _hasResult
                      ? FadeInUp(
                          duration: Duration(milliseconds: 600),
                          child: Card(
                            elevation: 12,
                            shadowColor: Colors.green.withOpacity(0.3),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24)),
                            child: Padding(
                              padding: EdgeInsets.all(24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 24,
                                        backgroundColor:
                                            Color(0xFF388E3C).withOpacity(0.1),
                                        child: Icon(
                                          Icons.warning,
                                          size: 28,
                                          color: Color(0xFF388E3C),
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      Text(
                                        'نتائج الاستعلام',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.grey[900],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 24),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: _violations.length,
                                    itemBuilder: (context, index) => FadeInUp(
                                      delay:
                                          Duration(milliseconds: 200 * index),
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.warning,
                                          color: Colors.red[600],
                                          size: 28,
                                        ),
                                        title: Text(
                                          _violations[index],
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey[900],
                                          ),
                                        ),
                                        tileColor: Colors.grey[50],
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 24),
                                  _buildSubmitButton(
                                    'دفع المخالفات',
                                    _payViolations,
                                    icon: Icons.payment,
                                    color: Colors.green[600],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Container(),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400]),
      labelStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.grey[600],
      ),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey[300]!, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey[300]!, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Color(0xFF388E3C), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.red[400]!, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.red[400]!, width: 2),
      ),
      counterText: '',
    );
  }

  Widget _buildSubmitButton(String label, VoidCallback onPressed,
      {IconData? icon, Color? color}) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: (color ?? Color(0xFF388E3C)).withOpacity(0.3),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 18, horizontal: 24),
          backgroundColor: color ?? Color(0xFF388E3C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          minimumSize: Size(double.infinity, 56),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 24, color: Colors.white),
              SizedBox(width: 12),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _plateLettersController.dispose();
    _plateNumbersController.dispose();
    super.dispose();
  }
}
