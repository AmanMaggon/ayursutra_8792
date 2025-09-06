import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecordCardWidget extends StatelessWidget {
  final Map<String, dynamic> record;
  final VoidCallback onTap;
  final VoidCallback onView;
  final VoidCallback onShare;
  final VoidCallback onDownload;
  final VoidCallback onAddNotes;
  final VoidCallback onTag;
  final VoidCallback onArchive;
  final VoidCallback onDelete;
  final bool isSelected;
  final VoidCallback? onSelectionChanged;

  const RecordCardWidget({
    super.key,
    required this.record,
    required this.onTap,
    required this.onView,
    required this.onShare,
    required this.onDownload,
    required this.onAddNotes,
    required this.onTag,
    required this.onArchive,
    required this.onDelete,
    this.isSelected = false,
    this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Slidable(
        key: ValueKey(record['id']),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onAddNotes(),
              backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
              foregroundColor: AppTheme.lightTheme.colorScheme.onTertiary,
              icon: Icons.note_add,
              label: 'Notes',
            ),
            SlidableAction(
              onPressed: (_) => onTag(),
              backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
              foregroundColor: AppTheme.lightTheme.colorScheme.onSecondary,
              icon: Icons.local_offer,
              label: 'Tag',
            ),
            SlidableAction(
              onPressed: (_) => onArchive(),
              backgroundColor: AppTheme.lightTheme.colorScheme.outline,
              foregroundColor: AppTheme.lightTheme.colorScheme.surface,
              icon: Icons.archive,
              label: 'Archive',
            ),
            SlidableAction(
              onPressed: (_) => onDelete(),
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
              foregroundColor: AppTheme.lightTheme.colorScheme.onError,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: GestureDetector(
          onTap: onTap,
          onLongPress: onSelectionChanged,
          child: Card(
            elevation: isSelected ? 4 : 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: isSelected
                  ? BorderSide(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      width: 2,
                    )
                  : BorderSide.none,
            ),
            child: Container(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  // Selection checkbox (if in selection mode)
                  if (onSelectionChanged != null) ...[
                    Checkbox(
                      value: isSelected,
                      onChanged: (_) => onSelectionChanged!(),
                    ),
                    SizedBox(width: 2.w),
                  ],

                  // Document type icon and thumbnail
                  Container(
                    width: 16.w,
                    height: 16.w,
                    decoration: BoxDecoration(
                      color: _getDocumentTypeColor().withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _getDocumentTypeColor().withValues(alpha: 0.3),
                      ),
                    ),
                    child: record['thumbnail'] != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CustomImageWidget(
                              imageUrl: record['thumbnail'] as String,
                              width: 16.w,
                              height: 16.w,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Center(
                            child: CustomIconWidget(
                              iconName: _getDocumentTypeIcon(),
                              color: _getDocumentTypeColor(),
                              size: 24,
                            ),
                          ),
                  ),

                  SizedBox(width: 4.w),

                  // Document details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title and date row
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                record['title'] as String,
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              _formatDate(record['date'] as DateTime),
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.outline,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 0.5.h),

                        // Doctor name and type
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'person',
                              color: AppTheme.lightTheme.colorScheme.outline,
                              size: 16,
                            ),
                            SizedBox(width: 1.w),
                            Expanded(
                              child: Text(
                                record['doctorName'] as String,
                                style: AppTheme.lightTheme.textTheme.bodyMedium,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                color: _getDocumentTypeColor()
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                record['type'] as String,
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: _getDocumentTypeColor(),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 1.h),

                        // Tags (if any)
                        if (record['tags'] != null &&
                            (record['tags'] as List).isNotEmpty) ...[
                          Wrap(
                            spacing: 1.w,
                            children: (record['tags'] as List)
                                .take(3)
                                .map((tag) => Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 2.w, vertical: 0.5.h),
                                      decoration: BoxDecoration(
                                        color: AppTheme
                                            .lightTheme.colorScheme.secondary
                                            .withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        tag as String,
                                        style: AppTheme
                                            .lightTheme.textTheme.bodySmall
                                            ?.copyWith(
                                          color: AppTheme
                                              .lightTheme.colorScheme.secondary,
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                          SizedBox(height: 1.h),
                        ],

                        // Action buttons
                        Row(
                          children: [
                            _buildActionButton(
                              icon: 'visibility',
                              label: 'View',
                              onPressed: onView,
                            ),
                            SizedBox(width: 2.w),
                            _buildActionButton(
                              icon: 'share',
                              label: 'Share',
                              onPressed: onShare,
                            ),
                            SizedBox(width: 2.w),
                            _buildActionButton(
                              icon: 'download',
                              label: 'Download',
                              onPressed: onDownload,
                            ),
                            const Spacer(),
                            // Offline indicator
                            if (record['isOfflineAvailable'] == true)
                              Container(
                                padding: EdgeInsets.all(1.w),
                                decoration: BoxDecoration(
                                  color: AppTheme.lightTheme.colorScheme.primary
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: CustomIconWidget(
                                  iconName: 'offline_pin',
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  size: 16,
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
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 16,
            ),
            SizedBox(width: 1.w),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDocumentTypeIcon() {
    switch (record['type'] as String) {
      case 'Lab Report':
        return 'science';
      case 'Prescription':
        return 'medication';
      case 'X-Ray':
        return 'medical_services';
      case 'MRI':
        return 'medical_services';
      case 'CT Scan':
        return 'medical_services';
      case 'Blood Test':
        return 'bloodtype';
      case 'Consultation':
        return 'person';
      case 'Insurance':
        return 'shield';
      default:
        return 'description';
    }
  }

  Color _getDocumentTypeColor() {
    switch (record['type'] as String) {
      case 'Lab Report':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'Prescription':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'X-Ray':
      case 'MRI':
      case 'CT Scan':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'Blood Test':
        return AppTheme.lightTheme.colorScheme.error;
      case 'Consultation':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'Insurance':
        return AppTheme.lightTheme.colorScheme.outline;
      default:
        return AppTheme.lightTheme.colorScheme.outline;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
