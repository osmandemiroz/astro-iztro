import 'package:astro_iztro/app/modules/home/home_controller.dart';
import 'package:astro_iztro/core/constants/app_constants.dart';
import 'package:astro_iztro/core/constants/colors.dart';
import 'package:astro_iztro/core/models/user_profile.dart';
import 'package:astro_iztro/shared/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// [HomeView] - Main dashboard screen with Apple-inspired design
/// Provides quick access to all astrology features and user profiles
class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Modern gradient background for visual appeal
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: SafeArea(
          child: Obx(_buildBody),
        ),
      ),

      // Floating action button for quick profile creation
      floatingActionButton: _buildFloatingActionButton(),

      // Bottom navigation for main app sections
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  /// [buildBody] - Main body content with sections
  Widget _buildBody() {
    if (controller.isLoading.value) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        _buildAppBar(),
        _buildMainContent(),
      ],
    );
  }

  /// [buildAppBar] - Custom app bar with user greeting
  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Astro Iztro',
          style: AppTheme.headingMedium.copyWith(
            color: AppColors.white,
            fontFamily: AppConstants.decorativeFont,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.primaryGradient,
          ),
          child: _buildHeaderContent(),
        ),
      ),
      actions: [
        // Settings button
        IconButton(
          onPressed: controller.navigateToSettings,
          icon: const Icon(
            Icons.settings_outlined,
            color: AppColors.white,
          ),
        ),
      ],
    );
  }

  /// [buildHeaderContent] - Header with user greeting and quick stats
  Widget _buildHeaderContent() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Obx(() {
            final profile = controller.currentProfile.value;
            return Text(
              profile != null
                  ? 'Welcome back, ${profile.name ?? 'User'}!'
                  : 'Welcome to Astro Iztro!',
              style: AppTheme.bodyLarge.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w500,
              ),
            );
          }),
          const SizedBox(height: AppConstants.smallPadding),
          Row(
            children: [
              _buildQuickStat(
                icon: Icons.people_outline,
                label: 'Profiles',
                value: controller.savedProfiles.length.toString(),
              ),
              const SizedBox(width: AppConstants.defaultPadding),
              _buildQuickStat(
                icon: Icons.history,
                label: 'Recent',
                value: controller.recentCalculations.length.toString(),
              ),
              const SizedBox(width: AppConstants.defaultPadding),
              _buildQuickStat(
                icon: Icons.favorite_outline,
                label: 'Favorites',
                value: controller.favoriteCharts.length.toString(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// [buildQuickStat] - Small stat display widget
  Widget _buildQuickStat({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.white.withValues(alpha: 0.8),
        ),
        const SizedBox(width: 4),
        Text(
          '$value $label',
          style: AppTheme.caption.copyWith(
            color: AppColors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  /// [buildMainContent] - Main scrollable content
  Widget _buildMainContent() {
    return SliverToBoxAdapter(
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.grey50,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppConstants.borderRadius * 2),
            topRight: Radius.circular(AppConstants.borderRadius * 2),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCurrentProfileSection(),
              const SizedBox(height: AppConstants.largePadding),
              _buildQuickActionsSection(),
              const SizedBox(height: AppConstants.largePadding),
              _buildRecentCalculationsSection(),
              const SizedBox(height: AppConstants.largePadding),
              _buildSavedProfilesSection(),
            ],
          ),
        ),
      ),
    );
  }

  /// [buildCurrentProfileSection] - Current profile card
  Widget _buildCurrentProfileSection() {
    return Obx(() {
      final profile = controller.currentProfile.value;

      if (profile == null) {
        return _buildNoProfileCard();
      }

      return Card(
        elevation: AppConstants.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Current Profile',
                    style: AppTheme.headingSmall,
                  ),
                  IconButton(
                    onPressed: controller.navigateToInput,
                    icon: const Icon(
                      Icons.edit_outlined,
                      color: AppColors.primaryPurple,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.smallPadding),
              _buildProfileInfo(profile),
            ],
          ),
        ),
      );
    });
  }

  /// [buildNoProfileCard] - Card shown when no profile exists
  Widget _buildNoProfileCard() {
    return Card(
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        side: const BorderSide(
          color: AppColors.primaryPurple,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          children: [
            Icon(
              Icons.person_add_outlined,
              size: 48,
              color: AppColors.primaryPurple.withValues(alpha: 0.7),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            Text(
              'Create Your First Profile',
              style: AppTheme.headingSmall.copyWith(
                color: AppColors.primaryPurple,
              ),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            Text(
              'Start your astrological journey by creating a profile with your birth information.',
              style: AppTheme.bodyMedium.copyWith(
                color: AppColors.grey600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            ElevatedButton.icon(
              onPressed: controller.navigateToInput,
              icon: const Icon(Icons.add),
              label: const Text('Create Profile'),
            ),
          ],
        ),
      ),
    );
  }

  /// [buildProfileInfo] - Display profile information
  Widget _buildProfileInfo(UserProfile profile) {
    return Column(
      children: [
        _buildInfoRow(
          Icons.person_outline,
          'Name',
          profile.name ?? 'Unknown',
        ),
        _buildInfoRow(
          Icons.calendar_today_outlined,
          'Birth Date',
          '${profile.birthDate.day}/${profile.birthDate.month}/${profile.birthDate.year}',
        ),
        _buildInfoRow(
          Icons.access_time_outlined,
          'Birth Time',
          profile.formattedBirthTime,
        ),
        _buildInfoRow(
          Icons.location_on_outlined,
          'Location',
          profile.locationString,
        ),
      ],
    );
  }

  /// [buildInfoRow] - Information row widget
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: AppColors.grey500,
          ),
          const SizedBox(width: AppConstants.smallPadding),
          Text(
            '$label:',
            style: AppTheme.bodyMedium.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.grey600,
            ),
          ),
          const SizedBox(width: AppConstants.smallPadding),
          Expanded(
            child: Text(
              value,
              style: AppTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// [buildQuickActionsSection] - Quick action buttons
  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: AppTheme.headingSmall,
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                icon: Icons.circle_outlined,
                title: 'Purple Star Chart',
                subtitle: 'View your astrology chart',
                onTap: controller.navigateToChart,
                color: AppColors.primaryPurple,
              ),
            ),
            const SizedBox(width: AppConstants.defaultPadding),
            Expanded(
              child: _buildActionCard(
                icon: Icons.view_column_outlined,
                title: 'BaZi Analysis',
                subtitle: 'Four Pillars reading',
                onTap: controller.navigateToBaZi,
                color: AppColors.primaryGold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                icon: Icons.analytics_outlined,
                title: 'Detailed Analysis',
                subtitle: 'In-depth interpretation',
                onTap: controller.navigateToAnalysis,
                color: AppColors.lightPurple,
              ),
            ),
            const SizedBox(width: AppConstants.defaultPadding),
            Expanded(
              child: _buildActionCard(
                icon: Icons.person_add_outlined,
                title: 'New Profile',
                subtitle: 'Add family/friends',
                onTap: controller.navigateToInput,
                color: AppColors.success,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// [buildActionCard] - Individual action card
  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Card(
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
                color: color,
              ),
              const SizedBox(height: AppConstants.smallPadding),
              Text(
                title,
                style: AppTheme.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTheme.caption,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// [buildRecentCalculationsSection] - Recent calculations list
  Widget _buildRecentCalculationsSection() {
    return Obx(() {
      if (!controller.hasRecentCalculations) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Calculations',
                style: AppTheme.headingSmall,
              ),
              TextButton(
                onPressed: controller.clearRecentCalculations,
                child: const Text('Clear All'),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          ...controller.recentCalculations
              .take(5)
              .map(_buildRecentCalculationCard),
        ],
      );
    });
  }

  /// [buildRecentCalculationCard] - Individual recent calculation card
  Widget _buildRecentCalculationCard(Map<String, dynamic> calculation) {
    final type = calculation['type'] as String;
    final profileName = calculation['profile_name'] as String;
    final calculatedAt = DateTime.parse(calculation['calculated_at'] as String);

    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.smallPadding),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: type == 'chart'
              ? AppColors.primaryPurple
              : AppColors.primaryGold,
          child: Icon(
            type == 'chart'
                ? Icons.circle_outlined
                : Icons.view_column_outlined,
            color: AppColors.white,
          ),
        ),
        title: Text(
          '$profileName - ${type == 'chart' ? 'Purple Star Chart' : 'BaZi Analysis'}',
          style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          'Calculated ${_formatTimeAgo(calculatedAt)}',
          style: AppTheme.caption,
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          // Navigate to appropriate screen based on type
          if (type == 'chart') {
            controller.navigateToChart();
          } else {
            controller.navigateToBaZi();
          }
        },
      ),
    );
  }

  /// [buildSavedProfilesSection] - Saved profiles section
  Widget _buildSavedProfilesSection() {
    return Obx(() {
      if (!controller.hasSavedProfiles) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Saved Profiles',
            style: AppTheme.headingSmall,
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          ...controller.savedProfiles.map(
            _buildProfileCard,
          ),
        ],
      );
    });
  }

  /// [buildProfileCard] - Individual profile card
  Widget _buildProfileCard(UserProfile profile) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.smallPadding),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: profile.gender == 'male'
              ? AppColors.lightGold
              : AppColors.lightPurple,
          child: Icon(
            profile.gender == 'male' ? Icons.male : Icons.female,
            color: AppColors.white,
          ),
        ),
        title: Text(
          profile.name ?? 'Unknown',
          style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          '${profile.birthDate.day}/${profile.birthDate.month}/${profile.birthDate.year} - ${profile.formattedBirthTime}',
          style: AppTheme.caption,
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'use',
              child: Text('Use Profile'),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Text('Delete'),
            ),
          ],
          onSelected: (value) {
            if (value == 'use') {
              controller.setCurrentProfile(profile);
            } else if (value == 'delete') {
              _showDeleteProfileDialog(profile);
            }
          },
        ),
        onTap: () => controller.setCurrentProfile(profile),
      ),
    );
  }

  /// [buildFloatingActionButton] - FAB for quick profile creation
  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: controller.navigateToInput,
      icon: const Icon(Icons.add),
      label: const Text('New Profile'),
      backgroundColor: AppColors.primaryGold,
      foregroundColor: AppColors.white,
    );
  }

  /// [buildBottomNavigationBar] - Bottom navigation bar
  Widget _buildBottomNavigationBar() {
    return Obx(
      () => BottomNavigationBar(
        currentIndex: controller.selectedBottomNavIndex.value,
        onTap: (index) {
          controller.setBottomNavIndex(index);
          switch (index) {
            case 0:
              // Already on home
              break;
            case 1:
              controller.navigateToChart();
            case 2:
              controller.navigateToBaZi();
            case 3:
              controller.navigateToAnalysis();
            case 4:
              controller.navigateToSettings();
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primaryPurple,
        unselectedItemColor: AppColors.grey400,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.circle_outlined),
            activeIcon: Icon(Icons.circle),
            label: 'Chart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_column_outlined),
            activeIcon: Icon(Icons.view_column),
            label: 'BaZi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            activeIcon: Icon(Icons.analytics),
            label: 'Analysis',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  /// Helper method to format time ago
  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  /// Show delete confirmation dialog
  void _showDeleteProfileDialog(UserProfile profile) {
    Get.dialog<void>(
      AlertDialog(
        title: const Text('Delete Profile'),
        content: Text(
          'Are you sure you want to delete ${profile.name ?? 'this profile'}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back<void>(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back<void>();
              controller.deleteProfile(profile);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
