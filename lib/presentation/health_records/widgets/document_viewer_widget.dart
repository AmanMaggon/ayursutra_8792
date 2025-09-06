import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../core/app_export.dart';

class DocumentViewerWidget extends StatefulWidget {
  final Map<String, dynamic> document;
  final VoidCallback onClose;

  const DocumentViewerWidget({
    super.key,
    required this.document,
    required this.onClose,
  });

  @override
  State<DocumentViewerWidget> createState() => _DocumentViewerWidgetState();
}

class _DocumentViewerWidgetState extends State<DocumentViewerWidget> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  final TransformationController _transformationController =
      TransformationController();
  bool _isZoomed = false;
  double _currentZoom = 1.0;

  @override
  void dispose() {
    _pdfViewerController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    setState(() {
      if (_isZoomed) {
        _transformationController.value = Matrix4.identity();
        _currentZoom = 1.0;
        _isZoomed = false;
      } else {
        _transformationController.value = Matrix4.identity()..scale(2.0);
        _currentZoom = 2.0;
        _isZoomed = true;
      }
    });
  }

  void _zoomIn() {
    setState(() {
      _currentZoom = (_currentZoom * 1.2).clamp(0.5, 5.0);
      _transformationController.value = Matrix4.identity()..scale(_currentZoom);
      _isZoomed = _currentZoom > 1.0;
    });
  }

  void _zoomOut() {
    setState(() {
      _currentZoom = (_currentZoom / 1.2).clamp(0.5, 5.0);
      _transformationController.value = Matrix4.identity()..scale(_currentZoom);
      _isZoomed = _currentZoom > 1.0;
    });
  }

  void _resetZoom() {
    setState(() {
      _currentZoom = 1.0;
      _transformationController.value = Matrix4.identity();
      _isZoomed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: widget.onClose,
          icon: CustomIconWidget(
            iconName: 'close',
            color: Colors.white,
            size: 24,
          ),
        ),
        title: Text(
          widget.document['title'] as String,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _zoomOut,
            icon: CustomIconWidget(
              iconName: 'zoom_out',
              color: Colors.white,
              size: 24,
            ),
          ),
          IconButton(
            onPressed: _resetZoom,
            icon: CustomIconWidget(
              iconName: 'center_focus_strong',
              color: Colors.white,
              size: 24,
            ),
          ),
          IconButton(
            onPressed: _zoomIn,
            icon: CustomIconWidget(
              iconName: 'zoom_in',
              color: Colors.white,
              size: 24,
            ),
          ),
          PopupMenuButton<String>(
            icon: CustomIconWidget(
              iconName: 'more_vert',
              color: Colors.white,
              size: 24,
            ),
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'share',
                child: ListTile(
                  leading: Icon(Icons.share, color: Colors.black),
                  title: Text('Share'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'download',
                child: ListTile(
                  leading: Icon(Icons.download, color: Colors.black),
                  title: Text('Download'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'print',
                child: ListTile(
                  leading: Icon(Icons.print, color: Colors.black),
                  title: Text('Print'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'info',
                child: ListTile(
                  leading: Icon(Icons.info, color: Colors.black),
                  title: Text('Document Info'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          // Document viewer
          Center(
            child: _buildDocumentViewer(),
          ),

          // Zoom level indicator
          if (_isZoomed)
            Positioned(
              top: 2.h,
              right: 4.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${(_currentZoom * 100).round()}%',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

          // Zoom controls (floating)
          Positioned(
            bottom: 10.h,
            right: 4.w,
            child: Column(
              children: [
                FloatingActionButton(
                  mini: true,
                  backgroundColor: Colors.black.withValues(alpha: 0.7),
                  foregroundColor: Colors.white,
                  onPressed: _zoomIn,
                  heroTag: "zoom_in",
                  child: CustomIconWidget(
                    iconName: 'add',
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                SizedBox(height: 1.h),
                FloatingActionButton(
                  mini: true,
                  backgroundColor: Colors.black.withValues(alpha: 0.7),
                  foregroundColor: Colors.white,
                  onPressed: _zoomOut,
                  heroTag: "zoom_out",
                  child: CustomIconWidget(
                    iconName: 'remove',
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentViewer() {
    final String fileUrl = widget.document['fileUrl'] as String;
    final String fileType = _getFileType(fileUrl);

    switch (fileType) {
      case 'pdf':
        return _buildPdfViewer(fileUrl);
      case 'image':
        return _buildImageViewer(fileUrl);
      default:
        return _buildUnsupportedFileViewer();
    }
  }

  Widget _buildPdfViewer(String fileUrl) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: SfPdfViewer.network(
        fileUrl,
        controller: _pdfViewerController,
        onDocumentLoadFailed: (details) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to load PDF: ${details.error}'),
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageViewer(String fileUrl) {
    return GestureDetector(
      onDoubleTap: _handleDoubleTap,
      child: InteractiveViewer(
        transformationController: _transformationController,
        minScale: 0.5,
        maxScale: 5.0,
        child: Center(
          child: CustomImageWidget(
            imageUrl: fileUrl,
            width: 100.w,
            height: 100.h,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildUnsupportedFileViewer() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'description',
            color: Colors.white.withValues(alpha: 0.7),
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'Preview not available',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'This file type cannot be previewed.\nTap download to view externally.',
            textAlign: TextAlign.center,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 3.h),
          ElevatedButton.icon(
            onPressed: () => _handleMenuAction('download'),
            icon: CustomIconWidget(
              iconName: 'download',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 20,
            ),
            label: const Text('Download File'),
          ),
        ],
      ),
    );
  }

  String _getFileType(String fileUrl) {
    final String extension = fileUrl.split('.').last.toLowerCase();

    if (['pdf'].contains(extension)) {
      return 'pdf';
    } else if (['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp']
        .contains(extension)) {
      return 'image';
    } else {
      return 'unknown';
    }
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'share':
        _shareDocument();
        break;
      case 'download':
        _downloadDocument();
        break;
      case 'print':
        _printDocument();
        break;
      case 'info':
        _showDocumentInfo();
        break;
    }
  }

  void _shareDocument() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sharing document...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _downloadDocument() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Downloading document...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _printDocument() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Print functionality coming soon'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showDocumentInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Document Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Title', widget.document['title'] as String),
            _buildInfoRow('Type', widget.document['type'] as String),
            _buildInfoRow('Doctor', widget.document['doctorName'] as String),
            _buildInfoRow(
                'Date', _formatDate(widget.document['date'] as DateTime)),
            _buildInfoRow(
                'Size', widget.document['fileSize'] as String? ?? 'Unknown'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 20.w,
            child: Text(
              '$label:',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
