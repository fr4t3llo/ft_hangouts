// background_timer.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BackgroundTimeProvider extends ChangeNotifier {
  DateTime? _backgroundedTime;
  String _backgroundDuration = 'Not backgrounded yet';
  
  String get backgroundDuration => _backgroundDuration;

  void appWentToBackground() {
    _backgroundedTime = DateTime.now();
  }

  void appReturned() {
    if (_backgroundedTime != null) {
      final now = DateTime.now();
      final difference = now.difference(_backgroundedTime!);
      _backgroundDuration = _formatDuration(difference);
      notifyListeners();
    }
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    
    final parts = <String>[];
    
    if (hours > 0) {
      parts.add('$hours ${hours == 1 ? 'hour' : 'hours'}');
    }
    
    if (minutes > 0) {
      parts.add('$minutes ${minutes == 1 ? 'minute' : 'minutes'}');
    }
    
    if (seconds > 0 || parts.isEmpty) {
      parts.add('$seconds ${seconds == 1 ? 'second' : 'seconds'}');
    }
    
    return parts.join(', ');
  }
}

class BackgroundTimeTracker extends StatefulWidget {
  final Widget child;
  
  const BackgroundTimeTracker({super.key, required this.child});

  @override
  State<BackgroundTimeTracker> createState() => _BackgroundTimeTrackerState();
}

class _BackgroundTimeTrackerState extends State<BackgroundTimeTracker> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final provider = Provider.of<BackgroundTimeProvider>(context, listen: false);
    
    if (state == AppLifecycleState.paused) {
      // App going to background
      provider.appWentToBackground();
    } else if (state == AppLifecycleState.resumed) {
      // App returning to foreground
      provider.appReturned();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

// This widget is for displaying the background time
class BackgroundTimeDisplay extends StatelessWidget {
  const BackgroundTimeDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BackgroundTimeProvider>(
      builder: (context, provider, _) {
        return Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            'App was in background for: ${provider.backgroundDuration}',
            style: const TextStyle(fontSize: 14),
          ),
        );
      },
    );
  }
}