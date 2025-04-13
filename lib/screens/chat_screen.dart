import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animate_do/animate_do.dart';
import 'package:intl/intl.dart';
import '../model/category_model.dart';
import '../services/weather_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, dynamic>> _messages = [];
  List<CategoryModel> _categories = [];
  final WeatherService _weatherService = WeatherService();
  final TextEditingController _messageController = TextEditingController();
  int _selectedCategoryIndex = -1;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadQuestionsAndAnswers().then((_) {
      if (_categories.isNotEmpty) {
        setState(() {
          _messages.add({
            'bot': 'مرحباً بك! كيف يمكنني مساعدتك اليوم؟',
            'time': DateFormat('HH:mm').format(DateTime.now())
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  String _translateWeatherDescription(String description) {
    Map<String, String> translations = {
      "clear sky": "سماء صافية",
      "few clouds": "غيوم قليلة",
      "scattered clouds": "غيوم متفرقة",
      "broken clouds": "غيوم متقطعة",
      "shower rain": "أمطار خفيفة",
      "rain": "مطر",
      "thunderstorm": "عاصفة رعدية",
      "snow": "ثلج",
      "mist": "ضباب",
    };
    return translations[description] ?? "غير معروف";
  }

  Future<void> _loadQuestionsAndAnswers() async {
    final prefs = await SharedPreferences.getInstance();
    String? cachedData = prefs.getString('questions_data');
    if (cachedData != null) {
      setState(() {
        _categories = (json.decode(cachedData)['categories'] as List)
            .map((item) => CategoryModel.fromJson(item))
            .toList();
      });
      return;
    }
    String data = await rootBundle.loadString('assets/questions_data.json');
    await prefs.setString('questions_data', data);
    setState(() {
      _categories = (json.decode(data)['categories'] as List)
          .map((item) => CategoryModel.fromJson(item))
          .toList();
    });
  }

  void _handleQuestionTap(String question, String answer) {
    setState(() {
      _messages.add({
        'user': question,
        'time': DateFormat('HH:mm').format(DateTime.now())
      });
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _messages.add({
          'bot': answer,
          'time': DateFormat('HH:mm').format(DateTime.now())
        });
        _messages.add({
          'bot': 'اختر مجموعة أو سؤالاً آخر:',
          'time': DateFormat('HH:mm').format(DateTime.now())
        });
      });
    });
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        _messages.add({
          'user': _messageController.text,
          'time': DateFormat('HH:mm').format(DateTime.now())
        });
      });
      String response = _getResponse(_messageController.text);
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          _messages.add({
            'bot': response,
            'time': DateFormat('HH:mm').format(DateTime.now())
          });
          _messages.add({
            'bot': 'اختر مجموعة أو سؤالاً آخر:',
            'time': DateFormat('HH:mm').format(DateTime.now())
          });
        });
      });
      _messageController.clear();
    }
  }

  String _getResponse(String question) {
    for (var category in _categories) {
      for (var q in category.questions) {
        if (q.question.toLowerCase().contains(question.toLowerCase())) {
          return q.answer;
        }
      }
    }
    return "عذرًا، لا أملك إجابة لهذا السؤال.";
  }

  void _getWeather() async {
    final weatherData = await _weatherService.fetchWeather();
    if (weatherData != null) {
      String weatherDescription = _translateWeatherDescription(
          weatherData['weather'][0]['description']);
      String temperature = "${weatherData['main']['temp']}°C";
      String location = weatherData['name'] ?? "موقعك";
      String recommendation = weatherData['main']['temp'] > 30
          ? "الطقس حار، يُنصح بشرب الماء بكثرة."
          : "الطقس بارد، يُنصح بارتداء ملابس دافئة.";
      setState(() {
        _messages.add({
          'bot': '$temperature $weatherDescription $location',
          'time': DateFormat('HH:mm').format(DateTime.now()),
          'isWeather': true,
        });
        _messages.add({
          'bot': recommendation,
          'time': DateFormat('HH:mm').format(DateTime.now()),
        });
        _messages.add({
          'bot': 'اختر مجموعة أو سؤالاً آخر:',
          'time': DateFormat('HH:mm').format(DateTime.now())
        });
      });
    } else {
      setState(() {
        _messages.add({
          'bot': 'فشل في جلب بيانات الطقس، تأكد من الاتصال بالإنترنت.',
          'time': DateFormat('HH:mm').format(DateTime.now()),
        });
        _messages.add({
          'bot': 'اختر مجموعة أو سؤالاً آخر:',
          'time': DateFormat('HH:mm').format(DateTime.now())
        });
      });
    }
  }

  void _selectCategory(int index) {
    setState(() {
      _selectedCategoryIndex = index;
      _messages.add({
        'bot': 'أسئلة ${(_categories[index].categoryName)}:',
        'time': DateFormat('HH:mm').format(DateTime.now()),
        'isCategory': true,
      });
    });
  }

  void _clearChat() {
    setState(() {
      _messages.clear();
      _selectedCategoryIndex = -1;
      _messages.add({
        'bot': 'مرحباً بك! كيف يمكنني مساعدتك اليوم؟',
        'time': DateFormat('HH:mm').format(DateTime.now())
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white24,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.chat_bubble_outline,
                  color: Colors.white, size: 24),
            ),
            SizedBox(width: 12),
            Text(
              "المساعد الذكي",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 20,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
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
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: _clearChat,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 60,
            padding: EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    child: ElevatedButton(
                      onPressed: () => _selectCategory(index),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedCategoryIndex == index
                            ? Color(0xFF1E88E5)
                            : Colors.grey[100],
                        foregroundColor: _selectedCategoryIndex == index
                            ? Colors.white
                            : Color(0xFF2D3436),
                        elevation: _selectedCategoryIndex == index ? 4 : 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      child: Text(
                        _categories[index].categoryName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFF5F6FA),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isUser = message.keys.first == 'user';
                  final isWeather = message['isWeather'] ?? false;
                  final isCategory = message['isCategory'] ?? false;

                  return FadeInUp(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: isUser
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          if (!isUser && !isWeather && !isCategory)
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(Icons.android,
                                  color: Color(0xFF1E88E5), size: 20),
                            ),
                          if (isWeather)
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(Icons.wb_sunny,
                                  color: Colors.orange[700], size: 20),
                            ),
                          SizedBox(width: 8),
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color:
                                    isUser ? Color(0xFF1E88E5) : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    message[isUser ? 'user' : 'bot'],
                                    style: TextStyle(
                                      color: isUser
                                          ? Colors.white
                                          : Color(0xFF2D3436),
                                      fontSize: 16,
                                      height: 1.4,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    message['time'],
                                    style: TextStyle(
                                      color: isUser
                                          ? Colors.white70
                                          : Colors.grey[600],
                                      fontSize: 12,
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
                },
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F6FA),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'اكتب رسالتك هنا...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF1E88E5),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
