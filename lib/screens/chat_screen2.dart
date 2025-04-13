import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:animate_do/animate_do.dart';
import '../services/chatbot_service.dart';
import '../widgets/question_buttons.dart';

class ChatScreen2 extends StatefulWidget {
  @override
  _ChatScreen2State createState() => _ChatScreen2State();
}

class _ChatScreen2State extends State<ChatScreen2> with SingleTickerProviderStateMixin {
  final List<types.Message> _messages = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey(debugLabel: "MainScaffold");
  late AnimationController _animationController;
  bool _showTopics = true;

  final types.User _user = types.User(
    id: '1',
    firstName: 'أنت',
    imageUrl: 'assets/user_avatar.png',
  );
  
  final types.User _bot = types.User(
    id: '2',
    firstName: 'المساعد الذكي',
    imageUrl: 'assets/bot_avatar.png',
  );
  
  final ChatbotService _chatbotService = ChatbotService();
  List<String> _questions = [];
  bool _isTyping = false;

  final List<Map<String, dynamic>> _topics = [
    {
      'title': 'الضرائب السنوية',
      'icon': Icons.calendar_today,
      'color': Color(0xFF3B82F6),
      'questions': [
        'كيف أحسب الضريبة السنوية؟',
        'متى موعد تقديم الإقرار الضريبي؟',
        'ما هي المستندات المطلوبة؟'
      ]
    },
    {
      'title': 'المخالفات المرورية',
      'icon': Icons.car_crash,
      'color': Color(0xFF10B981),
      'questions': [
        'كيف أستعلم عن المخالفات؟',
        'كيف أسدد المخالفات؟',
        'ما هي أنواع المخالفات؟'
      ]
    },
    {
      'title': 'رخص القيادة',
      'icon': Icons.badge,
      'color': Color(0xFFF59E0B),
      'questions': [
        'كيف أجدد رخصة القيادة؟',
        'ما هي شروط استخراج الرخصة؟',
        'كم تكلفة تجديد الرخصة؟'
      ]
    },
    {
      'title': 'خدمات ذوي الاحتياجات',
      'icon': Icons.accessible,
      'color': Color(0xFFEC4899),
      'questions': [
        'ما هي الخدمات المتاحة لذوي الاحتياجات؟',
        'كيف أحصل على بطاقة ذوي الاحتياجات؟',
        'ما هي التسهيلات المقدمة؟'
      ]
    }
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    )..repeat(reverse: true);
    
    _chatbotService.loadDatabase().then((_) {
      setState(() {
        _questions = _chatbotService.getQuestions();
      });
      _showWelcomeMessage();
    });
  }

  void _showWelcomeMessage() {
    Future.delayed(Duration(milliseconds: 500), () {
      final welcomeMessage = types.TextMessage(
        author: _bot,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: DateTime.now().toString(),
        text: 'مرحباً بك! كيف يمكنني مساعدتك اليوم؟\nيمكنك اختيار موضوع أو طرح سؤال مباشرة.',
      );
      setState(() {
        _messages.insert(0, welcomeMessage);
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _sendMessage(String question) {
    setState(() {
      _showTopics = false;
    });

    final userMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: DateTime.now().toString(),
      text: question,
    );

    setState(() {
      _messages.insert(0, userMessage);
      _isTyping = true;
    });

    // Simulate bot typing
    Future.delayed(Duration(milliseconds: 1500), () {
      String botReply = _chatbotService.getResponse(question);
      final botMessage = types.TextMessage(
        author: _bot,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: DateTime.now().toString(),
        text: botReply,
      );

      setState(() {
        _isTyping = false;
        _messages.insert(0, botMessage);
      });
    });
  }

  Widget _buildTopicCard(Map<String, dynamic> topic) {
    return FadeInUp(
      duration: Duration(milliseconds: 500),
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: topic['color'].withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ExpansionTile(
          leading: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: topic['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              topic['icon'],
              color: topic['color'],
              size: 24,
            ),
          ),
          title: Text(
            topic['title'],
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: (topic['questions'] as List<String>).map<Widget>((question) {
                  return InkWell(
                    onTap: () => _sendMessage(question),
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 8),
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: topic['color'].withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: topic['color'].withOpacity(0.1),
                        ),
                      ),
                      child: Text(
                        question,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF64748B),
                          height: 1.5,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xFFF1F5F9),
      appBar: AppBar(
        elevation: 0,
        title: FadeIn(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 40,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white30, width: 2),
                ),
                child: Image.asset(
                  'assets/bot_avatar.png',
                  width: 24,
                  height: 24,
                ),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "المساعد الذكي",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  if (_isTyping)
                    Row(
                      children: [
                        Text(
                          "يكتب",
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.white70,
                              ),
                        ),
                        SizedBox(width: 4),
                        _buildTypingIndicator(),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          if (!_showTopics)
            IconButton(
              icon: Icon(Icons.topic_outlined, color: Colors.white),
              onPressed: () => setState(() => _showTopics = true),
            ),
        ],
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF2563EB),
                Color(0xFF3B82F6),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          if (_showTopics)
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeIn(
                        child: Text(
                          'اختر موضوعاً للمساعدة',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      FadeIn(
                        child: Text(
                          'يمكنك اختيار أحد المواضيع التالية أو طرح سؤال مباشر',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      ..._topics.map((topic) => _buildTopicCard(topic)).toList(),
                    ],
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF1F5F9),
                  image: DecorationImage(
                    image: AssetImage('assets/chat_pattern.png'),
                    opacity: 0.03,
                    repeat: ImageRepeat.repeat,
                  ),
                ),
                child: Chat(
                  messages: _messages,
                  onSendPressed: (message) {},
                  user: _user,
                  showUserNames: true,
                  showUserAvatars: true,
                  theme: DefaultChatTheme(
                    backgroundColor: Colors.transparent,
                    primaryColor: Color(0xFF2563EB),
                    secondaryColor: Colors.white,
                    messageBorderRadius: 20,
                    inputBackgroundColor: Colors.white,
                    inputTextColor: Color(0xFF1E293B),
                    inputBorderRadius: BorderRadius.circular(24),
                    inputPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    inputMargin: EdgeInsets.all(16),
                    inputTextStyle: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF1E293B),
                    ),
                    sentMessageBodyTextStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      height: 1.5,
                    ),
                    receivedMessageBodyTextStyle: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF1E293B),
                      height: 1.5,
                    ),
                    userNameTextStyle: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Color(0xFFE2E8F0),
                          ),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'اكتب سؤالك هنا...',
                            hintStyle: TextStyle(color: Color(0xFF94A3B8)),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                          onSubmitted: (value) {
                            if (value.isNotEmpty) {
                              _sendMessage(value);
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF2563EB),
                            Color(0xFF3B82F6),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {},
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return FadeTransition(
          opacity: Tween<double>(
            begin: 0.3,
            end: 1.0,
          ).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Interval(
                index * 0.4,
                0.5 + index * 0.4,
                curve: Curves.easeInOut,
              ),
            ),
          ),
          child: Container(
            width: 4,
            height: 4,
            margin: EdgeInsets.symmetric(horizontal: 1),
            decoration: BoxDecoration(
              color: Colors.white70,
              shape: BoxShape.circle,
            ),
          ),
        );
      }),
    );
  }
}
