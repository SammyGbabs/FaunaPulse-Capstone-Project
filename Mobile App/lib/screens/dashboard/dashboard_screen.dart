import 'package:fauna_pulse/screens/upload_audio/upload_audio_screen.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fauna_pulse/screens/history/history_screen.dart';
import 'package:fauna_pulse/screens/chatbot/chatbot_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Sample data for testing
  final Map<String, dynamic> soilMetrics = {
    'activity': 'High Activity',
    'temperature': 18,
    'humidity': 97,
    'moisture': 7.1,
    'pH': 7.1,
    'nitrogen': 7.1,
    'phosphorus': 7.1,
    'potassium': 7.1,
    'conductivity': 2.0,
  };

  // Threshold values
  final Map<String, dynamic> thresholds = {
    'temperature': {'min': 15, 'max': 30},
    'humidity': {'min': 60, 'max': 95},
    'moisture': {'min': 5.0, 'max': 8.0},
    'pH': {'min': 6.0, 'max': 7.5},
  };

  // Flag for showing notifications
  bool showNotification = false;
  String notificationMessage = '';

  // Sample chart data
  final List<List<FlSpot>> chartData = [
    // Temperature data (purple)
    [
      const FlSpot(0, 20),
      const FlSpot(1, 22),
      const FlSpot(2, 24),
      const FlSpot(3, 25),
      const FlSpot(4, 26),
      const FlSpot(5, 28),
    ],
    // Moisture data (blue)
    [
      const FlSpot(0, 28),
      const FlSpot(1, 20),
      const FlSpot(2, 22),
      const FlSpot(3, 25),
      const FlSpot(4, 18),
      const FlSpot(5, 24),
    ],
    // Humidity data (orange)
    [
      const FlSpot(0, 15),
      const FlSpot(1, 22),
      const FlSpot(2, 28),
      const FlSpot(3, 20),
      const FlSpot(4, 18),
      const FlSpot(5, 20),
    ],
  ];

  // Selected time period for graph
  String selectedTimePeriod = '1D';

  @override
  void initState() {
    super.initState();
    // Check thresholds on init
    checkThresholds();
  }

  // Check if any metrics exceed thresholds
  void checkThresholds() {
    if (soilMetrics['temperature'] > thresholds['temperature']['max']) {
      setState(() {
        showNotification = true;
        notificationMessage = 'Temperature seems too high you should check it out. Try watering the soil.';
        soilMetrics['temperature'] = 36; // Simulate high temperature
      });
    }
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
          child: Stack(
            children: [
              // Main content
              Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(22.0), // Increased padding to 22px
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Notification Banner
                          if (showNotification)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'FaunaPulse',
                                    style: TextStyle(
                                      fontFamily: 'Lexend',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    notificationMessage,
                                    style: const TextStyle(
                                      fontFamily: 'Urbanist',
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          
                          // App Logo
                          Center(
                            child: Image.asset(
                              'lib/assets/images/fauna_pulse_logo.png',
                              width: 100,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Dashboard Title
                          const Text(
                            'Dashboard',
                            style: TextStyle(
                              fontFamily: 'Lexend',
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3A3A3A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          
                          // Subtitle
                          const Text(
                            'Overview of the various metrics',
                            style: TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 15,
                              color: Color(0xFF5A5A5A),
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // Soil Metrics Section
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF5E4935),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Soil Metrics',
                              style: TextStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Soil Dynamics Card - simple card
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Image.asset(
                                    'lib/assets/icons/soil_dynamics_icon.png',
                                    width: 24,
                                    height: 24,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'SOIL DYNAMICS',
                                      style: TextStyle(
                                        fontFamily: 'Lexend',
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF3A3A3A),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      soilMetrics['activity'],
                                      style: const TextStyle(
                                        fontFamily: 'Lexend',
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF4CAF50),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // Environmental Conditions Section
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE78B41),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Environmental conditions',
                              style: TextStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Temperature and Humidity row - simplified cards
                          Row(
                            children: [
                              // Temperature Card
                              Expanded(
                                child: _buildSimpleCard(
                                  iconAsset: 'lib/assets/icons/temperature_icon.png',
                                  label: 'TEMPERATURE',
                                  value: soilMetrics['temperature'].toString(),
                                  unit: '°C',
                                  valueColor: soilMetrics['temperature'] > thresholds['temperature']['max']
                                      ? Colors.red
                                      : const Color(0xFF4CAF50),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Humidity Card
                              Expanded(
                                child: _buildSimpleCard(
                                  iconAsset: 'lib/assets/icons/humidity_icon.png',
                                  label: 'HUMIDITY',
                                  value: soilMetrics['humidity'].toString(),
                                  unit: '%',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          
                          // Moisture card - simplified
                          _buildSimpleCard(
                            iconAsset: 'lib/assets/icons/moisture_icon.png',
                            label: 'MOISTURE',
                            value: soilMetrics['moisture'].toString(),
                            unit: 'g/m³',
                          ),
                          const SizedBox(height: 20),
                          
                          // Soil Nutrients Section
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF5E4935),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Soil Nutrients and Conductivity',
                              style: TextStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Nitrogen and Phosphorus row - with text icons
                          Row(
                            children: [
                              Expanded(
                                child: _buildSimpleCard(
                                  iconText: 'N',
                                  label: 'NITROGEN',
                                  value: soilMetrics['nitrogen'].toString(),
                                  unit: 'mg/kg',
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildSimpleCard(
                                  iconText: 'P',
                                  label: 'PHOSPHORUS',
                                  value: soilMetrics['phosphorus'].toString(),
                                  unit: 'mg/kg',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          
                          // Potassium and Conductivity row - with text icons
                          Row(
                            children: [
                              Expanded(
                                child: _buildSimpleCard(
                                  iconText: 'K',
                                  label: 'POTASSIUM',
                                  value: soilMetrics['potassium'].toString(),
                                  unit: 'mg/kg',
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildSimpleCard(
                                  iconText: '⚡',
                                  label: 'ELECTRICAL CONDUCTIVITY',
                                  value: soilMetrics['conductivity'].toString(),
                                  unit: 'dS/m',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          
                          // Graphs Section
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE78B41),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Graphs',
                              style: TextStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Graph card
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Graph title and time period selector
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Metrics Evolution',
                                      style: TextStyle(
                                        fontFamily: 'Urbanist',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF3A3A3A),
                                      ),
                                    ),
                                    // Time period selector
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        children: [
                                          for (String period in ['1D', '1M', '1Y', 'Max'])
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectedTimePeriod = period;
                                                });
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 5,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: selectedTimePeriod == period
                                                      ? Colors.white
                                                      : Colors.transparent,
                                                  borderRadius: BorderRadius.circular(20),
                                                  boxShadow: selectedTimePeriod == period
                                                      ? [
                                                          BoxShadow(
                                                            color: Colors.grey.withOpacity(0.2),
                                                            spreadRadius: 1,
                                                            blurRadius: 2,
                                                            offset: const Offset(0, 1),
                                                          ),
                                                        ]
                                                      : null,
                                                ),
                                                child: Text(
                                                  period,
                                                  style: TextStyle(
                                                    fontFamily: 'Urbanist',
                                                    fontSize: 12,
                                                    fontWeight: selectedTimePeriod == period
                                                        ? FontWeight.bold
                                                        : FontWeight.normal,
                                                    color: const Color(0xFF3A3A3A),
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                
                                // Line chart
                                SizedBox(
                                  height: 160,
                                  child: LineChart(
                                    LineChartData(
                                      lineTouchData: LineTouchData(
                                        touchTooltipData: LineTouchTooltipData(
                                          getTooltipColor: (touchedSpot) => Colors.white,
                                          getTooltipItems: (List<LineBarSpot> touchedSpots) {
                                            return touchedSpots.map((spot) {
                                              String tooltipText = '';
                                              Color textColor;
                                              switch (spot.barIndex) {
                                                case 0:
                                                  tooltipText = 'Temperature: ${spot.y.toStringAsFixed(1)}°C';
                                                  textColor = Colors.purple;
                                                  break;
                                                case 1:
                                                  tooltipText = 'Moisture: ${spot.y.toStringAsFixed(1)} g/m³';
                                                  textColor = Colors.blue;
                                                  break;
                                                case 2:
                                                  tooltipText = 'Humidity: ${spot.y.toStringAsFixed(1)}%';
                                                  textColor = Colors.orange;
                                                  break;
                                                default:
                                                  tooltipText = 'Value: ${spot.y.toStringAsFixed(1)}';
                                                  textColor = Colors.black;
                                              }
                                              return LineTooltipItem(
                                                tooltipText,
                                                TextStyle(
                                                  fontFamily: 'Urbanist',
                                                  color: textColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              );
                                            }).toList();
                                          },
                                        ),
                                        handleBuiltInTouches: true,
                                      ),
                                      gridData: FlGridData(
                                        drawHorizontalLine: true,
                                        horizontalInterval: 20,
                                        getDrawingHorizontalLine: (value) {
                                          return FlLine(
                                            color: Colors.grey.shade200,
                                            strokeWidth: 1,
                                            dashArray: [5, 5],
                                          );
                                        },
                                        drawVerticalLine: false,
                                      ),
                                      titlesData: FlTitlesData(
                                        bottomTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            getTitlesWidget: (value, meta) {
                                              return Padding(
                                                padding: const EdgeInsets.only(top: 8.0),
                                                child: Text(
                                                  '00',
                                                  style: TextStyle(
                                                    fontFamily: 'Urbanist',
                                                    color: Colors.grey.shade500,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              );
                                            },
                                            reservedSize: 22,
                                          ),
                                        ),
                                        leftTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            getTitlesWidget: (value, meta) {
                                              return Padding(
                                                padding: const EdgeInsets.only(right: 8.0),
                                                child: Text(
                                                  '00',
                                                  style: TextStyle(
                                                    fontFamily: 'Urbanist',
                                                    color: Colors.grey.shade500,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              );
                                            },
                                            reservedSize: 22,
                                          ),
                                        ),
                                        topTitles: const AxisTitles(
                                          sideTitles: SideTitles(showTitles: false),
                                        ),
                                        rightTitles: const AxisTitles(
                                          sideTitles: SideTitles(showTitles: false),
                                        ),
                                      ),
                                      borderData: FlBorderData(show: false),
                                      lineBarsData: [
                                        // Temperature line (purple)
                                        LineChartBarData(
                                          spots: chartData[0],
                                          isCurved: true,
                                          color: Colors.purple,
                                          barWidth: 2.5,
                                          isStrokeCapRound: true,
                                          dotData: const FlDotData(show: false),
                                          belowBarData: BarAreaData(
                                            show: true,
                                            color: Colors.purple.withOpacity(0.1),
                                          ),
                                        ),
                                        // Moisture line (blue)
                                        LineChartBarData(
                                          spots: chartData[1],
                                          isCurved: true,
                                          color: Colors.blue,
                                          barWidth: 2.5,
                                          isStrokeCapRound: true,
                                          dotData: const FlDotData(show: false),
                                          belowBarData: BarAreaData(
                                            show: true,
                                            color: Colors.blue.withOpacity(0.1),
                                          ),
                                        ),
                                        // Humidity line (orange)
                                        LineChartBarData(
                                          spots: chartData[2],
                                          isCurved: true,
                                          color: Colors.orange,
                                          barWidth: 2.5,
                                          isStrokeCapRound: true,
                                          dotData: const FlDotData(show: false),
                                          belowBarData: BarAreaData(
                                            show: true,
                                            color: Colors.orange.withOpacity(0.1),
                                          ),
                                        ),
                                      ],
                                      minX: 0,
                                      maxX: 5,
                                      minY: 0,
                                      maxY: 30,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                
                                // Legend
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildLegendItem('Temperature', Colors.purple),
                                    const SizedBox(width: 16),
                                    _buildLegendItem('Moisture', Colors.blue),
                                    const SizedBox(width: 16),
                                    _buildLegendItem('Humidity', Colors.orange),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          
                          // Extra space at bottom for floating button
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ),
                  
                  // Bottom Navigation
                  BottomNavigationBar(
                    currentIndex: 0, // Dashboard tab
                    backgroundColor: Colors.white,
                    selectedItemColor: const Color(0xFF5E4935),
                    unselectedItemColor: Colors.grey,
                    selectedFontSize: 12,
                    unselectedFontSize: 12,
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
                      if (index == 0) return; // Already on dashboard
                      
                      if (index == 1) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const AudioScreen()),
                        );
                      } else if (index == 2) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const HistoryScreen()),
                        );
                      }
                    },
                  ),
                ],
              ),
              
              // Chatbot button
              Positioned(
                right: 22, // Match horizontal padding
                bottom: 80, // Position above navigation bar
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => const ChatbotScreen(),
                      ),
                    );
                  },
                  backgroundColor: const Color(0xFFE78B41),
                  child: const Icon(
                    Icons.chat_bubble_outline,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Simple metric card with better readability
  Widget _buildSimpleCard({
    String? iconAsset,
    String? iconText,
    required String label,
    required String value,
    String unit = '',
    Color valueColor = const Color(0xFF4CAF50),
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Icon Container
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: iconAsset != null
                    ? Image.asset(
                        iconAsset,
                        width: 24,
                        height: 24,
                        color: Colors.black,
                      )
                    : Text(
                        iconText ?? '',
                        style: const TextStyle(
                          fontFamily: 'Lexend',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 10),
            
            // Label and Value
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontFamily: 'Lexend',
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3A3A3A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 1),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        value,
                        style: TextStyle(
                          fontFamily: 'Lexend',
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: valueColor,
                        ),
                      ),
                      if (unit.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 2.0),
                          child: Text(
                            unit,
                            style: TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build legend item widget
  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Urbanist',
            fontSize: 12,
            color: Color(0xFF3A3A3A),
          ),
        ),
      ],
    );
  }
}