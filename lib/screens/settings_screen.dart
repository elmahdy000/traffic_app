import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkMode = false;
  String _selectedLanguage = 'العربية';
  double _fontSize = 16.0;

  final List<Map<String, dynamic>> _settingsSections = [
    {
      'title': 'عام',
      'icon': Icons.settings,
      'color': Color(0xFF3B82F6),
      'settings': [
        {
          'title': 'اللغة',
          'subtitle': 'تغيير لغة التطبيق',
          'icon': Icons.language,
          'type': 'language',
        },
        {
          'title': 'الوضع الليلي',
          'subtitle': 'تفعيل المظهر الداكن',
          'icon': Icons.dark_mode,
          'type': 'switch',
        },
        {
          'title': 'حجم الخط',
          'subtitle': 'تعديل حجم النصوص',
          'icon': Icons.text_fields,
          'type': 'slider',
        },
      ],
    },
    {
      'title': 'الإشعارات',
      'icon': Icons.notifications,
      'color': Color(0xFFF59E0B),
      'settings': [
        {
          'title': 'تفعيل الإشعارات',
          'subtitle': 'استلام إشعارات التطبيق',
          'icon': Icons.notifications_active,
          'type': 'switch',
        },
      ],
    },
    {
      'title': 'الأمان',
      'icon': Icons.security,
      'color': Color(0xFF10B981),
      'settings': [
        {
          'title': 'تغيير كلمة المرور',
          'subtitle': 'تحديث كلمة المرور الخاصة بك',
          'icon': Icons.lock,
          'type': 'button',
        },
        {
          'title': 'المصادقة الثنائية',
          'subtitle': 'تفعيل المصادقة بخطوتين',
          'icon': Icons.security,
          'type': 'switch',
        },
      ],
    },
    {
      'title': 'عن التطبيق',
      'icon': Icons.info,
      'color': Color(0xFF8B5CF6),
      'settings': [
        {
          'title': 'الإصدار',
          'subtitle': '1.0.0',
          'icon': Icons.new_releases,
          'type': 'info',
        },
        {
          'title': 'سياسة الخصوصية',
          'subtitle': 'قراءة سياسة الخصوصية',
          'icon': Icons.privacy_tip,
          'type': 'button',
        },
      ],
    },
  ];

  Widget _buildSettingTile(Map<String, dynamic> setting) {
    switch (setting['type']) {
      case 'switch':
        return SwitchListTile(
          value: setting['title'] == 'تفعيل الإشعارات'
              ? _notificationsEnabled
              : setting['title'] == 'الوضع الليلي'
                  ? _darkMode
                  : false,
          onChanged: (bool value) {
            setState(() {
              if (setting['title'] == 'تفعيل الإشعارات') {
                _notificationsEnabled = value;
              } else if (setting['title'] == 'الوضع الليلي') {
                _darkMode = value;
              }
            });
          },
          title: Text(
            setting['title'],
            style: TextStyle(
              color: Color(0xFF1E293B),
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            setting['subtitle'],
            style: TextStyle(color: Color(0xFF64748B)),
          ),
          secondary: Icon(setting['icon'], color: Color(0xFF64748B)),
        );
      case 'slider':
        return ListTile(
          title: Text(
            setting['title'],
            style: TextStyle(
              color: Color(0xFF1E293B),
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                setting['subtitle'],
                style: TextStyle(color: Color(0xFF64748B)),
              ),
              Slider(
                value: _fontSize,
                min: 12.0,
                max: 24.0,
                divisions: 6,
                label: _fontSize.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _fontSize = value;
                  });
                },
              ),
            ],
          ),
          leading: Icon(setting['icon'], color: Color(0xFF64748B)),
        );
      case 'language':
        return ListTile(
          title: Text(
            setting['title'],
            style: TextStyle(
              color: Color(0xFF1E293B),
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            setting['subtitle'],
            style: TextStyle(color: Color(0xFF64748B)),
          ),
          leading: Icon(setting['icon'], color: Color(0xFF64748B)),
          trailing: DropdownButton<String>(
            value: _selectedLanguage,
            items: <String>['العربية', 'English']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedLanguage = newValue;
                });
              }
            },
          ),
        );
      default:
        return ListTile(
          title: Text(
            setting['title'],
            style: TextStyle(
              color: Color(0xFF1E293B),
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            setting['subtitle'],
            style: TextStyle(color: Color(0xFF64748B)),
          ),
          leading: Icon(setting['icon'], color: Color(0xFF64748B)),
          trailing: setting['type'] == 'button'
              ? Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF64748B))
              : null,
          onTap: setting['type'] == 'button' ? () {} : null,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          'الإعدادات',
          style: TextStyle(color: Color(0xFF1E293B)),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Color(0xFF64748B)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: _settingsSections.length,
        itemBuilder: (context, sectionIndex) {
          final section = _settingsSections[sectionIndex];
          return FadeInUp(
            delay: Duration(milliseconds: 100 * sectionIndex),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: section['color'].withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          section['icon'],
                          color: section['color'],
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        section['title'],
                        style: TextStyle(
                          color: Color(0xFF1E293B),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: List.generate(
                      section['settings'].length,
                      (index) => Column(
                        children: [
                          _buildSettingTile(section['settings'][index]),
                          if (index < section['settings'].length - 1)
                            Divider(height: 1),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
