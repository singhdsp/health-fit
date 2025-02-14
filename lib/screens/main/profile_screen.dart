import 'package:flutter/material.dart';
import '../../config/constants.dart';
import '../../services/supabase_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _supabaseService = SupabaseService();
  Map<String, dynamic>? _userProfile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
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

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadUserProfile,
      color: AppColors.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            _buildProfileHeader(),
            const SizedBox(height: 30),
            _buildProfileDetails(),
            const SizedBox(height: 30),
            _buildHealthInfo(),
            const SizedBox(height: 30),
            _buildPreferences(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    if (_isLoading) {
      return Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey,
          ),
          const SizedBox(height: 15),
          Container(
            width: 150,
            height: 20,
            color: Colors.grey.shade300,
          ),
        ],
      );
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                AppColors.primary,
                AppColors.lightPurple,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Text(
              _userProfile?['username']?.substring(0, 1).toUpperCase() ?? 'U',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        Text(
          _userProfile?['username'] ?? 'User',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          _userProfile?['email'] ?? 'email@example.com',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileDetails() {
    if (_isLoading) {
      return _buildLoadingCard();
    }

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
            'Personal Information',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildInfoRow('Username', _userProfile?['username'] ?? 'User'),
          const Divider(),
          _buildInfoRow('Email', _userProfile?['email'] ?? 'email@example.com'),
          const Divider(),
          _buildInfoRow('Member since', _formatDate(_userProfile?['created_at'])),
          const Divider(),
          _buildInfoRow('Last login', 'Today, 08:30 AM'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthInfo() {
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
            'Health Information',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildInfoRow('Age', '35'),
          const Divider(),
          _buildInfoRow('Height', '175 cm'),
          const Divider(),
          _buildInfoRow('Weight', '70 kg'),
          const Divider(),
          _buildInfoRow('Blood Type', 'O+'),
        ],
      ),
    );
  }

  Widget _buildPreferences() {
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
            'Settings',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildSettingItem(
            'Edit Profile',
            Icons.edit,
            AppColors.lime,
          ),
          const Divider(),
          _buildSettingItem(
            'Notifications',
            Icons.notifications_none,
            AppColors.lightGreen,
          ),
          const Divider(),
          _buildSettingItem(
            'Privacy',
            Icons.privacy_tip_outlined,
            AppColors.lightPurple,
          ),
          const Divider(),
          _buildSettingItem(
            'Help & Support',
            Icons.help_outline,
            AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(String title, IconData icon, Color color) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 180,
            height: 24,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 80,
                height: 16,
                color: Colors.grey.shade300,
              ),
              Container(
                width: 120,
                height: 16,
                color: Colors.grey.shade300,
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 80,
                height: 16,
                color: Colors.grey.shade300,
              ),
              Container(
                width: 180,
                height: 16,
                color: Colors.grey.shade300,
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
}