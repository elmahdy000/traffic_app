import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:animate_do/animate_do.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class LicenseRenewalScreen extends StatefulWidget {
  @override
  _LicenseRenewalScreenState createState() => _LicenseRenewalScreenState();
}

class _LicenseRenewalScreenState extends State<LicenseRenewalScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _plateNumber, _idNumber, _chassisNumber, _engineNumber;
  File? _idImage, _insuranceDoc;
  String? _paymentMethod;
  bool _isLoading = false;
  int _currentStep = 1;
  final int _totalSteps = 3;

  final List<String> _paymentOptions = ['بطاقة بنكية', 'فوري', 'فودافون كاش'];

  Future<void> _pickImage(Function(File) onImagePicked) async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      onImagePicked(File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('تجديد رخصة السيارة',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1E88E5), Color(0xFF64B5F6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E88E5), Color(0xFF64B5F6)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                LinearPercentIndicator(
                  width: MediaQuery.of(context).size.width - 32,
                  lineHeight: 8.0,
                  percent: _currentStep / _totalSteps,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  progressColor: Colors.white,
                  barRadius: Radius.circular(4),
                ),
                SizedBox(height: 8),
                Text(
                  'الخطوة $_currentStep من $_totalSteps',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: FadeInUp(
                  child: Column(
                    children: [
                      _buildEnhancedCard(
                        icon: Icons.directions_car,
                        title: 'بيانات المركبة',
                        children: [
                          _buildAnimatedTextField(
                              'رقم اللوحة',
                              Icons.directions_car,
                              (value) => _plateNumber = value),
                          _buildAnimatedTextField('رقم الهوية', Icons.person,
                              (value) => _idNumber = value),
                          _buildAnimatedTextField(
                              'رقم الشاسيه',
                              Icons.confirmation_number,
                              (value) => _chassisNumber = value),
                          _buildAnimatedTextField('رقم المحرك', Icons.build,
                              (value) => _engineNumber = value),
                        ],
                      ),
                      SizedBox(height: 16),
                      _buildEnhancedCard(
                        icon: Icons.upload_file,
                        title: 'الوثائق المطلوبة',
                        children: [
                          _buildUploadButton(
                            'صورة البطاقة',
                            _idImage,
                            () => _pickImage(
                                (file) => setState(() => _idImage = file)),
                          ),
                          SizedBox(height: 12),
                          _buildUploadButton(
                            'وثيقة التأمين',
                            _insuranceDoc,
                            () => _pickImage(
                                (file) => setState(() => _insuranceDoc = file)),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      _buildEnhancedCard(
                        icon: Icons.payment,
                        title: 'طريقة الدفع',
                        children: [
                          _buildPaymentMethodSelector(),
                        ],
                      ),
                      SizedBox(height: 24),
                      _buildSubmitButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Icon(icon, color: Color(0xFF1E88E5), size: 24),
                SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E88E5),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedTextField(
      String label, IconData icon, Function(String) onSaved) {
    return FadeInLeft(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: TextFormField(
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            prefixIcon: Icon(icon, color: Color(0xFF1E88E5)),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          validator: (value) =>
              value == null || value.isEmpty ? 'الرجاء إدخال $label' : null,
          onSaved: (value) => onSaved(value!),
        ),
      ),
    );
  }

  Widget _buildUploadButton(String title, File? file, VoidCallback onPressed) {
    final bool isUploaded = file != null;
    return Container(
      width: double.infinity,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            backgroundColor: isUploaded ? Colors.green[600] : Colors.white,
            elevation: isUploaded ? 0 : 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: isUploaded ? Colors.transparent : Colors.blue[300]!,
                width: 1.5,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isUploaded ? Icons.check_circle : Icons.cloud_upload,
                color: isUploaded ? Colors.white : Colors.blue[600],
                size: 24,
              ),
              SizedBox(width: 12),
              Text(
                isUploaded ? 'تم تحميل $title' : 'تحميل $title',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isUploaded ? Colors.white : Colors.blue[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: _paymentOptions.map((method) {
          final isSelected = _paymentMethod == method;
          IconData icon;
          switch (method) {
            case 'بطاقة بنكية':
              icon = Icons.credit_card;
              break;
            case 'فوري':
              icon = Icons.local_atm;
              break;
            case 'فودافون كاش':
              icon = Icons.account_balance_wallet;
              break;
            default:
              icon = Icons.payment;
          }

          return InkWell(
            onTap: () => setState(() => _paymentMethod = method),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[200]!,
                    width: 1,
                  ),
                ),
                color: isSelected ? Colors.blue[50] : Colors.white,
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue[100] : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon,
                        color:
                            isSelected ? Colors.blue[700] : Colors.grey[600]),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      method,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Colors.blue[700] : Colors.grey[800],
                      ),
                    ),
                  ),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:
                            isSelected ? Colors.blue[700]! : Colors.grey[400]!,
                        width: 2,
                      ),
                      color: isSelected ? Colors.blue[700] : Colors.white,
                    ),
                    child: isSelected
                        ? Icon(Icons.check, size: 16, color: Colors.white)
                        : null,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      child: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 20),
                backgroundColor: Color(0xFF1E88E5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                shadowColor: Colors.blue[200],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline, size: 24),
                  SizedBox(width: 12),
                  Text(
                    'إتمام عملية التجديد',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      setState(() => _isLoading = true);

      Future.delayed(Duration(seconds: 2), () {
        setState(() => _isLoading = false);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('تم التجديد'),
            content: Text(
                'تم استلام جميع البيانات وتم دفع الرسوم. سيتم إصدار الرخصة الجديدة خلال 3 أيام عمل.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('حسناً'),
              ),
            ],
          ),
        );
      });
    }
  }
}
