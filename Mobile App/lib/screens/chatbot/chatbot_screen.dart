import 'package:fauna_pulse/screens/upload_audio/upload_audio_screen.dart';
import 'package:flutter/material.dart';
import 'package:fauna_pulse/screens/dashboard/dashboard_screen.dart';
import 'package:fauna_pulse/screens/history/history_screen.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSending = false;

  // List of chat messages
  final List<Map<String, dynamic>> _messages = [
    {
      'sender': 'AI',
      'message': 'Hello there\nHow can I help you?',
      'time': '07:07',
    },
    {
      'sender': 'User',
      'message': 'What is agriculture?',
      'time': '07:07',
    },
    {
      'sender': 'AI',
      'message': 'Agriculture is the science and practice of growing crops and raising animals for food, fiber, and other products used to sustain and enhance human life.',
      'time': '07:07',
    },
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _isSending = true;
      // Add user message
      _messages.add({
        'sender': 'User',
        'message': message,
        'time': _getCurrentTime(),
      });
      _messageController.clear();
    });

    // Scroll to bottom
    _scrollToBottom();

    // Simulate AI response delay
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isSending = false;
        // Add AI response
        _messages.add({
          'sender': 'AI',
          'message': _generateResponse(message),
          'time': _getCurrentTime(),
        });
      });

      // Scroll to bottom again after response
      _scrollToBottom();
    }
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  String _generateResponse(String userMessage) {
    // This is a simple response generator for demo purposes
    final lowerCaseMessage = userMessage.toLowerCase();
    
    if (lowerCaseMessage.contains('soil')) {
      return 'Soil is a crucial component for plant growth. It provides nutrients, water, and anchoring for plant roots. Healthy soil contains a balance of minerals, organic matter, air, and water.';
    } else if (lowerCaseMessage.contains('temperature')) {
      return 'Soil temperature affects plant growth, nutrient availability, and microbial activity. Optimal soil temperatures vary by crop, but generally range between 65-75°F (18-24°C) for most plants.';
    } else if (lowerCaseMessage.contains('humidity') || lowerCaseMessage.contains('moisture')) {
      return 'Soil moisture is essential for plant growth. Too little moisture causes drought stress, while too much can lead to root rot and oxygen deficiency. Maintaining proper soil moisture levels is key to plant health.';
    } else if (lowerCaseMessage.contains('hello') || lowerCaseMessage.contains('hi')) {
      return 'Hello! I\'m your FaunaPulse assistant. I can help you with questions about soil health, vibration analysis, and agricultural practices. What would you like to know?';
    } else {
      return 'That\'s an interesting question. While I\'m primarily focused on soil health and vibration analysis, I\'d be happy to help you with this topic. Could you provide more details so I can give you a more specific answer?';
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/images/soil_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.white30, BlendMode.lighten),
          ),
        ),
        child: SafeArea(
          bottom: false, // Prevents double padding with navigation bar
          child: Column(
            children: [
              // Header section
              Padding(
                padding: const EdgeInsets.only(
                  left: 22.0, // Increased horizontal padding as requested
                  right: 22.0,
                  top: 12.0,
                  bottom: 8.0
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // App Logo
                    Center(
                      child: Image.asset(
                        'lib/assets/images/fauna_pulse_logo.png',
                        width: 70,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Title
                    const Text(
                      'Chatbot',
                      style: TextStyle(
                        fontFamily: 'Lexend',
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3A3A3A),
                      ),
                    ),
                    
                    // Subtitle
                    const Text(
                      'Discuss with AI to know more',
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 15,
                        color: Color(0xFF5A5A5A),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Divider
              // const Divider(height: 1, color: Colors.grey),
              const SizedBox(height: 8),
              
              // Chat messages area
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 10.0), // Increased padding
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    final isUser = message['sender'] == 'User';
                    
                    return Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // AI avatar (only for AI messages)
                            if (!isUser)
                              Container(
                                width: 34, // Increased size
                                height: 34, // Increased size
                                margin: const EdgeInsets.only(right: 10, top: 4),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black,
                                ),
                                child: const Center(
                                  child: Text(
                                    'AI',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14, // Increased font size
                                    ),
                                  ),
                                ),
                              ),
                            
                            // Message bubble
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 0.7,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(14), // Increased padding
                                decoration: BoxDecoration(
                                  color: isUser ? const Color(0xFFE7E7E7) : Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 2,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      message['message'],
                                      style: TextStyle(
                                        fontFamily: 'Urbanist',
                                        fontSize: 15, // Increased font size
                                        color: isUser
                                            ? const Color(0xFF3A3A3A)
                                            : const Color(0xFF3A3A3A),
                                      ),
                                    ),
                                    const SizedBox(height: 6), // Increased spacing
                                    Text(
                                      message['time'],
                                      style: TextStyle(
                                        fontFamily: 'Urbanist',
                                        fontSize: 11, // Increased font size
                                        color: Colors.grey.shade600,
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
              
              // Message input area
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 12.0), // Increased padding
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Text input field
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        child: TextField(
                          controller: _messageController,
                          decoration: const InputDecoration(
                            hintText: 'Ask about anything...',
                            hintStyle: TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 15, // Increased font size
                              color: Colors.grey,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 12), // More padding
                          ),
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 10), // Increased spacing
                    
                    // Send button
                    Container(
                      width: 48, // Fixed size
                      height: 48, // Fixed size
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                      child: IconButton(
                        icon: _isSending
                            ? const SizedBox(
                                width: 22, // Increased size
                                height: 22, // Increased size
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 22, // Increased size
                              ),
                        onPressed: _isSending ? null : _sendMessage,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Bottom Navigation Bar
              BottomNavigationBar(
                currentIndex: 1, // Setting to 1 for now (Audio), adjust as needed
                backgroundColor: Colors.white,
                selectedItemColor: const Color(0xFF5E4935),
                unselectedItemColor: Colors.grey,
                selectedFontSize: 12, // Increased font size
                unselectedFontSize: 12, // Increased font size
                type: BottomNavigationBarType.fixed,
                elevation: 8,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.dashboard),
                    label: 'Dashboard',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.mic),
                    label: 'Audio',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.history),
                    label: 'History',
                  ),
                ],
                onTap: (index) {
                  switch (index) {
                    case 0:
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const DashboardScreen()),
                      );
                      break;
                    case 1:
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const AudioScreen()),
                      );
                      break;
                    case 2:
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const HistoryScreen()),
                      );
                      break;
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}