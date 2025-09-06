import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart'; // Add this import

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class HealthProgressWidget extends StatelessWidget {
  final List<Map<String, dynamic>> healthData;

  const HealthProgressWidget({
    super.key,
    required this.healthData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Health Progress',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/health-records');
                },
                child: Text(
                  'View Details',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(3.w),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildHealthMetrics(context),
              SizedBox(height: 3.h),
              _buildProgressChart(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHealthMetrics(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            context: context,
            title: 'Weight',
            value: '68.5',
            unit: 'kg',
            icon: 'monitor_weight',
            color: colorScheme.primary,
            trend: '+0.5',
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: _buildMetricCard(
            context: context,
            title: 'BP',
            value: '120/80',
            unit: 'mmHg',
            icon: 'favorite',
            color: Colors.red,
            trend: 'Normal',
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: _buildMetricCard(
            context: context,
            title: 'Sugar',
            value: '95',
            unit: 'mg/dL',
            icon: 'water_drop',
            color: Colors.orange,
            trend: 'Good',
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required BuildContext context,
    required String title,
    required String value,
    required String unit,
    required String icon,
    required Color color,
    required String trend,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: icon,
            color: color,
            size: 24,
          ),
          SizedBox(height: 1.h),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            unit,
            style: GoogleFonts.inter(
              fontSize: 9.sp,
              fontWeight: FontWeight.w400,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          SizedBox(height: 0.5.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.5.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(1.w),
            ),
            child: Text(
              trend,
              style: GoogleFonts.inter(
                fontSize: 8.sp,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressChart(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Weekly Progress',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        Container(
          width: double.infinity,
          height: 25.h,
          child: Semantics(
            label: "Weekly Health Progress Chart",
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: colorScheme.outline.withValues(alpha: 0.2),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        const style = TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                        );
                        Widget text;
                        switch (value.toInt()) {
                          case 0:
                            text = const Text('Mon', style: style);
                            break;
                          case 1:
                            text = const Text('Tue', style: style);
                            break;
                          case 2:
                            text = const Text('Wed', style: style);
                            break;
                          case 3:
                            text = const Text('Thu', style: style);
                            break;
                          case 4:
                            text = const Text('Fri', style: style);
                            break;
                          case 5:
                            text = const Text('Sat', style: style);
                            break;
                          case 6:
                            text = const Text('Sun', style: style);
                            break;
                          default:
                            text = const Text('', style: style);
                            break;
                        }
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: text,
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return Text(
                          value.toInt().toString(),
                          style: GoogleFonts.inter(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w400,
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        );
                      },
                      reservedSize: 32,
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: 6,
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 3),
                      FlSpot(1, 1),
                      FlSpot(2, 4),
                      FlSpot(3, 2),
                      FlSpot(4, 5),
                      FlSpot(5, 3),
                      FlSpot(6, 4),
                    ],
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.primary,
                        colorScheme.primary.withValues(alpha: 0.7),
                      ],
                    ),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: colorScheme.primary,
                          strokeWidth: 2,
                          strokeColor: colorScheme.surface,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.primary.withValues(alpha: 0.3),
                          colorScheme.primary.withValues(alpha: 0.1),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 3.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(1.w),
              ),
            ),
            SizedBox(width: 2.w),
            Text(
              'Overall Health Score',
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ],
    );
  }
}