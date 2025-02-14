import 'package:flutter/material.dart';
import '../../config/constants.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Last 7 days', 'Last 30 days', 'Last 90 days'];

  final List<Map<String, dynamic>> _historyData = [
    {
      'date': '17 Mar 2025',
      'time': '08:30 AM',
      'oxygen': '98',
      'pulse': '72',
      'status': 'Normal'
    },
    {
      'date': '16 Mar 2025',
      'time': '09:15 AM',
      'oxygen': '97',
      'pulse': '70',
      'status': 'Normal'
    },
    {
      'date': '15 Mar 2025',
      'time': '07:45 AM',
      'oxygen': '99',
      'pulse': '75',
      'status': 'Normal'
    },
    {
      'date': '14 Mar 2025',
      'time': '08:00 AM',
      'oxygen': '95',
      'pulse': '78',
      'status': 'Warning'
    },
    {
      'date': '13 Mar 2025',
      'time': '07:30 AM',
      'oxygen': '96',
      'pulse': '76',
      'status': 'Normal'
    },
    {
      'date': '12 Mar 2025',
      'time': '08:45 AM',
      'oxygen': '97',
      'pulse': '77',
      'status': 'Normal'
    },
    {
      'date': '11 Mar 2025',
      'time': '09:00 AM',
      'oxygen': '94',
      'pulse': '80',
      'status': 'Warning'
    },
    {
      'date': '10 Mar 2025',
      'time': '08:15 AM',
      'oxygen': '98',
      'pulse': '71',
      'status': 'Normal'
    },
    {
      'date': '09 Mar 2025',
      'time': '07:45 AM',
      'oxygen': '99',
      'pulse': '69',
      'status': 'Normal'
    },
    {
      'date': '08 Mar 2025',
      'time': '08:30 AM',
      'oxygen': '92',
      'pulse': '85',
      'status': 'Low'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildFilterSection(),
          _buildStatisticsSection(),
          _buildHistoryList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _filters.map((filter) {
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        filter,
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textSecondary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.lightGreen,
            AppColors.lime,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statistics',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem('Average SpO2', '97%'),
              _buildStatItem('Average Pulse', '74 bpm'),
              _buildStatItem('Readings', '${_historyData.length}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryList() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'History',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _historyData.length,
                itemBuilder: (context, index) {
                  final item = _historyData[index];
                  return _buildHistoryItem(item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(Map<String, dynamic> item) {
    Color statusColor;
    switch (item['status']) {
      case 'Normal':
        statusColor = AppColors.lightGreen;
        break;
      case 'Warning':
        statusColor = AppColors.lime;
        break;
      case 'Low':
        statusColor = Colors.red;
        break;
      default:
        statusColor = AppColors.lightGreen;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Icon(
                    Icons.air,
                    color: statusColor,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${item['date']} - ${item['time']}',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            item['status'],
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.air,
                              color: AppColors.primary,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'SpO2: ${item['oxygen']}%',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.timeline,
                              color: AppColors.lightPurple,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Pulse: ${item['pulse']} bpm',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
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
    );
  }
}