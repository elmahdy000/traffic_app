import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';

class AccidentReportsScreen extends StatefulWidget {
  @override
  _AccidentReportsScreenState createState() => _AccidentReportsScreenState();
}

class _AccidentReportsScreenState extends State<AccidentReportsScreen> {
  File? _accidentImage, _abandonedCarImage, _damageImage;
  final _accidentFormKey = GlobalKey<FormState>();
  final _abandonedFormKey = GlobalKey<FormState>();
  final _damageFormKey = GlobalKey<FormState>();
  String? _accidentLocation,
      _abandonedLocation,
      _abandonedDescription,
      _damageDescription;

  bool _isLoading = false;
  bool _isImageLoading = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Map<String, dynamic>> _accidentTypes = [
    {'title': 'تصادم مركبتين', 'icon': Icons.car_crash},
    {'title': 'تصادم متعدد', 'icon': Icons.car_rental},
    {'title': 'حادث مشاة', 'icon': Icons.directions_walk},
    {'title': 'انقلاب مركبة', 'icon': Icons.flip_camera_android},
  ];

  String? _selectedAccidentType;
  DateTime? _accidentDate;
  TimeOfDay? _accidentTime;
  List<String> _involvedParties = [];
  String? _insuranceNumber;
  File? _pdfReport;
  bool _isDownloading = false;

  Future<void> _pickImage(Function(File) onPicked) async {
    try {
      setState(() => _isImageLoading = true);
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picked != null) {
        setState(() {
          onPicked(File(picked.path));
          ScaffoldMessenger.of(context).showSnackBar(
            _buildSuccessSnackBar('تم تحميل الصورة بنجاح ✓'),
          );
        });
      }
    } finally {
      setState(() => _isImageLoading = false);
    }
  }

  Future<void> _downloadPdf() async {
    try {
      setState(() => _isDownloading = true);

      // محاكاة تحميل الملف
      await Future.delayed(Duration(seconds: 2));

      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/accident_report.pdf');

      // هنا يمكنك إضافة كود تحميل الملف الفعلي من الخادم

      setState(() {
        _pdfReport = file;
        ScaffoldMessenger.of(context).showSnackBar(
          _buildSuccessSnackBar('تم تحميل التقرير بنجاح'),
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        _buildErrorSnackBar('حدث خطأ أثناء تحميل التقرير'),
      );
    } finally {
      setState(() => _isDownloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text(
            'خدمات الحوادث والتقارير',
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
                colors: [Color(0xFFD32F2F), Color(0xFFE53935)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          elevation: 0,
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            indicatorWeight: 4,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white70,
            ),
            tabs: [
              _buildAnimatedTab('بلاغ حادث', Icons.car_crash),
              _buildAnimatedTab('متابعة البلاغ', Icons.history),
              _buildAnimatedTab('تقرير إلكتروني', Icons.description),
              _buildAnimatedTab('مركبة مهجورة', Icons.car_repair),
              _buildAnimatedTab('أضرار مرورية', Icons.broken_image),
              _buildAnimatedTab('تقييم المرور', Icons.assignment_turned_in),
            ],
          ),
        ),
        body: Stack(
          children: [
            TabBarView(
              children: [
                _buildAccidentReportTab(),
                _buildFollowUpTab(),
                _buildReportFormTab(),
                _buildAbandonedCarTab(),
                _buildTrafficDamageTab(),
                _buildEvaluationTab(),
              ],
            ),
            if (_isLoading)
              Container(
                color: Colors.black45,
                child: Center(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFFD32F2F),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'جاري المعالجة...',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
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

  Widget _buildAnimatedTab(String label, IconData icon) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildAccidentReportTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      physics: BouncingScrollPhysics(),
      child: FadeInUp(
        duration: Duration(milliseconds: 600),
        child: Form(
          key: _accidentFormKey,
          child: Column(
            children: [
              _buildCard(
                'نوع الحادث',
                Icons.warning_amber_rounded,
                [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _accidentTypes
                        .map(
                          (type) => ChoiceChip(
                            label: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(type['icon'],
                                    size: 18,
                                    color:
                                        _selectedAccidentType == type['title']
                                            ? Colors.white
                                            : Colors.grey[700]),
                                SizedBox(width: 8),
                                Text(type['title']),
                              ],
                            ),
                            selected: _selectedAccidentType == type['title'],
                            onSelected: (selected) {
                              setState(() => _selectedAccidentType =
                                  selected ? type['title'] : null);
                            },
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
              SizedBox(height: 16),
              _buildCard(
                'معلومات الحادث',
                Icons.info_outline,
                [
                  ListTile(
                    title: Text('تاريخ الحادث'),
                    subtitle: Text(_accidentDate?.toString().split(' ')[0] ??
                        'اختر التاريخ'),
                    trailing: Icon(Icons.calendar_today),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now().subtract(Duration(days: 7)),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) setState(() => _accidentDate = date);
                    },
                  ),
                  ListTile(
                    title: Text('وقت الحادث'),
                    subtitle:
                        Text(_accidentTime?.format(context) ?? 'اختر الوقت'),
                    trailing: Icon(Icons.access_time),
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) setState(() => _accidentTime = time);
                    },
                  ),
                  TextFormField(
                    decoration: _buildInputDecoration(
                        'رقم وثيقة التأمين', Icons.policy),
                    onChanged: (value) => _insuranceNumber = value,
                  ),
                ],
              ),
              // ...rest of existing accident report form...
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFollowUpTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: FadeInUp(
        child: Column(
          children: [
            _buildCard(
              'تتبع حالة البلاغ',
              Icons.timeline,
              [
                _buildTimelineItem(
                  'تم استلام البلاغ',
                  'منذ ساعتين',
                  Icons.receipt_long,
                  Colors.blue,
                  true,
                ),
                _buildTimelineItem(
                  'جاري المراجعة',
                  'قيد التنفيذ',
                  Icons.pending_actions,
                  Colors.orange,
                  true,
                ),
                _buildTimelineItem(
                  'تقرير المرور',
                  'في انتظار التقرير',
                  Icons.description,
                  Colors.grey,
                  false,
                ),
                _buildTimelineItem(
                  'إصدار التقرير النهائي',
                  'قريباً',
                  Icons.done_all,
                  Colors.grey,
                  false,
                ),
              ],
            ),
            // ...existing follow up content...
          ],
        ),
      ),
    );
  }

  Widget _buildReportFormTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: FadeInUp(
        duration: Duration(milliseconds: 600),
        child: Column(
          children: [
            _buildCard(
              'التقرير الإلكتروني',
              Icons.description,
              [
                ListTile(
                  title: Text('رقم البلاغ'),
                  subtitle: Text('#123456'),
                  leading: Icon(Icons.numbers, color: Color(0xFFD32F2F)),
                ),
                ListTile(
                  title: Text('تاريخ الحادث'),
                  subtitle: Text('2024/01/15'),
                  leading: Icon(Icons.calendar_today, color: Color(0xFFD32F2F)),
                ),
                Divider(),
                ListTile(
                  title: Text('حالة التقرير'),
                  subtitle: Text('جاهز للتحميل'),
                  leading: Icon(Icons.check_circle, color: Colors.green),
                ),
                SizedBox(height: 20),
                _buildDownloadButton(),
                if (_pdfReport != null) ...[
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green[300]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.picture_as_pdf, color: Colors.green[700]),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'تم تحميل التقرير',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[700],
                                ),
                              ),
                              Text(
                                'accident_report.pdf',
                                style: TextStyle(color: Colors.green[700]),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.remove_red_eye,
                              color: Colors.green[700]),
                          onPressed: () {
                            // هنا يمكنك إضافة كود لعرض ملف PDF
                            ScaffoldMessenger.of(context).showSnackBar(
                              _buildSuccessSnackBar('جاري فتح التقرير...'),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            SizedBox(height: 16),
            _buildCard(
              'إرسال إلى التأمين',
              Icons.local_police,
              [
                ListTile(
                  title: Text('شركة التأمين'),
                  subtitle: Text('اختر شركة التأمين'),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // اختيار شركة التأمين
                  },
                ),
                SizedBox(height: 16),
                _buildSubmitButton(
                  'إرسال إلى التأمين',
                  () {
                    if (_pdfReport == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        _buildErrorSnackBar('برجاء تحميل التقرير أولاً'),
                      );
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      _buildSuccessSnackBar('تم إرسال التقرير إلى التأمين'),
                    );
                  },
                  color: Colors.blue[700],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAbandonedCarTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      physics: BouncingScrollPhysics(),
      child: FadeInUp(
        duration: Duration(milliseconds: 600),
        child: Form(
          key: _abandonedFormKey,
          child: Card(
            elevation: 12,
            shadowColor: Colors.red.withOpacity(0.3),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Color(0xFFD32F2F).withOpacity(0.1),
                        child: Icon(Icons.car_repair,
                            size: 28, color: Color(0xFFD32F2F)),
                      ),
                      SizedBox(width: 16),
                      Text(
                        'بلاغ مركبة مهجورة',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey[900],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  TextFormField(
                    decoration: _buildInputDecoration(
                        'تحديد موقع المركبة', Icons.location_on),
                    validator: (value) => value == null || value.isEmpty
                        ? 'برجاء إدخال موقع المركبة'
                        : null,
                    onChanged: (value) => _abandonedLocation = value,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration:
                        _buildInputDecoration('وصف الحالة', Icons.description),
                    maxLines: 3,
                    validator: (value) => value == null || value.isEmpty
                        ? 'برجاء إدخال وصف الحالة'
                        : null,
                    onChanged: (value) => _abandonedDescription = value,
                  ),
                  SizedBox(height: 20),
                  _buildUploadButton(
                    'رفع صورة المركبة',
                    _abandonedCarImage,
                    () => _pickImage(
                        (f) => setState(() => _abandonedCarImage = f)),
                  ),
                  if (_abandonedCarImage != null) ...[
                    SizedBox(height: 20),
                    _buildImagePreview(_abandonedCarImage),
                  ],
                  SizedBox(height: 24),
                  _buildSubmitButton(
                    'إرسال البلاغ',
                    () {
                      if (_abandonedFormKey.currentState!.validate() &&
                          _abandonedCarImage != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          _buildSuccessSnackBar(
                              'تم إرسال بلاغ المركبة المهجورة بنجاح'),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          _buildErrorSnackBar('برجاء إكمال الحقول ورفع الصورة'),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrafficDamageTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      physics: BouncingScrollPhysics(),
      child: FadeInUp(
        duration: Duration(milliseconds: 600),
        child: Form(
          key: _damageFormKey,
          child: Card(
            elevation: 12,
            shadowColor: Colors.red.withOpacity(0.3),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Color(0xFFD32F2F).withOpacity(0.1),
                        child: Icon(Icons.broken_image,
                            size: 28, color: Color(0xFFD32F2F)),
                      ),
                      SizedBox(width: 16),
                      Text(
                        'بلاغ أضرار مرورية',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey[900],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  TextFormField(
                    decoration: _buildInputDecoration(
                        'وصف الضرر (مثلاً عمود إنارة مكسور)',
                        Icons.description),
                    maxLines: 3,
                    validator: (value) => value == null || value.isEmpty
                        ? 'برجاء إدخال وصف الضرر'
                        : null,
                    onChanged: (value) => _damageDescription = value,
                  ),
                  SizedBox(height: 20),
                  _buildUploadButton(
                    'رفع صورة الضرر',
                    _damageImage,
                    () => _pickImage((f) => setState(() => _damageImage = f)),
                  ),
                  if (_damageImage != null) ...[
                    SizedBox(height: 20),
                    _buildImagePreview(_damageImage),
                  ],
                  SizedBox(height: 24),
                  _buildSubmitButton(
                    'إرسال البلاغ',
                    () {
                      if (_damageFormKey.currentState!.validate() &&
                          _damageImage != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          _buildSuccessSnackBar(
                              'تم إرسال بلاغ الأضرار المرورية بنجاح'),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          _buildErrorSnackBar('برجاء إكمال الحقول ورفع الصورة'),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEvaluationTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: FadeInUp(
        duration: Duration(milliseconds: 600),
        child: Card(
          elevation: 12,
          shadowColor: Colors.red.withOpacity(0.3),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                ZoomIn(
                  duration: Duration(milliseconds: 400),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Color(0xFFD32F2F).withOpacity(0.1),
                    child: Icon(
                      Icons.assignment_turned_in,
                      size: 48,
                      color: Color(0xFFD32F2F),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'تقييم المرور',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[900],
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'تم تقييم الحادث من قبل المرور',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'القرار: التقرير مطابق – تم اعتماده',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.green[600],
                  ),
                ),
                SizedBox(height: 24),
                _buildSubmitButton(
                  'عرض التفاصيل',
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      _buildSuccessSnackBar('جاري عرض تفاصيل التقييم'),
                    );
                  },
                  color: Colors.grey[600],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.grey[600],
      ),
      prefixIcon: Icon(icon, color: Color(0xFFD32F2F), size: 24),
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
        borderSide: BorderSide(color: Color(0xFFD32F2F), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.red[400]!, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.red[400]!, width: 2),
      ),
    );
  }

  Widget _buildSubmitButton(String label, VoidCallback onPressed,
      {Color? color}) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: (color ?? Color(0xFFD32F2F)).withOpacity(0.3),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 18, horizontal: 24),
          backgroundColor: color ?? Color(0xFFD32F2F),
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

  Widget _buildUploadButton(String title, File? file, VoidCallback onPressed) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: file != null
                ? [Colors.green[400]!, Colors.green[600]!]
                : [Colors.grey[300]!, Colors.grey[400]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: (file != null ? Colors.green : Colors.grey[400])!
                  .withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _isImageLoading ? null : onPressed,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_isImageLoading)
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2,
                      ),
                    )
                  else
                    Icon(
                      file != null ? Icons.check_circle : Icons.cloud_upload,
                      color: Colors.white,
                    ),
                  SizedBox(width: 12),
                  Text(
                    _isImageLoading
                        ? 'جاري التحميل...'
                        : file != null
                            ? 'تم التحميل بنجاح'
                            : title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDownloadButton() {
    return Container(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: _isDownloading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Icon(Icons.download),
        label: Text(
          _isDownloading ? 'جاري التحميل...' : 'تحميل التقرير PDF',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Color(0xFFD32F2F),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: _isDownloading ? null : _downloadPdf,
      ),
    );
  }

  SnackBar _buildSuccessSnackBar(String message) {
    return SnackBar(
      content: Text(
        message,
        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
      ),
      backgroundColor: Colors.green[600],
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    );
  }

  SnackBar _buildErrorSnackBar(String message) {
    return SnackBar(
      content: Text(
        message,
        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
      ),
      backgroundColor: Colors.red[600],
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    );
  }

  Widget _buildImagePreview(File? imageFile) {
    if (imageFile == null) return SizedBox();

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: kIsWeb
          ? Image.network(
              imageFile.path,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            )
          : Image.file(
              imageFile,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
    );
  }

  Widget _buildCard(String title, IconData icon, List<Widget> children) {
    return Card(
      elevation: 12,
      shadowColor: Colors.red.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Color(0xFFD32F2F).withOpacity(0.1),
                  child: Icon(icon, size: 28, color: Color(0xFFD32F2F)),
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
    );
  }

  Widget _buildTimelineItem(String title, String subtitle, IconData icon,
      Color color, bool isCompleted) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isCompleted ? color.withOpacity(0.1) : Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isCompleted ? color : Colors.grey,
              size: 20,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isCompleted ? Colors.black87 : Colors.grey,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isCompleted ? Colors.black54 : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          if (isCompleted) Icon(Icons.check_circle, color: color, size: 20),
        ],
      ),
    );
  }
}
