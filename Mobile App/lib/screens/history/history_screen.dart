import 'package:fauna_pulse/screens/upload_audio/upload_audio_screen.dart';
import 'package:flutter/material.dart';
import 'package:fauna_pulse/screens/dashboard/dashboard_screen.dart';


class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // Track which sections are expanded
  bool isNotificationsExpanded = false;
  bool isPreviousChatsExpanded = false;
  bool isPastReadingsExpanded = true;

  // Sample data
  final List<String> notifications = [
    'Temperature was abnormally high',
    'Moisture levels dropped below threshold',
    'Soil activity increased significantly',
  ];

  final List<String> previousChats = [
    'What is agriculture?',
    'How to improve soil health?',
    'What plants grow best in alkaline soil?',
  ];

  final List<Map<String, dynamic>> pastReadings = [
    {'temperature': 34, 'humidity': 98, 'timestamp': '2023-05-15 14:30'},
    {'temperature': 32, 'humidity': 95, 'timestamp': '2023-05-15 10:15'},
    {'temperature': 28, 'humidity': 92, 'timestamp': '2023-05-14 16:45'},
    {'temperature': 26, 'humidity': 90, 'timestamp': '2023-05-14 12:30'},
    {'temperature': 23, 'humidity': 99, 'timestamp': '2023-05-13 18:20'},
    {'temperature': 22, 'humidity': 98, 'timestamp': '2023-05-13 14:10'},
  ];

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
          bottom: false, // Prevents padding at bottom that interferes with navigation bar
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 12.0), // Increased padding
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // App Logo
                      Center(
                        child: Image.asset(
                          'lib/assets/images/fauna_pulse_logo.png',
                          width: 100, // Increased logo size
                        ),
                      ),
                      const SizedBox(height: 25), // Increased spacing
                      
                      // History Title
                      const Text(
                        'History',
                        style: TextStyle(
                          fontFamily: 'Lexend',
                          fontSize: 26, // Increased font size
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3A3A3A),
                        ),
                      ),
                      
                      // Subtitle
                      const Text(
                        'You can find all your past suggestions here.',
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 15, // Increased font size
                          color: Color(0xFF5A5A5A),
                        ),
                      ),
                      const SizedBox(height: 24), // Increased spacing
                      
                      // Notifications Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Section title
                          const Text(
                            'NOTIFICATIONS',
                            style: TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 14, // Increased font size
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3A3A3A),
                              letterSpacing: 1.0,
                            ),
                          ),
                          
                          // Toggle icon
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: Icon(
                              isNotificationsExpanded 
                                ? Icons.keyboard_arrow_up 
                                : Icons.keyboard_arrow_down,
                              size: 20, // Increased icon size
                              color: const Color(0xFF5E4935),
                            ),
                            onPressed: () {
                              setState(() {
                                isNotificationsExpanded = !isNotificationsExpanded;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8), // Increased spacing
                      
                      // First notification item (always visible)
                      _buildHistoryItem(
                        text: notifications[0],
                        isExpanded: false,
                        onToggle: () {
                          setState(() {
                            isNotificationsExpanded = !isNotificationsExpanded;
                          });
                        },
                      ),
                      
                      // Expanded notifications
                      if (isNotificationsExpanded)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF5E4935),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: notifications.map((notification) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(top: 6.0),
                                      child: Icon(
                                        Icons.circle,
                                        size: 6,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        notification,
                                        style: const TextStyle(
                                          fontFamily: 'Urbanist',
                                          fontSize: 14, // Increased font size
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0), // Increased spacing
                        child: Divider(height: 1, color: Colors.grey),
                      ),
                      
                      // Previous Chats Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Section title
                          const Text(
                            'PREVIOUS CHATS',
                            style: TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 14, // Increased font size
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3A3A3A),
                              letterSpacing: 1.0,
                            ),
                          ),
                          
                          // Toggle icon
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: Icon(
                              isPreviousChatsExpanded 
                                ? Icons.keyboard_arrow_up 
                                : Icons.keyboard_arrow_down,
                              size: 20, // Increased icon size
                              color: const Color(0xFF5E4935),
                            ),
                            onPressed: () {
                              setState(() {
                                isPreviousChatsExpanded = !isPreviousChatsExpanded;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8), // Increased spacing
                      
                      // First chat item (always visible)
                      _buildHistoryItem(
                        text: previousChats[0],
                        isExpanded: false,
                        onToggle: () {
                          setState(() {
                            isPreviousChatsExpanded = !isPreviousChatsExpanded;
                          });
                        },
                      ),
                      
                      // Expanded chats
                      if (isPreviousChatsExpanded)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF5E4935),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: previousChats.map((chat) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(top: 6.0),
                                      child: Icon(
                                        Icons.circle,
                                        size: 6,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        chat,
                                        style: const TextStyle(
                                          fontFamily: 'Urbanist',
                                          fontSize: 14, // Increased font size
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0), // Increased spacing
                        child: Divider(height: 1, color: Colors.grey),
                      ),
                      
                      // Past Readings Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Section title
                          const Text(
                            'PAST READINGS',
                            style: TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 14, // Increased font size
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3A3A3A),
                              letterSpacing: 1.0,
                            ),
                          ),
                          
                          // Toggle icon
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: Icon(
                              isPastReadingsExpanded 
                                ? Icons.keyboard_arrow_up 
                                : Icons.keyboard_arrow_down,
                              size: 20, // Increased icon size
                              color: const Color(0xFF5E4935),
                            ),
                            onPressed: () {
                              setState(() {
                                isPastReadingsExpanded = !isPastReadingsExpanded;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8), // Increased spacing
                      
                      // First reading (always visible)
                      _buildHistoryItem(
                        text: 'Temperature: ${pastReadings[0]['temperature']} degrees, Humidity: ${pastReadings[0]['humidity']}%',
                        isExpanded: false,
                        onToggle: () {
                          setState(() {
                            isPastReadingsExpanded = !isPastReadingsExpanded;
                          });
                        },
                      ),
                      
                      // Expanded readings
                      if (isPastReadingsExpanded)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF5E4935),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: pastReadings.map((reading) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(top: 6.0),
                                      child: Icon(
                                        Icons.circle,
                                        size: 6,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Temperature: ${reading['temperature']} degrees, Humidity: ${reading['humidity']}%',
                                        style: const TextStyle(
                                          fontFamily: 'Urbanist',
                                          fontSize: 14, // Increased font size
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      
                      const SizedBox(height: 24), // Extra space at the bottom
                    ],
                  ),
                ),
              ),
              
              // Bottom Navigation
              BottomNavigationBar(
                currentIndex: 2, // History tab
                backgroundColor: Colors.white,
                selectedItemColor: const Color(0xFF5E4935),
                unselectedItemColor: Colors.grey,
                selectedFontSize: 12, // Increased font size
                unselectedFontSize: 12, // Increased font size
                type: BottomNavigationBarType.fixed,
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
                  if (index == 2) return; // Already on history
                  
                  if (index == 0) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const DashboardScreen()),
                    );
                  } else if (index == 1) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const AudioScreen()),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build history item widget - improved with larger text
  Widget _buildHistoryItem({
    required String text,
    required bool isExpanded,
    required VoidCallback onToggle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6), // Increased margin
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Increased padding
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 14, // Increased font size
                      color: Color(0xFF3A3A3A),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 18, // Increased icon size
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}