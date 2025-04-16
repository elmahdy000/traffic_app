import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:animate_do/animate_do.dart';

class CarInspectionScreen extends StatefulWidget {
  @override
  _CarInspectionScreenState createState() => _CarInspectionScreenState();
}

class _CarInspectionScreenState extends State<CarInspectionScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _carModel, _carYear;
  List<String> _plateLetters = List.filled(3, '');
  List<String> _plateNumbers = List.filled(4, '');
  File? _carImage, _licenseDoc, _inspectionRequestForm;
  bool _submitted = false;

  Future<void> _pickImage(Function(File) onPicked) async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        onPicked(File(picked.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'طلب فحص السيارة',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0288D1), Color(0xFF4FC3F7)],
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
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0288D1), Color(0xFF4FC3F7)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStepIndicator(
                    1, Icons.directions_car, 'بيانات السيارة', true),
                _buildStepIndicator(2, Icons.upload_file, 'المستندات', false),
                _buildStepIndicator(3, Icons.check_circle, 'التأكيد', false),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              physics: BouncingScrollPhysics(),
              child: _submitted
                  ? _buildSubmissionMessage()
                  : Form(
                      key: _formKey,
                      child: FadeInUp(
                        duration: Duration(milliseconds: 600),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildCard(
                              'بيانات السيارة',
                              Icons.directions_car,
                              [
                                _buildAnimatedTextField(
                                  'موديل السيارة',
                                  Icons.directions_car,
                                  (val) => _carModel = val,
                                ),
                                SizedBox(height: 16),
                                _buildAnimatedTextField(
                                  'سنة الصنع',
                                  Icons.date_range,
                                  (val) => _carYear = val,
                                  isNumber: true,
                                ),
                                SizedBox(height: 20),
                                _buildPlateInput(),
                              ],
                            ),
                            SizedBox(height: 24),
                            _buildCard(
                              'المستندات المطلوبة',
                              Icons.upload_file,
                              [
                                _buildUploadSection(
                                  'صورة السيارة',
                                  _carImage,
                                  () => _pickImage(
                                      (f) => setState(() => _carImage = f)),
                                ),
                                _buildUploadSection(
                                  'صورة الرخصة',
                                  _licenseDoc,
                                  () => _pickImage(
                                      (f) => setState(() => _licenseDoc = f)),
                                ),
                                _buildUploadSection(
                                  'نموذج طلب الفحص',
                                  _inspectionRequestForm,
                                  () => _pickImage((f) => setState(
                                      () => _inspectionRequestForm = f)),
                                ),
                              ],
                            ),
                            SizedBox(height: 32),
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

  Widget _buildStepIndicator(
      int step, IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor:
              isActive ? Colors.white : Colors.white.withOpacity(0.6),
          child: Icon(
            icon,
            size: 28,
            color: isActive ? Color(0xFF0288D1) : Colors.grey[400],
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildCard(String title, IconData icon, List<Widget> children) {
    return Card(
      elevation: 12,
      shadowColor: Colors.blue.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.1),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Color(0xFF0288D1).withOpacity(0.1),
                    child: Icon(icon, size: 28, color: Color(0xFF0288D1)),
                  ),
                  SizedBox(width: 16),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[900],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              ...children,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlateInput() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: Color(0xFF0288D1).withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF0288D1).withOpacity(0.1),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.directions_car, color: Color(0xFF0288D1), size: 24),
              SizedBox(width: 12),
              Text(
                'رقم اللوحة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Color(0xFF0288D1).withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        3,
                        (i) => Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 2),
                            child: _buildOtpBox(isLetter: true, index: i),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Color(0xFF0288D1).withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        4,
                        (i) => Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 2),
                            child: _buildOtpBox(isLetter: false, index: i),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUploadSection(String title, File? file, VoidCallback onPressed) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 12),
          InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: file != null ? Colors.green[50] : Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: file != null ? Colors.green[400]! : Colors.grey[300]!,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    file != null ? Icons.check_circle : Icons.upload_file,
                    size: 28,
                    color: file != null ? Colors.green[600] : Colors.grey[600],
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      file != null ? 'تم التحميل' : 'اضغط للتحميل',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color:
                            file != null ? Colors.green[600] : Colors.grey[700],
                      ),
                    ),
                  ),
                  if (file != null)
                    Icon(
                      Icons.done_all,
                      color: Colors.green[600],
                      size: 24,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate() &&
              _validatePlate() &&
              _validateUploads()) {
            setState(() => _submitted = true);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "برجاء إكمال كافة الحقول والمستندات المطلوبة",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                backgroundColor: Colors.red[600],
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 18, horizontal: 24),
          backgroundColor: Color(0xFF0288D1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.send, size: 24, color: Colors.white),
            SizedBox(width: 12),
            Text(
              'إرسال الطلب',
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

  Widget _buildSubmissionMessage() {
    return FadeInUp(
      duration: Duration(milliseconds: 600),
      child: Card(
        elevation: 12,
        shadowColor: Colors.green.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.1),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ZoomIn(
                  duration: Duration(milliseconds: 400),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.green[600],
                      size: 80,
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'تم إرسال طلب الفحص بنجاح',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.green[800],
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'سيتم مراجعة طلبك من قبل الإدارة العامة للمرور\nوسيتم إشعارك بالحالة قريباً',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _submitted = false;
                      _carModel = null;
                      _carYear = null;
                      _plateLetters = List.filled(3, '');
                      _plateNumbers = List.filled(4, '');
                      _carImage = null;
                      _licenseDoc = null;
                      _inspectionRequestForm = null;
                      _formKey.currentState?.reset();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'إنشاء طلب جديد',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtpBox({required bool isLetter, required int index}) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF0288D1).withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        maxLength: 1,
        textAlign: TextAlign.center,
        textCapitalization:
            isLetter ? TextCapitalization.characters : TextCapitalization.none,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0288D1),
          letterSpacing: 1.2,
        ),
        keyboardType: isLetter ? TextInputType.text : TextInputType.number,
        decoration: InputDecoration(
          counterText: '',
          hintText: isLetter ? 'أ' : '٠',
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xFF0288D1), width: 2.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red[400]!, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red[400]!, width: 2.5),
          ),
        ),
        onChanged: (val) {
          setState(() {
            if (isLetter) {
              _plateLetters[index] = val.toUpperCase();
            } else {
              _plateNumbers[index] = val;
            }

            // Auto-focus next field with animation
            if (val.isNotEmpty) {
              if (isLetter && index < 2 || !isLetter && index < 3) {
                FocusScope.of(context).nextFocus();
              } else {
                FocusScope.of(context).unfocus();
              }
            }
          });
        },
        validator: (val) {
          if (val == null || val.isEmpty) {
            return '';
          }
          if (!isLetter && !RegExp(r'^[0-9]$').hasMatch(val)) {
            return '';
          }
          if (isLetter && !RegExp(r'^[أ-ي]$').hasMatch(val)) {
            return '';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildAnimatedTextField(
      String label, IconData icon, Function(String) onChanged,
      {bool isNumber = false}) {
    return FadeInUp(
      duration: Duration(milliseconds: 400),
      child: TextFormField(
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.grey[900],
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
          prefixIcon: Icon(icon, color: Color(0xFF0288D1), size: 24),
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
            borderSide: BorderSide(color: Color(0xFF0288D1), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.red[400]!, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.red[400]!, width: 2),
          ),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? 'برجاء إدخال $label' : null,
        onChanged: onChanged,
      ),
    );
  }

  bool _validatePlate() {
    return _plateLetters.every((element) => element.isNotEmpty) &&
        _plateNumbers.every((element) => element.isNotEmpty);
  }

  bool _validateUploads() {
    return _carImage != null &&
        _licenseDoc != null &&
        _inspectionRequestForm != null;
  }
}
