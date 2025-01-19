import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/screens/chat.dart';
import 'package:chat_app/widgets/sos_button.dart';
import 'package:chat_app/widgets/fitness_stats_bar.dart';
import 'package:chat_app/screens/journal_screen.dart';
import 'package:chat_app/screens/resources_screen.dart';
import 'package:chat_app/screens/meditation_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isEmergencyMode = false;
  List<EmergencyStatus> _emergencyStatuses = [];

  Future<String?> _getUserImage() async {
    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    return userData.data()?['image_url'];
  }

  Future<String?> _getUsername() async {
    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    return userData.data()?['username'];
  }

  void _navigateToChat(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const ChatScreen(),
      ),
    );
  }

  void _toggleEmergencyMode(bool isActive) {
    setState(() {
      _isEmergencyMode = isActive;
      if (isActive) {
        _startEmergencySequence();
      } else {
        _emergencyStatuses.clear();
      }
    });
  }

  void _startEmergencySequence() {
    _emergencyStatuses = [];
    _addEmergencyStatus('Contacting Emergency Services...', 0);
    _addEmergencyStatus('Notifying Family Members...', 1000);
    _addEmergencyStatus('Sending Location Data...', 2000);
    _addEmergencyStatus('Alert Sent to Nearby Hospitals...', 3000);
    _addEmergencyStatus('Emergency Contacts Notified...', 4000);
  }

  void _addEmergencyStatus(String message, int delay) {
    Future.delayed(Duration(milliseconds: delay), () {
      if (mounted && _isEmergencyMode) {
        setState(() {
          _emergencyStatuses.add(EmergencyStatus(
            message: message,
            timestamp: DateTime.now(),
          ));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text(
          'RecoverWell+',
          style: TextStyle(
            fontFamily: 'Lobster',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: _isEmergencyMode ? Colors.red : null,
        actions: [
          FutureBuilder(
            future: _getUserImage(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey,
                );
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage:
                      snapshot.data != null ? AssetImage(snapshot.data!) : null,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
              );
            },
          ),
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(
              Icons.logout,
              color: _isEmergencyMode
                  ? Colors.white
                  : Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: FutureBuilder(
                future: _getUsername(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text('Loading...');
                  }
                  return Text(
                    _isEmergencyMode
                        ? 'Emergency Mode Activated'
                        : 'Welcome back, ${snapshot.data ?? 'User'}!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _isEmergencyMode ? Colors.red : null,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: SOSButton(
                onSOSPressed: _toggleEmergencyMode,
              ),
            ),
            Expanded(
              child: _isEmergencyMode
                  ? _buildEmergencyLayout()
                  : _buildNormalLayout(context),
            ),
            if (!_isEmergencyMode) const FitnessStatsBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyLayout() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'Emergency Protocol Activated',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _emergencyStatuses.length,
              itemBuilder: (context, index) {
                final status = _emergencyStatuses[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(Icons.notification_important,
                        color: Colors.red),
                    title: Text(status.message),
                    subtitle: Text(
                      '${status.timestamp.hour}:${status.timestamp.minute}:${status.timestamp.second}',
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNormalLayout(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 1,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        // Update the features array in _buildNormalLayout:
        final features = [
          {
            'title': 'Chat Support',
            'icon': Icons.chat_bubble_rounded,
            'description': 'Your personal AI therapist',
            'onTap': () => _navigateToChat(context),
            'color': Theme.of(context).colorScheme.primary,
          },
          {
            'title': 'Daily Journal',
            'icon': Icons.book_rounded,
            'description': 'Track your recovery journey',
            'onTap': () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => const JournalScreen(),
                  ),
                ),
            'color': Theme.of(context).colorScheme.secondary,
          },
          {
            'title': 'Resources',
            'icon': Icons.library_books_rounded,
            'description': 'Access recovery materials',
            'onTap': () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => ResourcesScreen(),
                  ),
                ),
            'color': Theme.of(context).colorScheme.tertiary,
          },
          {
            'title': 'Meditation',
            'icon': Icons.self_improvement_rounded,
            'description': 'Practice mindfulness',
            'onTap': () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => const MeditationScreen(),
                  ),
                ),
            'color': Theme.of(context).colorScheme.primaryContainer,
          },
        ];

        final feature = features[index];
        return _buildFeatureCard(
          context,
          feature['title'] as String,
          feature['icon'] as IconData,
          feature['description'] as String,
          feature['onTap'] as VoidCallback,
          feature['color'] as Color,
        );
      },
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    IconData icon,
    String description,
    VoidCallback onTap,
    Color color,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.7),
                color.withOpacity(0.9),
              ],
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 40,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmergencyStatus {
  final String message;
  final DateTime timestamp;

  EmergencyStatus({
    required this.message,
    required this.timestamp,
  });
}
