import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mpmc_proj/services/health_api_service.dart';
import '../../config/constants.dart';
import '../../services/supabase_service.dart';
import './all_readings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _healthApiService = HealthApiService();
  HealthRecordsResponse? _healthData;
  final _supabaseService = SupabaseService();
  Map<String, dynamic>? _userProfile;
  bool _isLoading = true;

   @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _loadHealthData();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final profile = await _supabaseService.getUserProfile();
      if (mounted) {
        setState(() {
          _userProfile = profile;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadHealthData() async {
    try {
      final data = await _healthApiService.fetchHealthRecords(filter: '7d');
      if (mounted) {
        setState(() => _healthData = data);
      }
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadUserProfile,
      color: AppColors.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserCard(),
            const SizedBox(height: 20),
            _buildHealthSummary(),
            const SizedBox(height: 20),
            _buildRecentReadings(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard() {
    if (_isLoading) {
      return _buildLoadingCard();
    }
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.lightPurple,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: Text(
                  _userProfile?['username']?.substring(0, 1).toUpperCase() ?? 'U',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back,',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _userProfile?['username'] ?? 'User',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Email:',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
              Expanded(
                child: Text(
                  _userProfile?['email'] ?? 'email@example.com',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Member since:',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
              Text(
                _formatDate(_userProfile?['created_at']),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'N/A';
    }
  }

  Widget _buildLoadingCard() {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100,
                      height: 12,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 150,
                      height: 18,
                      color: Colors.grey.shade300,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 80,
                height: 12,
                color: Colors.grey.shade300,
              ),
              Container(
                width: 150,
                height: 12,
                color: Colors.grey.shade300,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 100,
                height: 12,
                color: Colors.grey.shade300,
              ),
              Container(
                width: 100,
                height: 12,
                color: Colors.grey.shade300,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHealthSummary() {
    final average = _healthData?.average;
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Health Summary',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
              children: [
            Expanded(
              child: _buildHealthMetricCard(
                'SpO2',
                average?.spo2.toStringAsFixed(0) ?? '--',
                '%',
                Icons.air,
                AppColors.lime,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildHealthMetricCard(
                'Heart Rate',
                average?.pulse.toStringAsFixed(0) ?? '--',
                'bpm',
                Icons.favorite_border,
                AppColors.lightGreen,
              ),
            ),
          ],
          ),
        ],
      ),
    );
  }

  Widget _buildHealthMetricCard(
    String title,
    String value,
    String unit,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: AppColors.primary,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.clip,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                unit,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentReadings() {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Readings',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AllReadingsScreen(),
                    ),
                  );
                },
                child: Text(
                  'See All',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildReadingItem(
            date: 'Today',
            time: '08:30 AM',
            spo2: '98',
            pulse: '72',
          ),
          const Divider(),
          _buildReadingItem(
            date: 'Yesterday',
            time: '09:15 AM',
            spo2: '97',
            pulse: '70',
          ),
          const Divider(),
          _buildReadingItem(
            date: '2 days ago',
            time: '07:45 AM',
            spo2: '99',
            pulse: '75',
          ),
        ],
      ),
    );
  }

  Widget _buildReadingItem({
    required String date,
    required String time,
    required String spo2,
    required String pulse,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.lightPurple.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.calendar_today,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$date, $time',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Wrap(
                  spacing: 15,
                  runSpacing: 5,
                  children: [
                    Text(
                      'SpO2: $spo2%',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Pulse: $pulse bpm',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}