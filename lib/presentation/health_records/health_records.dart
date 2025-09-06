import 'dart:convert';
import 'dart:io' if (dart.library.io) 'dart:io';

import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:universal_html/html.dart' as html;

import '../../core/app_export.dart';
import './widgets/document_upload_widget.dart';
import './widgets/document_viewer_widget.dart';
import './widgets/record_card_widget.dart';
import './widgets/search_filter_widget.dart';

class HealthRecords extends StatefulWidget {
  const HealthRecords({super.key});

  @override
  State<HealthRecords> createState() => _HealthRecordsState();
}

class _HealthRecordsState extends State<HealthRecords>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  String _searchQuery = '';
  String _selectedCategory = 'All';
  DateTimeRange? _dateRange;
  bool _isSelectionMode = false;
  Set<int> _selectedRecords = {};
  bool _isLoading = false;

  // Mock data for health records
  final List<Map<String, dynamic>> _allRecords = [
    {
      "id": 1,
      "title": "Complete Blood Count Report",
      "type": "Lab Report",
      "doctorName": "Dr. Rajesh Sharma",
      "date": DateTime.now().subtract(const Duration(days: 2)),
      "fileUrl":
          "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf",
      "fileSize": "2.3 MB",
      "thumbnail":
          "https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=300&h=300&fit=crop",
      "tags": ["Blood Test", "Routine", "Annual"],
      "isOfflineAvailable": true,
      "notes": "Normal values across all parameters"
    },
    {
      "id": 2,
      "title": "Ayurvedic Consultation Prescription",
      "type": "Prescription",
      "doctorName": "Dr. Priya Nair",
      "date": DateTime.now().subtract(const Duration(days: 5)),
      "fileUrl":
          "https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=800&h=1000&fit=crop",
      "fileSize": "1.8 MB",
      "thumbnail": null,
      "tags": ["Ayurvedic", "Digestive", "Herbal"],
      "isOfflineAvailable": true,
      "notes": "Take medicines after meals"
    },
    {
      "id": 3,
      "title": "Chest X-Ray Report",
      "type": "X-Ray",
      "doctorName": "Dr. Amit Kumar",
      "date": DateTime.now().subtract(const Duration(days: 10)),
      "fileUrl":
          "https://images.unsplash.com/photo-1559757175-0eb30cd8c063?w=800&h=1000&fit=crop",
      "fileSize": "4.1 MB",
      "thumbnail":
          "https://images.unsplash.com/photo-1559757175-0eb30cd8c063?w=300&h=300&fit=crop",
      "tags": ["X-Ray", "Chest", "Routine"],
      "isOfflineAvailable": false,
      "notes": "Clear lungs, no abnormalities detected"
    },
    {
      "id": 4,
      "title": "Diabetes Management Plan",
      "type": "Consultation",
      "doctorName": "Dr. Sunita Verma",
      "date": DateTime.now().subtract(const Duration(days: 15)),
      "fileUrl":
          "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf",
      "fileSize": "3.2 MB",
      "thumbnail": null,
      "tags": ["Diabetes", "Management", "Diet"],
      "isOfflineAvailable": true,
      "notes": "Follow strict diet and exercise routine"
    },
    {
      "id": 5,
      "title": "MRI Brain Scan",
      "type": "MRI",
      "doctorName": "Dr. Vikram Singh",
      "date": DateTime.now().subtract(const Duration(days: 20)),
      "fileUrl":
          "https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=800&h=1000&fit=crop",
      "fileSize": "15.7 MB",
      "thumbnail":
          "https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=300&h=300&fit=crop",
      "tags": ["MRI", "Brain", "Neurological"],
      "isOfflineAvailable": false,
      "notes": "No structural abnormalities found"
    },
    {
      "id": 6,
      "title": "Insurance Claim Form",
      "type": "Insurance",
      "doctorName": "Dr. Meera Patel",
      "date": DateTime.now().subtract(const Duration(days: 25)),
      "fileUrl":
          "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf",
      "fileSize": "1.2 MB",
      "thumbnail": null,
      "tags": ["Insurance", "Claim", "Reimbursement"],
      "isOfflineAvailable": true,
      "notes": "Submitted for \\₹15,000 treatment"
    },
  ];

  List<Map<String, dynamic>> _filteredRecords = [];

  @override
  void initState() {
    super.initState();
    _filteredRecords = List.from(_allRecords);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Implement infinite scroll if needed
  }

  Future<void> _refreshRecords() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Records refreshed successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _filterRecords() {
    setState(() {
      _filteredRecords = _allRecords.where((record) {
        // Search query filter
        if (_searchQuery.isNotEmpty) {
          final searchLower = _searchQuery.toLowerCase();
          final titleMatch =
              (record['title'] as String).toLowerCase().contains(searchLower);
          final doctorMatch = (record['doctorName'] as String)
              .toLowerCase()
              .contains(searchLower);
          final typeMatch =
              (record['type'] as String).toLowerCase().contains(searchLower);
          final tagsMatch = (record['tags'] as List).any(
              (tag) => (tag as String).toLowerCase().contains(searchLower));

          if (!titleMatch && !doctorMatch && !typeMatch && !tagsMatch) {
            return false;
          }
        }

        // Category filter
        if (_selectedCategory != 'All' && record['type'] != _selectedCategory) {
          return false;
        }

        // Date range filter
        if (_dateRange != null) {
          final recordDate = record['date'] as DateTime;
          if (recordDate.isBefore(_dateRange!.start) ||
              recordDate
                  .isAfter(_dateRange!.end.add(const Duration(days: 1)))) {
            return false;
          }
        }

        return true;
      }).toList();

      // Sort by date (newest first)
      _filteredRecords.sort(
          (a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));
    });
  }

  void _clearFilters() {
    setState(() {
      _searchQuery = '';
      _selectedCategory = 'All';
      _dateRange = null;
    });
    _filterRecords();
  }

  void _showUploadOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DocumentUploadWidget(
        onImageCaptured: _handleImageCaptured,
      ),
    );
  }

  void _handleImageCaptured(XFile image) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Document captured: ${image.name}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _pickDocument() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'doc', 'docx'],
        allowMultiple: false,
      );

      if (result != null) {
        final file = result.files.first;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Document selected: ${file.name}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to pick document'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      if (!_isSelectionMode) {
        _selectedRecords.clear();
      }
    });
  }

  void _toggleRecordSelection(int recordId) {
    setState(() {
      if (_selectedRecords.contains(recordId)) {
        _selectedRecords.remove(recordId);
      } else {
        _selectedRecords.add(recordId);
      }
    });
  }

  void _shareSelectedRecords() {
    if (_selectedRecords.isEmpty) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${_selectedRecords.length} records...'),
        duration: const Duration(seconds: 2),
      ),
    );

    _toggleSelectionMode();
  }

  void _downloadSelectedRecords() async {
    if (_selectedRecords.isEmpty) return;

    try {
      final selectedData = _filteredRecords
          .where((record) => _selectedRecords.contains(record['id']))
          .map((record) => {
                'title': record['title'],
                'type': record['type'],
                'doctor': record['doctorName'],
                'date': (record['date'] as DateTime).toIso8601String(),
              })
          .toList();

      final jsonContent = jsonEncode(selectedData);
      final filename =
          'health_records_${DateTime.now().millisecondsSinceEpoch}.json';

      if (kIsWeb) {
        final bytes = utf8.encode(jsonContent);
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download", filename)
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/$filename');
        await file.writeAsString(jsonContent);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Downloaded ${_selectedRecords.length} records'),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to download records'),
          duration: Duration(seconds: 2),
        ),
      );
    }

    _toggleSelectionMode();
  }

  void _viewDocument(Map<String, dynamic> record) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DocumentViewerWidget(
          document: record,
          onClose: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  void _shareRecord(Map<String, dynamic> record) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${record['title']}...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _downloadRecord(Map<String, dynamic> record) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading ${record['title']}...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _addNotes(Map<String, dynamic> record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Notes'),
        content: TextField(
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Enter your notes here...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notes added successfully'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _tagRecord(Map<String, dynamic> record) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tagging ${record['title']}...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _archiveRecord(Map<String, dynamic> record) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${record['title']} archived'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {},
        ),
      ),
    );
  }

  void _deleteRecord(Map<String, dynamic> record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Record'),
        content: Text('Are you sure you want to delete "${record['title']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _allRecords.removeWhere((r) => r['id'] == record['id']);
                _filterRecords();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${record['title']} deleted'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          _isSelectionMode
              ? '${_selectedRecords.length} selected'
              : 'Health Records',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        foregroundColor: AppTheme.lightTheme.colorScheme.onSurface,
        elevation: 1,
        leading: _isSelectionMode
            ? IconButton(
                onPressed: _toggleSelectionMode,
                icon: CustomIconWidget(
                  iconName: 'close',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
              )
            : IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: CustomIconWidget(
                  iconName: 'arrow_back',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
              ),
        actions: _isSelectionMode
            ? [
                IconButton(
                  onPressed: _shareSelectedRecords,
                  icon: CustomIconWidget(
                    iconName: 'share',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 24,
                  ),
                ),
                IconButton(
                  onPressed: _downloadSelectedRecords,
                  icon: CustomIconWidget(
                    iconName: 'download',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 24,
                  ),
                ),
              ]
            : [
                IconButton(
                  onPressed: _toggleSelectionMode,
                  icon: CustomIconWidget(
                    iconName: 'checklist',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 24,
                  ),
                ),
                PopupMenuButton<String>(
                  icon: CustomIconWidget(
                    iconName: 'more_vert',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 24,
                  ),
                  onSelected: (value) {
                    switch (value) {
                      case 'upload_file':
                        _pickDocument();
                        break;
                      case 'sync':
                        _refreshRecords();
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'upload_file',
                      child: ListTile(
                        leading: Icon(Icons.upload_file),
                        title: Text('Upload File'),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'sync',
                      child: ListTile(
                        leading: Icon(Icons.sync),
                        title: Text('Sync Records'),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ],
      ),
      body: Column(
        children: [
          // Search and filter section
          SearchFilterWidget(
            searchQuery: _searchQuery,
            selectedCategory: _selectedCategory,
            dateRange: _dateRange,
            onSearchChanged: (query) {
              setState(() {
                _searchQuery = query;
              });
              _filterRecords();
            },
            onCategoryChanged: (category) {
              setState(() {
                _selectedCategory = category;
              });
              _filterRecords();
            },
            onDateRangeChanged: (range) {
              setState(() {
                _dateRange = range;
              });
              _filterRecords();
            },
            onClearFilters: _clearFilters,
          ),

          // Records list
          Expanded(
            child: RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: _refreshRecords,
              color: AppTheme.lightTheme.colorScheme.primary,
              child: _filteredRecords.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.only(bottom: 10.h),
                      itemCount: _filteredRecords.length,
                      itemBuilder: (context, index) {
                        final record = _filteredRecords[index];
                        final recordId = record['id'] as int;

                        return RecordCardWidget(
                          record: record,
                          isSelected: _selectedRecords.contains(recordId),
                          onSelectionChanged: _isSelectionMode
                              ? () => _toggleRecordSelection(recordId)
                              : null,
                          onTap: () => _isSelectionMode
                              ? _toggleRecordSelection(recordId)
                              : _viewDocument(record),
                          onView: () => _viewDocument(record),
                          onShare: () => _shareRecord(record),
                          onDownload: () => _downloadRecord(record),
                          onAddNotes: () => _addNotes(record),
                          onTag: () => _tagRecord(record),
                          onArchive: () => _archiveRecord(record),
                          onDelete: () => _deleteRecord(record),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: _isSelectionMode
          ? null
          : FloatingActionButton.extended(
              onPressed: _showUploadOptions,
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
              icon: CustomIconWidget(
                iconName: 'camera_alt',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 24,
              ),
              label: const Text('Scan Document'),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'folder_open',
            color: AppTheme.lightTheme.colorScheme.outline,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            _searchQuery.isNotEmpty ||
                    _selectedCategory != 'All' ||
                    _dateRange != null
                ? 'No records found'
                : 'No health records yet',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.outline,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            _searchQuery.isNotEmpty ||
                    _selectedCategory != 'All' ||
                    _dateRange != null
                ? 'Try adjusting your search or filters'
                : 'Start by scanning or uploading your first document',
            textAlign: TextAlign.center,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.outline,
            ),
          ),
          if (_searchQuery.isEmpty &&
              _selectedCategory == 'All' &&
              _dateRange == null) ...[
            SizedBox(height: 3.h),
            ElevatedButton.icon(
              onPressed: _showUploadOptions,
              icon: CustomIconWidget(
                iconName: 'camera_alt',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 20,
              ),
              label: const Text('Scan Document'),
            ),
          ],
        ],
      ),
    );
  }
}
