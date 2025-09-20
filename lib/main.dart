import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:math';
import 'home_screen.dart';
import 'crops_screen.dart';
import 'settings_screen.dart';
import 'weather_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Enhanced system UI configuration
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Load environment with enhanced error handling
  try {
    await dotenv.load(fileName: ".env");
    debugPrint('Environment file loaded successfully');
  } catch (e) {
    debugPrint('Warning: Could not load .env file: $e');
  }
  
  runApp(const KrishiSaathiApp());
}

class KrishiSaathiApp extends StatefulWidget {
  const KrishiSaathiApp({super.key});

  @override
  State<KrishiSaathiApp> createState() => _KrishiSaathiAppState();
}

class _KrishiSaathiAppState extends State<KrishiSaathiApp> {
  ThemeMode _themeMode = ThemeMode.system;
  bool _isDarkMode = false;
  String _selectedAccentColor = 'green';
  double _fontScale = 1.0;
  bool _enableAnimations = true;
  bool _enableHapticFeedback = true;
  
  @override
  void initState() {
    super.initState();
    _loadUserPreferences();
  }

  Future<void> _loadUserPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _themeMode = ThemeMode.values[prefs.getInt('themeMode') ?? 0];
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _selectedAccentColor = prefs.getString('accentColor') ?? 'green';
      _fontScale = prefs.getDouble('fontScale') ?? 1.0;
      _enableAnimations = prefs.getBool('enableAnimations') ?? true;
      _enableHapticFeedback = prefs.getBool('enableHapticFeedback') ?? true;
    });
  }

  Future<void> updateThemeSettings({
    ThemeMode? themeMode,
    bool? isDarkMode,
    String? accentColor,
    double? fontScale,
    bool? enableAnimations,
    bool? enableHapticFeedback,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    
    setState(() {
      if (themeMode != null) _themeMode = themeMode;
      if (isDarkMode != null) _isDarkMode = isDarkMode;
      if (accentColor != null) _selectedAccentColor = accentColor;
      if (fontScale != null) _fontScale = fontScale;
      if (enableAnimations != null) _enableAnimations = enableAnimations;
      if (enableHapticFeedback != null) _enableHapticFeedback = enableHapticFeedback;
    });

    if (themeMode != null) await prefs.setInt('themeMode', themeMode.index);
    if (isDarkMode != null) await prefs.setBool('isDarkMode', isDarkMode);
    if (accentColor != null) await prefs.setString('accentColor', accentColor);
    if (fontScale != null) await prefs.setDouble('fontScale', fontScale);
    if (enableAnimations != null) await prefs.setBool('enableAnimations', enableAnimations);
    if (enableHapticFeedback != null) await prefs.setBool('enableHapticFeedback', enableHapticFeedback);
  }

  MaterialColor _getAccentColor() {
    switch (_selectedAccentColor) {
      case 'blue': return Colors.blue;
      case 'red': return Colors.red;
      case 'orange': return Colors.orange;
      case 'purple': return Colors.purple;
      case 'teal': return Colors.teal;
      case 'indigo': return Colors.indigo;
      default: return Colors.green;
    }
  }

  ThemeData _buildLightTheme() {
    final accent = _getAccentColor();
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primarySwatch: accent,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      
      // Color scheme
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: accent,
        brightness: Brightness.light,
        backgroundColor: Colors.grey[50],
        cardColor: Colors.white,
      ),
      
      // Typography with font scaling
      textTheme: ThemeData.light().textTheme.apply(fontSizeFactor: _fontScale),
      primaryTextTheme: ThemeData.light().primaryTextTheme.apply(fontSizeFactor: _fontScale),
      
      // App bar
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 4,
        backgroundColor: accent.shade700,
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(
          fontSize: 20 * _fontScale,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      
      // Navigation
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: accent,
        unselectedItemColor: Colors.grey.shade600,
        elevation: 16,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontSize: 12 * _fontScale, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 12 * _fontScale),
      ),
      
      // Cards
      cardTheme: CardThemeData(
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(8),
      ),
      
      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          shadowColor: accent.withOpacity(0.3),
          backgroundColor: accent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 6,
        backgroundColor: accent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      
      // Animations
      pageTransitionsTheme: PageTransitionsTheme(
        builders: _enableAnimations ? {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        } : {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    final accent = _getAccentColor();
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primarySwatch: accent,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: accent,
        brightness: Brightness.dark,
        backgroundColor: const Color(0xFF121212),
        cardColor: const Color(0xFF1E1E1E),
      ),
      
      textTheme: ThemeData.dark().textTheme.apply(fontSizeFactor: _fontScale),
      primaryTextTheme: ThemeData.dark().primaryTextTheme.apply(fontSizeFactor: _fontScale),
      
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 4,
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(
          fontSize: 20 * _fontScale,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(0xFF1E1E1E),
        selectedItemColor: accent.shade300,
        unselectedItemColor: Colors.grey.shade500,
        elevation: 16,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontSize: 12 * _fontScale, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 12 * _fontScale),
      ),
      
      cardTheme: CardThemeData(
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(8),
        color: const Color(0xFF1E1E1E),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          shadowColor: accent.withOpacity(0.3),
          backgroundColor: accent.shade700,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 6,
        backgroundColor: accent.shade700,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      
      pageTransitionsTheme: PageTransitionsTheme(
        builders: _enableAnimations ? {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        } : {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: dotenv.env['APP_NAME'] ?? "Krishi Saathi",
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: _themeMode,
      debugShowCheckedModeBanner: false,
      
      // Global app settings
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(_fontScale),
          ),
          child: AppLifecycleHandler(
            enableHapticFeedback: _enableHapticFeedback,
            child: child!,
          ),
        );
      },
      
      home: EnhancedMainPage(
        themeSettings: {
          'themeMode': _themeMode,
          'isDarkMode': _isDarkMode,
          'accentColor': _selectedAccentColor,
          'fontScale': _fontScale,
          'enableAnimations': _enableAnimations,
          'enableHapticFeedback': _enableHapticFeedback,
        },
        updateThemeSettings: updateThemeSettings,
      ),
    );
  }
}

class AppLifecycleHandler extends StatefulWidget {
  final Widget child;
  final bool enableHapticFeedback;

  const AppLifecycleHandler({
    super.key,
    required this.child,
    required this.enableHapticFeedback,
  });

  @override
  State<AppLifecycleHandler> createState() => _AppLifecycleHandlerState();
}

class _AppLifecycleHandlerState extends State<AppLifecycleHandler> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (widget.enableHapticFeedback) {
          HapticFeedback.lightImpact();
        }
        break;
      case AppLifecycleState.paused:
        // Save app state here if needed
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class EnhancedMainPage extends StatefulWidget {
  final Map<String, dynamic> themeSettings;
  final Function updateThemeSettings;

  const EnhancedMainPage({
    super.key,
    required this.themeSettings,
    required this.updateThemeSettings,
  });

  @override
  State<EnhancedMainPage> createState() => _EnhancedMainPageState();
}

class _EnhancedMainPageState extends State<EnhancedMainPage> 
    with TickerProviderStateMixin, WidgetsBindingObserver {
  
  int _currentIndex = 0;
  int _previousIndex = 0;
  late PageController _pageController;
  late List<AnimationController> _tabAnimationControllers;
  late AnimationController _fabAnimationController;
  late AnimationController _backgroundAnimationController;
  late Timer _inactivityTimer;
  
  // Advanced features
  bool _isKeyboardVisible = false;
  final double _currentScrollOffset = 0.0;
  final List<String> _navigationHistory = [];
  DateTime _lastInteractionTime = DateTime.now();

  final List<NavigationItem> _navItems = [
    NavigationItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Home',
      screen: const HomeScreen(),
      color: Colors.blue,
    ),
    NavigationItem(
      icon: Icons.agriculture_outlined,
      activeIcon: Icons.agriculture,
      label: 'Crops',
      screen: const CropsScreen(),
      color: Colors.green,
    ),
    NavigationItem(
      icon: Icons.cloud_outlined,
      activeIcon: Icons.cloud,
      label: 'Weather',
      screen: const EnhancedWeatherScreen(),
      color: Colors.orange,
    ),
    NavigationItem(
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings,
      label: 'Settings',
      screen: const SettingsScreen(),
      color: Colors.purple,
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeControllers();
    _startInactivityTimer();
  }

  void _initializeControllers() {
    _pageController = PageController(initialPage: _currentIndex);
    
    _tabAnimationControllers = List.generate(
      _navItems.length,
      (index) => AnimationController(
        duration: Duration(
          milliseconds: widget.themeSettings['enableAnimations'] ? 300 : 0,
        ),
        vsync: this,
      ),
    );
    
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _backgroundAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Start initial animations
    _tabAnimationControllers[0].forward();
    _fabAnimationController.forward();
    _backgroundAnimationController.repeat();
  }

  void _startInactivityTimer() {
    _inactivityTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      final timeSinceLastInteraction = DateTime.now().difference(_lastInteractionTime);
      if (timeSinceLastInteraction.inMinutes >= 5) {
        _showInactivityDialog();
      }
    });
  }

  void _showInactivityDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Still there?'),
        content: const Text('You\'ve been inactive for a while. Continue using the app?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _updateLastInteractionTime();
            },
            child: const Text('Yes, continue'),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: const Text('Exit app'),
          ),
        ],
      ),
    );
  }

  void _updateLastInteractionTime() {
    _lastInteractionTime = DateTime.now();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    final newValue = bottomInset > 0.0;
    if (newValue != _isKeyboardVisible) {
      setState(() {
        _isKeyboardVisible = newValue;
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pageController.dispose();
    _fabAnimationController.dispose();
    _backgroundAnimationController.dispose();
    _inactivityTimer.cancel();
    for (var controller in _tabAnimationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (index == _currentIndex) {
      // Double tap to scroll to top or refresh
      _handleDoubleTabTap();
      return;
    }

    _updateLastInteractionTime();
    
    if (widget.themeSettings['enableHapticFeedback']) {
      HapticFeedback.lightImpact();
    }

    // Add to navigation history
    _navigationHistory.add(_navItems[_currentIndex].label);
    if (_navigationHistory.length > 10) {
      _navigationHistory.removeAt(0);
    }

    setState(() {
      _previousIndex = _currentIndex;
      _currentIndex = index;
    });

    // Animate page transition
    if (widget.themeSettings['enableAnimations']) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _pageController.jumpToPage(index);
    }

    // Animate tab icons
    _animateTabSelection(index);
  }

  void _animateTabSelection(int index) {
    for (int i = 0; i < _tabAnimationControllers.length; i++) {
      if (i == index) {
        _tabAnimationControllers[i].forward();
      } else {
        _tabAnimationControllers[i].reverse();
      }
    }
  }

  void _handleDoubleTabTap() {
    if (widget.themeSettings['enableHapticFeedback']) {
      HapticFeedback.mediumImpact();
    }
    
    // Scroll to top or refresh current page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Refreshing ${_navItems[_currentIndex].label}'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _backgroundAnimationController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).scaffoldBackgroundColor,
                Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
              ],
              stops: [
                0.0 + (0.1 * sin(_backgroundAnimationController.value * 2 * pi)),
                1.0,
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSmartBottomNavBar() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _isKeyboardVisible ? 0 : kBottomNavigationBarHeight + 16,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onTabTapped,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
            items: _navItems.asMap().entries.map((entry) {
              return _buildNavItem(entry.key, entry.value);
            }).toList(),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(int index, NavigationItem item) {
    final isSelected = index == _currentIndex;
    
    return BottomNavigationBarItem(
      icon: AnimatedBuilder(
        animation: _tabAnimationControllers[index],
        builder: (context, child) {
          final scale = 0.8 + (0.4 * _tabAnimationControllers[index].value);
          final rotation = _tabAnimationControllers[index].value * 0.1;
          
          return Transform.scale(
            scale: scale,
            child: Transform.rotate(
              angle: rotation,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: isSelected ? BoxDecoration(
                  color: item.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ) : null,
                child: Icon(
                  isSelected ? item.activeIcon : item.icon,
                  color: isSelected ? item.color : null,
                ),
              ),
            ),
          );
        },
      ),
      label: item.label,
    );
  }

  Widget _buildAdvancedPageView() {
    if (!widget.themeSettings['enableAnimations']) {
      return IndexedStack(
        index: _currentIndex,
        children: _navItems.map((item) => item.screen).toList(),
      );
    }

    return PageView.builder(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          _previousIndex = _currentIndex;
          _currentIndex = index;
        });
        _animateTabSelection(index);
      },
      itemCount: _navItems.length,
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _pageController,
          builder: (context, child) {
            double value = 1.0;
            if (_pageController.position.haveDimensions) {
              value = _pageController.page! - index;
              value = (1 - (value.abs() * 0.3)).clamp(0.7, 1.0);
            }

            return Transform.scale(
              scale: value,
              child: Opacity(
                opacity: value,
                child: _navItems[index].screen,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFloatingActionButton() {
    if (_currentIndex == 3) return const SizedBox(); // Hide on settings
    
    return ScaleTransition(
      scale: _fabAnimationController,
      child: FloatingActionButton(
        onPressed: () {
          _updateLastInteractionTime();
          if (widget.themeSettings['enableHapticFeedback']) {
            HapticFeedback.mediumImpact();
          }
          
          // Show quick actions based on current screen
          _showQuickActions();
        },
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Icon(
            _getQuickActionIcon(),
            key: ValueKey(_currentIndex),
          ),
        ),
      ),
    );
  }

  IconData _getQuickActionIcon() {
    switch (_currentIndex) {
      case 0: return Icons.add;
      case 1: return Icons.search;
      case 2: return Icons.refresh;
      default: return Icons.help;
    }
  }

  void _showQuickActions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Quick Actions - ${_navItems[_currentIndex].label}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Icon(_getQuickActionIcon()),
              title: Text(_getQuickActionTitle()),
              onTap: () {
                Navigator.pop(context);
                _executeQuickAction();
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Navigation History'),
              onTap: () {
                Navigator.pop(context);
                _showNavigationHistory();
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getQuickActionTitle() {
    switch (_currentIndex) {
      case 0: return 'Add New Item';
      case 1: return 'Search Crops';
      case 2: return 'Refresh Weather';
      default: return 'Get Help';
    }
  }

  void _executeQuickAction() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_getQuickActionTitle()} - Feature coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showNavigationHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Navigation History'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _navigationHistory.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Text('${index + 1}.'),
                title: Text(_navigationHistory[index]),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          _buildAnimatedBackground(),
          SafeArea(
            bottom: false,
            child: _buildAdvancedPageView(),
          ),
        ],
      ),
      bottomNavigationBar: _buildSmartBottomNavBar(),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class NavigationItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final Widget screen;
  final Color color;

  NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.screen,
    required this.color,
  });
}