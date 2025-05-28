import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildQuickStats(context),
              const SizedBox(height: 32),
              Text("Overview", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildBarChartCard(),
              const SizedBox(height: 24),
              _buildPieChartCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3F51B5), Color(0xFF7986CB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Welcome Admin",
              style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 8),
          Text("Manage your CRM efficiently", style: GoogleFonts.poppins(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _dashboardCard(context, title: "Agents", value: "08", icon: Mdi.account_tie_outline, color: Colors.indigo),
            const SizedBox(width: 12),
            _dashboardCard(context, title: "Customers", value: "10", icon: Mdi.account_group_outline, color: Colors.deepPurple),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _dashboardCard(context, title: "Chats", value: "22", icon: Mdi.chat_processing_outline, color: Colors.green),
            const SizedBox(width: 12),
            _dashboardCard(context, title: "Searches", value: "75", icon: Mdi.magnify, color: Colors.orange),
          ],
        ),
      ],
    );
  }

  Widget _dashboardCard(BuildContext context,
      {required String title, required String value, required String icon, required Color color}) {
    return Expanded(
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Iconify(icon, color: color, size: 28),
            const Spacer(),
            Text(value, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            Text(title, style: GoogleFonts.poppins(fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChartCard() {
    return Container(
      height: 220,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Performance Stats", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 80,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, _, rod, __) {
                      return BarTooltipItem(
                        '${rod.toY.toInt()}',
                        GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                ),
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(fontSize: 12, fontWeight: FontWeight.w600);
                        switch (value.toInt()) {
                          case 0:
                            return const Text("Agents", style: style);
                          case 1:
                            return const Text("Customers", style: style);
                          case 2:
                            return const Text("Chats", style: style);
                          case 3:
                            return const Text("Searches", style: style);
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                barGroups: [
                  _buildBarGroup(0, 8, Colors.indigo),
                  _buildBarGroup(1, 10, Colors.deepPurple),
                  _buildBarGroup(2, 22, Colors.green),
                  _buildBarGroup(3, 75, Colors.orange),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _buildBarGroup(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          width: 22,
          borderRadius: BorderRadius.circular(6),
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.8),
              color.withOpacity(0.5),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        )
      ],
    );
  }


  Widget _buildPieChartCard() {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Activity Split", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: PieChart(
                    PieChartData(
                      centerSpaceRadius: 30,
                      sectionsSpace: 2,
                      startDegreeOffset: 270,
                      sections: [
                        PieChartSectionData(value: 15, color: Colors.indigo, title: ''),
                        PieChartSectionData(value: 35, color: Colors.green, title: ''),
                        PieChartSectionData(value: 7, color: Colors.orange, title: ''),
                        PieChartSectionData(value: 20, color: Colors.purple, title: ''),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _legend(color: Colors.indigo, title: 'Agents'),
                    _legend(color: Colors.green, title: 'Customer'),
                    _legend(color: Colors.orange, title: 'Chats'),
                    _legend(color: Colors.purple, title: 'Search'),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _legend({required Color color, required String title}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(width: 14, height: 14, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Text(title, style: GoogleFonts.poppins(fontSize: 12)),
        ],
      ),
    );
  }

}
