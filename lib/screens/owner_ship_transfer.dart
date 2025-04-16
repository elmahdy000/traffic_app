import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class OwnershipTransferScreen extends StatefulWidget {
  @override
  _OwnershipTransferScreenState createState() =>
      _OwnershipTransferScreenState();
}

class _OwnershipTransferScreenState extends State<OwnershipTransferScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _ownerName, _ownerId, _licenseNumber, _newOwnerName, _newOwnerId;
  File? _carDoc, _inspectionFile, _violationCert;
  bool _submitted = false;

  Future<void> _pickImage(Function(File) onPicked) async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) onPicked(File(picked.path));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('خدمة نقل الملكية'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: _submitted
            ? _buildReviewMessage()
            : Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTextField('اسم صاحب السيارة', Icons.person,
                        (value) => _ownerName = value),
                    _buildTextField('الرقم القومي', Icons.badge,
                        (value) => _ownerId = value,
                        isNumber: true),
                    _buildTextField('رقم الرخصة', Icons.confirmation_number,
                        (value) => _licenseNumber = value),
                    _buildUploadButton('ملف السيارة', _carDoc,
                        () => _pickImage((f) => setState(() => _carDoc = f))),
                    Divider(height: 32),
                    _buildTextField('اسم المنقول إليه', Icons.person_outline,
                        (value) => _newOwnerName = value),
                    _buildTextField('رقم بطاقة المنقول إليه', Icons.credit_card,
                        (value) => _newOwnerId = value,
                        isNumber: true),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() => _submitted = true);
                        }
                      },
                      child: Text('إرسال الطلب'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, Function(String) onSaved,
      {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? 'برجاء إدخال $label' : null,
        onSaved: (value) => onSaved(value!),
      ),
    );
  }

  Widget _buildUploadButton(String title, File? file, VoidCallback onPressed) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(Icons.upload_file),
          label: Text(file != null ? 'تم التحميل' : 'تحميل $title'),
          style: ElevatedButton.styleFrom(
            backgroundColor: file != null ? Colors.green : Colors.blue,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildReviewMessage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(Icons.hourglass_top, size: 80, color: Colors.orangeAccent),
        SizedBox(height: 16),
        Text(
          '✅ تم استلام طلب نقل الملكية بنجاح.',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green[800]),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16),
        _buildDocCard('📄 شهادة فحص السيارة', 'تم تحميلها من قبل المستخدم'),
        _buildDocCard('📄 شهادة المخالفات', 'تم تحميلها من قبل المستخدم'),
        SizedBox(height: 24),
        Text('الطلب الآن قيد المراجعة من إدارة المرور.',
            textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildDocCard(String title, String subtitle) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(Icons.description, color: Colors.blueAccent),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.check_circle, color: Colors.green),
      ),
    );
  }
}
