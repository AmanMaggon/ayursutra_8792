import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DocumentUploadWidget extends StatefulWidget {
  final Function(XFile) onImageCaptured;

  const DocumentUploadWidget({
    super.key,
    required this.onImageCaptured,
  });

  @override
  State<DocumentUploadWidget> createState() => _DocumentUploadWidgetState();
}

class _DocumentUploadWidgetState extends State<DocumentUploadWidget> {
  List<CameraDescription> _cameras = [];
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isInitializing = false;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;
    return (await Permission.camera.request()).isGranted;
  }

  Future<void> _initializeCamera() async {
    if (_isInitializing) return;

    setState(() {
      _isInitializing = true;
    });

    try {
      if (!await _requestCameraPermission()) {
        setState(() {
          _isInitializing = false;
        });
        return;
      }

      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        setState(() {
          _isInitializing = false;
        });
        return;
      }

      final camera = kIsWeb
          ? _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.front,
              orElse: () => _cameras.first)
          : _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.back,
              orElse: () => _cameras.first);

      _cameraController = CameraController(
          camera, kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high);

      await _cameraController!.initialize();
      await _applySettings();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
          _isInitializing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
    }
  }

  Future<void> _applySettings() async {
    if (_cameraController == null) return;

    try {
      await _cameraController!.setFocusMode(FocusMode.auto);
    } catch (e) {
      // Ignore focus mode errors
    }

    if (!kIsWeb) {
      try {
        await _cameraController!.setFlashMode(FlashMode.auto);
      } catch (e) {
        // Ignore flash mode errors on unsupported devices
      }
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      final XFile photo = await _cameraController!.takePicture();
      widget.onImageCaptured(photo);
      Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to capture photo. Please try again.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        widget.onImageCaptured(image);
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to pick image from gallery.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Capture Document',
                  style: AppTheme.lightTheme.textTheme.titleLarge,
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          // Camera preview or loading
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                ),
              ),
              child: _buildCameraContent(),
            ),
          ),

          // Action buttons
          Container(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                // Gallery button
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickFromGallery,
                    icon: CustomIconWidget(
                      iconName: 'photo_library',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                    label: const Text('Gallery'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 3.h),
                    ),
                  ),
                ),

                SizedBox(width: 4.w),

                // Capture button
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: _isCameraInitialized ? _capturePhoto : null,
                    icon: CustomIconWidget(
                      iconName: 'camera_alt',
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      size: 20,
                    ),
                    label: const Text('Capture'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 3.h),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildCameraContent() {
    if (_isInitializing) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
            SizedBox(height: 2.h),
            Text(
              'Initializing camera...',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    if (!_isCameraInitialized || _cameraController == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'camera_alt',
              color: AppTheme.lightTheme.colorScheme.outline,
              size: 48,
            ),
            SizedBox(height: 2.h),
            Text(
              'Camera not available',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.outline,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Please use gallery to select image',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.outline,
              ),
            ),
          ],
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: CameraPreview(_cameraController!),
          ),

          // Overlay with document frame
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  // Corner indicators
                  Positioned(
                    top: 2.h,
                    left: 4.w,
                    child: Container(
                      width: 6.w,
                      height: 3.h,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            width: 3,
                          ),
                          left: BorderSide(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            width: 3,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 2.h,
                    right: 4.w,
                    child: Container(
                      width: 6.w,
                      height: 3.h,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            width: 3,
                          ),
                          right: BorderSide(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            width: 3,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 2.h,
                    left: 4.w,
                    child: Container(
                      width: 6.w,
                      height: 3.h,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            width: 3,
                          ),
                          left: BorderSide(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            width: 3,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 2.h,
                    right: 4.w,
                    child: Container(
                      width: 6.w,
                      height: 3.h,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            width: 3,
                          ),
                          right: BorderSide(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            width: 3,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Center instruction
                  Center(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface
                            .withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Align document within frame',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
