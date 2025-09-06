import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class VoiceNotesWidget extends StatefulWidget {
  final Function(String)? onRecordingComplete;

  const VoiceNotesWidget({
    super.key,
    this.onRecordingComplete,
  });

  @override
  State<VoiceNotesWidget> createState() => _VoiceNotesWidgetState();
}

class _VoiceNotesWidgetState extends State<VoiceNotesWidget>
    with TickerProviderStateMixin {
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  bool _isPaused = false;
  String? _recordingPath;
  Duration _recordingDuration = Duration.zero;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<bool> _requestMicrophonePermission() async {
    if (kIsWeb) return true;

    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  Future<void> _startRecording() async {
    try {
      if (!await _requestMicrophonePermission()) {
        _showErrorSnackBar('Microphone permission is required for voice notes');
        return;
      }

      if (await _audioRecorder.hasPermission()) {
        String path;

        if (kIsWeb) {
          path = 'voice_note_${DateTime.now().millisecondsSinceEpoch}.wav';
          await _audioRecorder.start(
            const RecordConfig(encoder: AudioEncoder.wav),
            path: path,
          );
        } else {
          final directory = await getTemporaryDirectory();
          path =
              '${directory.path}/voice_note_${DateTime.now().millisecondsSinceEpoch}.m4a';
          await _audioRecorder.start(
            const RecordConfig(),
            path: path,
          );
        }

        setState(() {
          _isRecording = true;
          _isPaused = false;
          _recordingPath = path;
          _recordingDuration = Duration.zero;
        });

        _pulseController.repeat(reverse: true);
        _startTimer();
      }
    } catch (e) {
      _showErrorSnackBar('Failed to start recording. Please try again.');
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();

      setState(() {
        _isRecording = false;
        _isPaused = false;
        _recordingPath = path;
      });

      _pulseController.stop();
      _pulseController.reset();

      if (path != null && widget.onRecordingComplete != null) {
        widget.onRecordingComplete!(path);
      }

      _showSuccessSnackBar('Voice note recorded successfully');
    } catch (e) {
      _showErrorSnackBar('Failed to stop recording. Please try again.');
    }
  }

  Future<void> _pauseRecording() async {
    try {
      await _audioRecorder.pause();
      setState(() {
        _isPaused = true;
      });
      _pulseController.stop();
    } catch (e) {
      _showErrorSnackBar('Failed to pause recording');
    }
  }

  Future<void> _resumeRecording() async {
    try {
      await _audioRecorder.resume();
      setState(() {
        _isPaused = false;
      });
      _pulseController.repeat(reverse: true);
    } catch (e) {
      _showErrorSnackBar('Failed to resume recording');
    }
  }

  void _startTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (_isRecording && !_isPaused) {
        setState(() {
          _recordingDuration =
              Duration(seconds: _recordingDuration.inSeconds + 1);
        });
      }
      return _isRecording;
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'mic',
                color: colorScheme.primary,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Voice Notes',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              if (_isRecording)
                Text(
                  _formatDuration(_recordingDuration),
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          SizedBox(height: 3.h),
          if (!_isRecording) ...[
            Text(
              'Record consultation notes in your preferred language',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            SizedBox(height: 3.h),
            Center(
              child: GestureDetector(
                onTap: _startRecording,
                child: Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: CustomIconWidget(
                    iconName: 'mic',
                    color: colorScheme.onPrimary,
                    size: 8.w,
                  ),
                ),
              ),
            ),
          ] else ...[
            Text(
              _isPaused ? 'Recording paused...' : 'Recording in progress...',
              style: theme.textTheme.bodySmall?.copyWith(
                color: _isPaused ? colorScheme.secondary : colorScheme.error,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: _isPaused ? _resumeRecording : _pauseRecording,
                  child: AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _isPaused ? 1.0 : _pulseAnimation.value,
                        child: Container(
                          width: 15.w,
                          height: 15.w,
                          decoration: BoxDecoration(
                            color: _isPaused
                                ? colorScheme.secondary
                                : colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: CustomIconWidget(
                            iconName: _isPaused ? 'play_arrow' : 'pause',
                            color: colorScheme.onPrimary,
                            size: 6.w,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                GestureDetector(
                  onTap: _stopRecording,
                  child: Container(
                    width: 15.w,
                    height: 15.w,
                    decoration: BoxDecoration(
                      color: colorScheme.error,
                      shape: BoxShape.circle,
                    ),
                    child: CustomIconWidget(
                      iconName: 'stop',
                      color: colorScheme.onError,
                      size: 6.w,
                    ),
                  ),
                ),
              ],
            ),
          ],
          SizedBox(height: 2.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'language',
                color: colorScheme.tertiary,
                size: 4.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Supports Hindi, English & Regional Languages',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
