import 'dart:io';
import 'package:fauna_pulse/screens/analysis_results/analysis_results_screen.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fauna_pulse/screens/dashboard/dashboard_screen.dart';
import 'package:fauna_pulse/screens/history/history_screen.dart';

class AudioScreen extends StatefulWidget {
  const AudioScreen({super.key});

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  File? selectedAudioFile;
  String? fileName;
  bool isUploading = false;

  Future<void> pickAudioFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: false,
      );

      if (result != null) {
        setState(() {
          selectedAudioFile = File(result.files.single.path!);
          fileName = result.files.single.name;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $e')),
      );
    }
  }

  Future<void> sendForPrediction() async {
    if (selectedAudioFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an audio file first')),
      );
      return;
    }

    setState(() {
      isUploading = true;
    });

    // Simulate uploading and processing
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        isUploading = false;
      });

      // Navigate to results screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsScreen(
            audioFileName: fileName ?? 'audio.mp3',
            // Passing sample prediction data
            predictionResult: 'Low activity',
            confidenceScore: 89,
          ),
        ),
      );
    }
  }

  void removeSelectedFile() {
    setState(() {
      selectedAudioFile = null;
      fileName = null;
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
            colorFilter: ColorFilter.mode(Colors.white70, BlendMode.lighten),
          ),
        ),
        child: SafeArea(
          bottom: false, // Prevents double padding with navigation bar
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(22.0), // Increased padding to 22px
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // App Logo
                      Center(
                        child: Image.asset(
                          'lib/assets/images/fauna_pulse_logo.png',
                          width: 70, // Increased size
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Title
                      const Text(
                        'Upload Audio',
                        style: TextStyle(
                          fontFamily: 'Lexend',
                          fontSize: 26, // Increased font size
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3A3A3A),
                        ),
                      ),
                      
                      // Subtitle
                      const Text(
                        'Tap the button below to upload an audio to get a prediction',
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 15, // Increased font size
                          color: Color(0xFF5A5A5A),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Recommendations box
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18), // Increased padding
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Recommendations',
                              style: TextStyle(
                                fontFamily: 'Lexend',
                                fontSize: 18, // Increased font size
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3A3A3A),
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // Bullet points
                            ...[
                              'Supported formats: .mp3, .m4a, .wav, .ogg',
                              'Maximum file size: 4 MB',
                              'Maximum duration: 3 minutes',
                              'Please ensure your audio is clear and free from background noise',
                              'Avoid silent recordings or incomplete submissions',
                              'You can re-upload if needed',
                              'A stable internet connection is recommended for uploading',
                            ].map((text) => Padding(
                              padding: const EdgeInsets.only(bottom: 10.0), // Increased spacing
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '• ',
                                    style: TextStyle(
                                      fontFamily: 'Urbanist',
                                      fontSize: 15, // Increased font size
                                      color: Color(0xFF3A3A3A),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      text,
                                      style: const TextStyle(
                                        fontFamily: 'Urbanist',
                                        fontSize: 15, // Increased font size
                                        color: Color(0xFF3A3A3A),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )).toList(),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Upload area
                      GestureDetector(
                        onTap: pickAudioFile,
                        child: Container(
                          width: double.infinity,
                          height: 120, // Keeping good height for touch target
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.upload_file,
                                size: 40,
                                color: Colors.grey.shade700,
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Click to upload vibrations',
                                style: TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 16, // Increased font size
                                  color: Color(0xFF5A5A5A),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Selected file name
                      if (fileName != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.audio_file,
                                size: 20,
                                color: Colors.grey.shade700,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  fileName!,
                                  style: const TextStyle(
                                    fontFamily: 'Urbanist',
                                    fontSize: 15, // Increased font size
                                    color: Color(0xFF3A3A3A),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, size: 18),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: removeSelectedFile,
                              ),
                            ],
                          ),
                        ),
                      
                      const SizedBox(height: 30), // Extra space
                      
                      // Send for prediction button
                      if (fileName != null)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: isUploading ? null : sendForPrediction,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            icon: isUploading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.send),
                            label: Text(
                              isUploading ? 'Processing...' : 'Send for prediction',
                              style: const TextStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 16, // Increased font size
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              
              // Bottom Navigation Bar
              BottomNavigationBar(
                currentIndex: 1, // Audio tab
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
                  if (index == 1) return; // Already on audio
                  
                  if (index == 0) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const DashboardScreen()),
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
        ),
      ),
    );
  }
}