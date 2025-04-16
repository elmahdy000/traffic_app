import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:animate_do/animate_do.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:flutter/services.dart';

class LicenseRenewalScreen extends StatefulWidget {
  @override
  _LicenseRenewalScreenState createState() => _LicenseRenewalScreenState();
}

class _LicenseRenewalScreenState extends State<LicenseRenewalScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _plateNumber, _idNumber, _chassisNumber, _engineNumber;
  File? _idImage, _insuranceDoc, _receiptImage;
  String? _paymentMethod;
  bool _isLoading = false;
  bool _formCompleted = false;
  int _currentStep = 1;
  final int _totalSteps = 3;
  final List<String> _paymentOptions = ['بطاقة بنكية', 'فوري', 'فودافون كاش'];

  final List<TextEditingController> _letterControllers =
      List.generate(3, (index) => TextEditingController());
  final List<TextEditingController> _numberControllers =
      List.generate(3, (index) => TextEditingController());
  final List<FocusNode> _letterFocusNodes =
      List.generate(3, (index) => FocusNode());
  final List<FocusNode> _numberFocusNodes =
      List.generate(3, (index) => FocusNode());

  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  Future<void> _pickImage(Function(File) onImagePicked) async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      onImagePicked(File(picked.path));
    }
  }

  @override
  void dispose() {
    for (var controller in [..._letterControllers, ..._numberControllers]) {
      controller.dispose();
    }
    for (var node in [..._letterFocusNodes, ..._numberFocusNodes]) {
      node.dispose();
    }
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  ThemeData _buildTheme() {
    return ThemeData(
      primaryColor: Color(0xFF1E88E5),
      scaffoldBackgroundColor: Colors.grey[100],
      fontFamily: 'Cairo',
      textTheme: TextTheme(
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.grey[800],
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: Colors.grey[700],
        ),
        labelLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF1E88E5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _buildTheme(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            'تجديد رخصة السيارة',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
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
            _buildProgressIndicator(),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
                child: Form(
                  key: _formKey,
                  child: FadeInUp(
                    duration: Duration(milliseconds: 600),
                    child: Column(
                      children: [
                        _buildEnhancedCard(
                          icon: Icons.directions_car,
                          title: 'بيانات المركبة',
                          children: [
                            SlideInLeft(
                              child: _buildAnimatedTextField(
                                  'رقم اللوحة',
                                  Icons.directions_car,
                                  (value) => _plateNumber = value),
                            ),
                            SlideInLeft(
                              child: _buildAnimatedTextField('رقم الهوية',
                                  Icons.person, (value) => _idNumber = value),
                            ),
                            SlideInLeft(
                              child: _buildAnimatedTextField(
                                  'رقم الشاسيه',
                                  Icons.confirmation_number,
                                  (value) => _chassisNumber = value),
                            ),
                            SlideInLeft(
                              child: _buildAnimatedTextField(
                                  'رقم المحرك',
                                  Icons.build,
                                  (value) => _engineNumber = value),
                            ),
                          ],
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        _buildEnhancedCard(
                          icon: Icons.upload_file,
                          title: 'الوثائق المطلوبة',
                          children: [
                            _buildUploadButton(
                                'صورة البطاقة',
                                _idImage,
                                () => _pickImage(
                                    (file) => setState(() => _idImage = file))),
                            SizedBox(height: 12),
                            _buildUploadButton(
                                'وثيقة التأمين',
                                _insuranceDoc,
                                () => _pickImage((file) =>
                                    setState(() => _insuranceDoc = file))),
                          ],
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        _buildEnhancedCard(
                          icon: Icons.payment,
                          title: 'طريقة الدفع',
                          children: [_buildPaymentMethodSelector()],
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        _buildSubmitButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_totalSteps, (index) {
              final step = index + 1;
              final isCompleted = _currentStep >= step;
              return Column(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: isCompleted
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                    child: Icon(
                      step == 1
                          ? Icons.directions_car
                          : step == 2
                              ? Icons.upload_file
                              : Icons.payment,
                      color: isCompleted ? Color(0xFF1E88E5) : Colors.grey[400],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'الخطوة $step',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              );
            }),
          ),
          SizedBox(height: 12),
          LinearPercentIndicator(
            width: MediaQuery.of(context).size.width - 32,
            lineHeight: 8.0,
            percent: (_formCompleted ? 1.0 : _currentStep / _totalSteps),
            backgroundColor: Colors.white.withOpacity(0.3),
            progressColor: Colors.white,
            barRadius: Radius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedTextField(
      String label, IconData icon, Function(String) onSaved) {
    if (label == 'رقم اللوحة') {
      return SlideInLeft(child: _buildPlateNumberInput());
    }
    return SlideInLeft(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Tooltip(
          message: 'أدخل $label بدقة',
          child: TextFormField(
            keyboardType: (label == 'رقم الهوية' || label == 'رقم المحرك')
                ? TextInputType.number
                : TextInputType.text,
            decoration: InputDecoration(
              labelText: label,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: Icon(icon, color: Color(0xFF1E88E5)),
              filled: true,
              fillColor: Colors.grey[50],
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'الرجاء إدخال $label';
              }
              if ((label == 'رقم الهوية' || label == 'رقم المحرك') &&
                  !RegExp(r'^[0-9]+$').hasMatch(value)) {
                return 'الرجاء إدخال أرقام فقط';
              }
              return null;
            },
            onSaved: (value) => onSaved(value!),
          ),
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
              Icon(isUploaded ? Icons.check_circle : Icons.cloud_upload,
                  color: isUploaded ? Colors.white : Colors.blue[600],
                  size: 24),
              SizedBox(width: 12),
              Text(
                isUploaded ? 'تم تحميل $title' : 'تحميل $title',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isUploaded ? Colors.white : Colors.blue[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSelector() {
    return Column(
      children: [
        Container(
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
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(color: Colors.grey[200]!, width: 1)),
                        color: isSelected ? Colors.blue[50] : Colors.white,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.blue[100]
                                  : Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(icon,
                                color: isSelected
                                    ? Colors.blue[700]
                                    : Colors.grey[600]),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              method,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? Colors.blue[700]
                                    : Colors.grey[800],
                              ),
                            ),
                          ),
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: isSelected
                                      ? Colors.blue[700]!
                                      : Colors.grey[400]!,
                                  width: 2),
                              color:
                                  isSelected ? Colors.blue[700] : Colors.white,
                            ),
                            child: isSelected
                                ? Icon(Icons.check,
                                    size: 16, color: Colors.white)
                                : null,
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Padding(
                        padding: EdgeInsets.only(top: 12, right: 16, left: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (method == 'بطاقة بنكية')
                              Text(
                                  '• سيتم تحويلك إلى صفحة إدخال معلومات البطاقة.')
                            else if (method == 'فوري')
                              Text('• استخدم الكود التالي للدفع: 123456')
                            else if (method == 'فودافون كاش')
                              Text(
                                  '• أرسل إلى رقم: 010XXXXXXX وأدخل الرقم المرجعي.')
                          ],
                        ),
                      ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        if (_paymentMethod != null) ...[
          SizedBox(height: 20),
          _buildPaymentDetails(_paymentMethod!),
        ],
      ],
    );
  }

  Widget _buildPaymentDetails(String method) {
    switch (method) {
      case 'بطاقة بنكية':
        return _buildCreditCardForm();
      case 'فوري':
        return _buildFawryForm();
      case 'فودافون كاش':
        return _buildVodafoneForm();
      default:
        return SizedBox();
    }
  }

  Widget _buildCreditCardForm() {
    return FadeInUp(
      duration: Duration(milliseconds: 500),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        margin: EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            colors: [Color(0xFF1E1E99), Color(0xFF3531A4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.blue[900]!.withOpacity(0.3),
              blurRadius: 20,
              offset: Offset(0, 10),
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.credit_card, color: Colors.white, size: 36),
                    SizedBox(width: 12),
                    Text(
                      'بطاقة الدفع',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Image.asset(
                  'assets/visa.png',
                  height: 40,
                  color: Colors.white.withOpacity(0.9),
                ),
              ],
            ),
            SizedBox(height: 32),
            _buildCardTextField(
              _cardNumberController,
              'رقم البطاقة',
              '٠٠٠٠ ٠٠٠٠ ٠٠٠٠ ٠٠٠٠',
              formatters: [
                FilteringTextInputFormatter.digitsOnly,
                CardNumberFormatter(),
              ],
              textStyle: TextStyle(
                  color: Colors.white, fontSize: 18, letterSpacing: 2),
            ),
            SizedBox(height: 24),
            _buildCardTextField(
              _cardHolderController,
              'اسم حامل البطاقة',
              'الاسم كما يظهر على البطاقة',
              textStyle: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildCardTextField(
                    _expiryController,
                    'تاريخ الانتهاء',
                    'MM/YY',
                    formatters: [ExpiryDateFormatter()],
                    textStyle: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildCardTextField(
                    _cvvController,
                    'CVV',
                    '***',
                    isObscured: true,
                    maxLength: 3,
                    textStyle: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFawryForm() {
    return FadeInUp(
      duration: Duration(milliseconds: 500),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.orange[300]!),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.1),
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
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.receipt_long,
                          color: Colors.orange[800], size: 30),
                      SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'كود الدفع',
                              style: TextStyle(
                                color: Colors.orange[800],
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '123456789',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange[900],
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(color: Colors.orange[200]),
                  Text(
                    'يمكنك الدفع من خلال أي منفذ فوري',
                    style: TextStyle(color: Colors.orange[800]),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            _buildReceiptUploader('ارفع صورة إيصال الدفع'),
          ],
        ),
      ),
    );
  }

  Widget _buildVodafoneForm() {
    return FadeInUp(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.red[300]!),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.phone_android, color: Colors.red[800]),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'ارسل المبلغ إلى: 0100000000',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[800],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            _buildReceiptUploader('ارفع صورة إيصال التحويل'),
          ],
        ),
      ),
    );
  }

  Widget _buildCardTextField(
    TextEditingController controller,
    String label,
    String hint, {
    bool isObscured = false,
    int? maxLength,
    List<TextInputFormatter>? formatters,
    TextStyle? textStyle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isObscured,
          maxLength: maxLength,
          inputFormatters: formatters,
          style: textStyle ?? TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white38),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white38, width: 1.5),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 2),
            ),
            counterText: "",
            contentPadding: EdgeInsets.symmetric(vertical: 8),
          ),
        ),
      ],
    );
  }

  Widget _buildReceiptUploader(String title) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () =>
              _pickImage((file) => setState(() => _receiptImage = file)),
          icon: Icon(Icons.upload_file),
          label: Text(title),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        if (_receiptImage != null) ...[
          SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              _receiptImage!,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildEnhancedCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 6,
      margin: EdgeInsets.symmetric(vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey[50]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Color(0xFF1E88E5).withOpacity(0.1),
                    child: Icon(icon, color: Color(0xFF1E88E5), size: 24),
                  ),
                  SizedBox(width: 12),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              SizedBox(height: 20),
              ...children,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    if (_formCompleted) {
      return FadeInUp(
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green[200]!),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: Colors.green[700], size: 24),
              SizedBox(width: 12),
              Text(
                'تم إدخال البيانات بنجاح. بانتظار المراجعة...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      child: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1E88E5)),
              ),
            )
          : ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 18),
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
                  Icon(Icons.check_circle_outline,
                      size: 24, color: Colors.white),
                  SizedBox(width: 12),
                  Text(
                    'إتمام عملية التجديد',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _submitForm() {
    final plateLetters = _letterControllers.map((c) => c.text).join();
    final plateNumbers = _numberControllers.map((c) => c.text).join();
    _plateNumber = '$plateNumbers $plateLetters';

    bool isPaymentValid = false;

    if (_paymentMethod == 'بطاقة بنكية') {
      isPaymentValid = _cardNumberController.text.isNotEmpty &&
          _cardHolderController.text.isNotEmpty &&
          _expiryController.text.isNotEmpty &&
          _cvvController.text.isNotEmpty;
    } else {
      isPaymentValid = _receiptImage != null;
    }

    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('يرجى ملء جميع الحقول المطلوبة')),
      );
      return;
    }

    if (_idImage == null || _insuranceDoc == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('يرجى رفع جميع الوثائق المطلوبة')),
      );
      return;
    }

    if (_paymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('يرجى اختيار طريقة دفع')),
      );
      return;
    }

    if (!isPaymentValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('يرجى إكمال بيانات الدفع')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تأكيد الإرسال'),
        content: Text('هل أنت متأكد من إرسال البيانات؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _isLoading = true);
              Future.delayed(Duration(seconds: 2), () {
                setState(() {
                  _isLoading = false;
                  _formCompleted = true;
                  _currentStep = _totalSteps;
                });
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('تم الإرسال'),
                    content: Text(
                        'تم إدخال البيانات بنجاح وهي الآن قيد المراجعة من الإدارة المختصة.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('حسناً'),
                      ),
                    ],
                  ),
                );
              });
            },
            child: Text('إرسال'),
          ),
        ],
      ),
    );
  }

  Widget _buildPlateNumberInput() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
        border: Border.all(color: Color(0xFF1E88E5).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'رقم اللوحة',
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: List.generate(3, (index) {
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: TextFormField(
                            controller: _numberControllers[index],
                            focusNode: _numberFocusNodes[index],
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              counterText: "",
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    BorderSide(color: Color(0xFF1E88E5)),
                              ),
                            ),
                            onChanged: (value) {
                              if (value.length == 1 && index < 2) {
                                _numberFocusNodes[index + 1].requestFocus();
                              }
                            },
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: List.generate(3, (index) {
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: TextFormField(
                            controller: _letterControllers[index],
                            focusNode: _letterFocusNodes[index],
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            textCapitalization: TextCapitalization.characters,
                            decoration: InputDecoration(
                              counterText: "",
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    BorderSide(color: Color(0xFF1E88E5)),
                              ),
                            ),
                            onChanged: (value) {
                              if (value.length == 1 && index < 2) {
                                _letterFocusNodes[index + 1].requestFocus();
                              }
                            },
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text;
    if (newValue.selection.baseOffset == 0) return newValue;

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(' ');
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}

class ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text;
    if (newValue.selection.baseOffset == 0) return newValue;

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 2 == 0 && nonZeroIndex != text.length) {
        buffer.write('/');
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}
