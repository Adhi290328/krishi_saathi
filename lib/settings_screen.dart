import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Theme Settings
  bool darkMode = false;
  bool useSystemTheme = true;
  String selectedThemeColor = 'Green';
  
  // Display Settings
  bool showCropImages = true;
  bool enableAnimations = true;
  String gridViewType = 'List';
  double fontSize = 16.0;
  
  // Notification Settings
  bool plantingReminders = true;
  bool harvestingReminders = true;
  bool weatherAlerts = true;
  bool marketPriceAlerts = false;
  String reminderTime = '08:00 AM';
  
  // Data & Privacy Settings
  bool offlineMode = false;
  bool autoBackup = true;
  bool shareUsageData = false;
  bool locationAccess = true;
  String dataStorageLocation = 'Device';
  
  // Language & Region Settings
  String selectedLanguage = 'English';
  String selectedRegion = 'India';
  String temperatureUnit = 'Celsius';
  String measurementUnit = 'Metric';
  
  // App Behavior Settings
  bool enableVibration = true;
  bool enableSound = true;
  bool autoRefresh = true;
  int refreshInterval = 30;
  bool showTips = true;
  
  // Account Settings (placeholders)
  String userProfile = 'John Farmer';
  String accountType = 'Free';

  final List<String> themeColors = ['Green', 'Blue', 'Orange', 'Purple', 'Teal'];
  final List<String> languages = ['English', 'Hindi', 'Tamil', 'Telugu', 'Bengali', 'Marathi'];
  final List<String> regions = ['India', 'USA', 'UK', 'Australia', 'Canada'];
  final List<String> gridTypes = ['List', 'Grid', 'Card'];
  final List<String> storageOptions = ['Device', 'Cloud', 'Both'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: _getThemeColor(),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.restore),
            onPressed: _resetToDefaults,
            tooltip: 'Reset to defaults',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          _buildAccountSection(),
          const SizedBox(height: 8),
          _buildThemeSection(),
          const SizedBox(height: 8),
          _buildDisplaySection(),
          const SizedBox(height: 8),
          _buildNotificationSection(),
          const SizedBox(height: 8),
          _buildDataPrivacySection(),
          const SizedBox(height: 8),
          _buildLanguageRegionSection(),
          const SizedBox(height: 8),
          _buildAppBehaviorSection(),
          const SizedBox(height: 8),
          _buildAboutSection(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildAccountSection() {
    return _buildSection(
      title: 'Account',
      icon: Icons.person,
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: _getThemeColor(),
            child: Text(userProfile[0]),
          ),
          title: Text(userProfile),
          subtitle: Text('$accountType Account'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showAccountDialog(),
        ),
        ListTile(
          leading: const Icon(Icons.sync),
          title: const Text('Sync Data'),
          subtitle: const Text('Last synced: 2 hours ago'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _syncData(),
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Sign Out'),
          onTap: () => _signOut(),
        ),
      ],
    );
  }

  Widget _buildThemeSection() {
    return _buildSection(
      title: 'Theme & Appearance',
      icon: Icons.palette,
      children: [
        SwitchListTile(
          title: const Text('Use System Theme'),
          subtitle: const Text('Follow device theme settings'),
          value: useSystemTheme,
          onChanged: (value) => setState(() => useSystemTheme = value),
        ),
        if (!useSystemTheme)
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Use dark theme'),
            value: darkMode,
            onChanged: (value) => setState(() => darkMode = value),
          ),
        ListTile(
          leading: const Icon(Icons.color_lens),
          title: const Text('Theme Color'),
          subtitle: Text(selectedThemeColor),
          trailing: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: _getThemeColor(),
              shape: BoxShape.circle,
            ),
          ),
          onTap: () => _showThemeColorPicker(),
        ),
        ListTile(
          leading: const Icon(Icons.text_fields),
          title: const Text('Font Size'),
          subtitle: Text('${fontSize.round()}px'),
          trailing: SizedBox(
            width: 150,
            child: Slider(
              value: fontSize,
              min: 12.0,
              max: 24.0,
              divisions: 6,
              onChanged: (value) => setState(() => fontSize = value),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDisplaySection() {
    return _buildSection(
      title: 'Display Settings',
      icon: Icons.display_settings,
      children: [
        SwitchListTile(
          title: const Text('Show Crop Images'),
          subtitle: const Text('Display images in crop list'),
          value: showCropImages,
          onChanged: (value) => setState(() => showCropImages = value),
        ),
        SwitchListTile(
          title: const Text('Enable Animations'),
          subtitle: const Text('Smooth transitions and effects'),
          value: enableAnimations,
          onChanged: (value) => setState(() => enableAnimations = value),
        ),
        ListTile(
          leading: const Icon(Icons.view_module),
          title: const Text('View Type'),
          subtitle: Text(gridViewType),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showViewTypePicker(),
        ),
      ],
    );
  }

  Widget _buildNotificationSection() {
    return _buildSection(
      title: 'Notifications',
      icon: Icons.notifications,
      children: [
        SwitchListTile(
          title: const Text('Planting Reminders'),
          subtitle: const Text('Remind me when to plant crops'),
          value: plantingReminders,
          onChanged: (value) => setState(() => plantingReminders = value),
        ),
        SwitchListTile(
          title: const Text('Harvesting Reminders'),
          subtitle: const Text('Remind me when to harvest'),
          value: harvestingReminders,
          onChanged: (value) => setState(() => harvestingReminders = value),
        ),
        SwitchListTile(
          title: const Text('Weather Alerts'),
          subtitle: const Text('Severe weather notifications'),
          value: weatherAlerts,
          onChanged: (value) => setState(() => weatherAlerts = value),
        ),
        SwitchListTile(
          title: const Text('Market Price Alerts'),
          subtitle: const Text('Price changes for your crops'),
          value: marketPriceAlerts,
          onChanged: (value) => setState(() => marketPriceAlerts = value),
        ),
        ListTile(
          leading: const Icon(Icons.schedule),
          title: const Text('Daily Reminder Time'),
          subtitle: Text(reminderTime),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _pickReminderTime(),
        ),
      ],
    );
  }

  Widget _buildDataPrivacySection() {
    return _buildSection(
      title: 'Data & Privacy',
      icon: Icons.privacy_tip,
      children: [
        SwitchListTile(
          title: const Text('Offline Mode'),
          subtitle: const Text('Use app without internet'),
          value: offlineMode,
          onChanged: (value) => setState(() => offlineMode = value),
        ),
        SwitchListTile(
          title: const Text('Auto Backup'),
          subtitle: const Text('Backup data automatically'),
          value: autoBackup,
          onChanged: (value) => setState(() => autoBackup = value),
        ),
        SwitchListTile(
          title: const Text('Share Usage Data'),
          subtitle: const Text('Help improve the app'),
          value: shareUsageData,
          onChanged: (value) => setState(() => shareUsageData = value),
        ),
        SwitchListTile(
          title: const Text('Location Access'),
          subtitle: const Text('For weather and local recommendations'),
          value: locationAccess,
          onChanged: (value) => setState(() => locationAccess = value),
        ),
        ListTile(
          leading: const Icon(Icons.storage),
          title: const Text('Data Storage'),
          subtitle: Text('Store data: $dataStorageLocation'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showStorageOptions(),
        ),
        ListTile(
          leading: const Icon(Icons.delete_forever),
          title: const Text('Clear App Data'),
          subtitle: const Text('Reset all app data'),
          onTap: () => _clearAppData(),
        ),
      ],
    );
  }

  Widget _buildLanguageRegionSection() {
    return _buildSection(
      title: 'Language & Region',
      icon: Icons.language,
      children: [
        ListTile(
          leading: const Icon(Icons.translate),
          title: const Text('Language'),
          subtitle: Text(selectedLanguage),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showLanguagePicker(),
        ),
        ListTile(
          leading: const Icon(Icons.location_on),
          title: const Text('Region'),
          subtitle: Text(selectedRegion),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showRegionPicker(),
        ),
        ListTile(
          leading: const Icon(Icons.thermostat),
          title: const Text('Temperature Unit'),
          subtitle: Text(temperatureUnit),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showTemperatureUnitPicker(),
        ),
        ListTile(
          leading: const Icon(Icons.straighten),
          title: const Text('Measurement Unit'),
          subtitle: Text(measurementUnit),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showMeasurementUnitPicker(),
        ),
      ],
    );
  }

  Widget _buildAppBehaviorSection() {
    return _buildSection(
      title: 'App Behavior',
      icon: Icons.settings,
      children: [
        SwitchListTile(
          title: const Text('Haptic Feedback'),
          subtitle: const Text('Vibration on interactions'),
          value: enableVibration,
          onChanged: (value) => setState(() => enableVibration = value),
        ),
        SwitchListTile(
          title: const Text('Sound Effects'),
          subtitle: const Text('Audio feedback'),
          value: enableSound,
          onChanged: (value) => setState(() => enableSound = value),
        ),
        SwitchListTile(
          title: const Text('Auto Refresh'),
          subtitle: const Text('Automatically refresh data'),
          value: autoRefresh,
          onChanged: (value) => setState(() => autoRefresh = value),
        ),
        if (autoRefresh)
          ListTile(
            leading: const Icon(Icons.refresh),
            title: const Text('Refresh Interval'),
            subtitle: Text('Every $refreshInterval minutes'),
            trailing: SizedBox(
              width: 150,
              child: Slider(
                value: refreshInterval.toDouble(),
                min: 15.0,
                max: 120.0,
                divisions: 7,
                onChanged: (value) => setState(() => refreshInterval = value.round()),
              ),
            ),
          ),
        SwitchListTile(
          title: const Text('Show Tips'),
          subtitle: const Text('Display helpful farming tips'),
          value: showTips,
          onChanged: (value) => setState(() => showTips = value),
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return _buildSection(
      title: 'About',
      icon: Icons.info,
      children: [
        ListTile(
          leading: const Icon(Icons.apps),
          title: const Text('App Version'),
          subtitle: const Text('1.0.0 (Build 1)'),
          onTap: () => _showVersionInfo(),
        ),
        ListTile(
          leading: const Icon(Icons.star),
          title: const Text('Rate App'),
          subtitle: const Text('Rate us on app store'),
          onTap: () => _rateApp(),
        ),
        ListTile(
          leading: const Icon(Icons.feedback),
          title: const Text('Send Feedback'),
          subtitle: const Text('Help us improve'),
          onTap: () => _sendFeedback(),
        ),
        ListTile(
          leading: const Icon(Icons.help),
          title: const Text('Help & Support'),
          subtitle: const Text('FAQs and contact support'),
          onTap: () => _showHelp(),
        ),
        ListTile(
          leading: const Icon(Icons.policy),
          title: const Text('Privacy Policy'),
          onTap: () => _showPrivacyPolicy(),
        ),
        ListTile(
          leading: const Icon(Icons.gavel),
          title: const Text('Terms of Service'),
          onTap: () => _showTermsOfService(),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _getThemeColor().withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: _getThemeColor(), size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _getThemeColor(),
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Color _getThemeColor() {
    switch (selectedThemeColor) {
      case 'Blue':
        return Colors.blue;
      case 'Orange':
        return Colors.orange;
      case 'Purple':
        return Colors.purple;
      case 'Teal':
        return Colors.teal;
      case 'Green':
      default:
        return Colors.green;
    }
  }

  // Action Methods
  void _showAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Account Settings'),
        content: const Text('Account management features coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _syncData() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data synced successfully!')),
    );
  }

  void _signOut() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Signed out successfully')),
              );
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _showThemeColorPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Theme Color'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: themeColors.map((color) {
            return RadioListTile<String>(
              title: Text(color),
              value: color,
              groupValue: selectedThemeColor,
              onChanged: (value) {
                setState(() => selectedThemeColor = value!);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showViewTypePicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select View Type'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: gridTypes.map((type) {
            return RadioListTile<String>(
              title: Text(type),
              value: type,
              groupValue: gridViewType,
              onChanged: (value) {
                setState(() => gridViewType = value!);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<void> _pickReminderTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 8, minute: 0),
    );
    if (picked != null) {
      setState(() {
        reminderTime = picked.format(context);
      });
    }
  }

  void _showLanguagePicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: languages.map((language) {
              return RadioListTile<String>(
                title: Text(language),
                value: language,
                groupValue: selectedLanguage,
                onChanged: (value) {
                  setState(() => selectedLanguage = value!);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _showRegionPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Region'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: regions.map((region) {
            return RadioListTile<String>(
              title: Text(region),
              value: region,
              groupValue: selectedRegion,
              onChanged: (value) {
                setState(() => selectedRegion = value!);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showStorageOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Data Storage Location'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: storageOptions.map((option) {
            return RadioListTile<String>(
              title: Text(option),
              value: option,
              groupValue: dataStorageLocation,
              onChanged: (value) {
                setState(() => dataStorageLocation = value!);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showTemperatureUnitPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Temperature Unit'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Celsius', 'Fahrenheit'].map((unit) {
            return RadioListTile<String>(
              title: Text(unit),
              value: unit,
              groupValue: temperatureUnit,
              onChanged: (value) {
                setState(() => temperatureUnit = value!);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showMeasurementUnitPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Measurement Unit'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Metric', 'Imperial'].map((unit) {
            return RadioListTile<String>(
              title: Text(unit),
              value: unit,
              groupValue: measurementUnit,
              onChanged: (value) {
                setState(() => measurementUnit = value!);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _clearAppData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear App Data'),
        content: const Text('This will delete all your data. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('App data cleared')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _resetToDefaults() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Settings'),
        content: const Text('Reset all settings to default values?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                darkMode = false;
                useSystemTheme = true;
                selectedThemeColor = 'Green';
                showCropImages = true;
                enableAnimations = true;
                gridViewType = 'List';
                fontSize = 16.0;
                plantingReminders = true;
                harvestingReminders = true;
                weatherAlerts = true;
                marketPriceAlerts = false;
                reminderTime = '08:00 AM';
                offlineMode = false;
                autoBackup = true;
                shareUsageData = false;
                locationAccess = true;
                dataStorageLocation = 'Device';
                selectedLanguage = 'English';
                selectedRegion = 'India';
                temperatureUnit = 'Celsius';
                measurementUnit = 'Metric';
                enableVibration = true;
                enableSound = true;
                autoRefresh = true;
                refreshInterval = 30;
                showTips = true;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings reset to defaults')),
              );
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _showVersionInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('App Version'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version: 1.0.0'),
            Text('Build: 1'),
            Text('Release Date: Dec 2024'),
            SizedBox(height: 16),
            Text('What\'s New:'),
            Text('• Enhanced crop database'),
            Text('• Improved user interface'),
            Text('• Better performance'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _rateApp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening app store...')),
    );
  }

  void _sendFeedback() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening feedback form...')),
    );
  }

  void _showHelp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & Support'),
        content: const Text('Help documentation and support features coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'Privacy Policy\n\n'
            'This app respects your privacy. We collect only necessary data '
            'to provide farming assistance services.\n\n'
            'Data Collection:\n'
            '• Crop preferences and farming data\n'
            '• Location data (with permission)\n'
            '• Usage analytics (anonymous)\n\n'
            'Data Usage:\n'
            '• Provide personalized farming advice\n'
            '• Weather and location-based recommendations\n'
            '• App improvement\n\n'
            'Your data is never sold to third parties.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showTermsOfService() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms of Service'),
        content: const SingleChildScrollView(
          child: Text(
            'Terms of Service\n\n'
            'By using this app, you agree to:\n\n'
            '1. Use the app responsibly for farming purposes\n'
            '2. Not misuse or attempt to hack the service\n'
            '3. Respect intellectual property rights\n'
            '4. Accept that farming advice is informational only\n\n'
            'Disclaimer:\n'
            'Farming advice is provided for informational purposes. '
            'Always consult local agricultural experts for specific conditions.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}