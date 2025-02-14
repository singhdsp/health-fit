import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../config/constants.dart';
import '../../services/health_api_service.dart';

class AllReadingsScreen extends StatefulWidget {
  const AllReadingsScreen({Key? key}) : super(key: key);

  @override
  State<AllReadingsScreen> createState() => _AllReadingsScreenState();
}

class _AllReadingsScreenState extends State<AllReadingsScreen> {
  final HealthApiService _healthService = HealthApiService();
  final Map<String, String> _filterMapping = {
    'Last 7 days': '7d',
    'Last 30 days': '30d',
    'Last 6 months': '6m',
    'All': 'all',
  };
  
  HealthRecordsResponse? _healthData;
  String _selectedFilter = 'Last 7 days';
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadHealthData();
  }

  Future<void> _loadHealthData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final filter = _filterMapping[_selectedFilter] ?? '7d';
      debugPrint('Fetching data with filter: $filter');
      
      final data = await _healthService.fetchHealthRecords(filter: filter);
     debugPrint('Raw API response: ${data.records}'); 

      setState(() {
        _healthData = data;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching data: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load data. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Readings'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Text(
          _errorMessage,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 16,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFilterSection(),
        _buildStatisticsSection(),
        Expanded(child: _buildReadingsList()),
      ],
    );
  }

  Widget _buildFilterSection() {
    return Padding(
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
              children: _filterMapping.keys.map((filter) {
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (_) => setState(() {
                      _selectedFilter = filter;
                      _loadHealthData();
                    }),
                    backgroundColor: Colors.white,
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textSecondary,
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
    final average = _healthData?.average ?? HealthAverage(spo2: 0, pulse: 0, temperature: 0);
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Avg SpO2', '${average.spo2.toStringAsFixed(1)}%'),
          _buildStatItem('Avg Pulse', '${average.pulse.toStringAsFixed(1)} bpm'),
          _buildStatItem('Total', '${_healthData?.records.length ?? 0}'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: AppColors.textSecondary)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(
          color: AppColors.primary,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        )),
      ],
    );
  }

  Widget _buildReadingsList() {
    final records = _healthData?.records ?? [];
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: records.length,
      itemBuilder: (context, index) => _buildReadingItem(records[index]),
    );
  }

  Widget _buildReadingItem(HealthRecord record) {
    final status = _getStatus(record);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: status.color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            _getStatusIcon(status),
            color: status.color,
          ),
        ),
        title: Text(
          '${record.formattedDate} ${record.formattedTime}',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('SpO2: ${record.spo2}%'),
            Text('Pulse: ${record.pulse} bpm'),
            Text('Temp: ${record.temperature.toStringAsFixed(1)}°F'),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: status.color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            status.label,
            style: TextStyle(color: status.color),
          ),
        ),
      ),
    );
  }

  HealthStatus _getStatus(HealthRecord record) {
    if (record.spo2 < 95 || record.pulse > 100 || record.temperature > 37.5) {
      return HealthStatus.warning;
    }
    return HealthStatus.normal;
  }

  IconData _getStatusIcon(HealthStatus status) {
    return status == HealthStatus.normal ? Icons.check_circle : Icons.warning;
  }
}

enum HealthStatus {
  normal(AppColors.lightGreen, 'Normal'),
  warning(AppColors.lime, 'Warning');

  final Color color;
  final String label;

  const HealthStatus(this.color, this.label);
}