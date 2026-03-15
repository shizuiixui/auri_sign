import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auri_sign/config/api_constants.dart';
import 'package:auri_sign/core/routes/app_router.dart';

// Widgets
import 'package:auri_sign/core/widgets/bottom_nav_bar.dart';

// Screens
import 'package:auri_sign/features/profile/presentation/screens/profile.dart';
import 'package:auri_sign/features/homepage/presentation/screens/homepage.dart';
import 'package:auri_sign/features/dictionary/presentation/screens/dictionary.dart';
import 'package:auri_sign/features/gesture/presentation/screens/gesture_webview_screen.dart';

// Data & ViewModels
import 'package:auri_sign/features/dictionary/data/repositories/dictionary_repository.dart';
import 'package:auri_sign/features/dictionary/presentation/viewmodels/dictionary_viewmodel.dart';

class NavFunction extends StatefulWidget {
  const NavFunction({super.key});

  @override
  State<NavFunction> createState() => _NavFunctionState();
}

class _NavFunctionState extends State<NavFunction> {
  int _selectedIndex = 0;
  
  late final DictionaryViewModel _dictionaryViewModel;
  bool _isInitializing = true;
  String _userToken = ''; 

  @override
  void initState() {
    super.initState();
    AppRouter.navTabIndex.addListener(_syncTabFromRouter);
    _initializeApp();
  }

  void _syncTabFromRouter() {
    if (!mounted) return;
    final nextIndex = AppRouter.navTabIndex.value;
    if (nextIndex != _selectedIndex) {
      setState(() {
        _selectedIndex = nextIndex;
      });
    }
  }

  @override
  void dispose() {
    AppRouter.navTabIndex.removeListener(_syncTabFromRouter);
    super.dispose();
  }

  Future<void> _initializeApp() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? ''; 
    _userToken = token;

    // 1. UPDATED TO LOCALHOST (For USB Tunnel)
    final repository = DictionaryRepository(
      baseUrl: ApiConstants.dictionary,
      authToken: token, 
    );
    
    _dictionaryViewModel = DictionaryViewModel(repository);

    if (mounted) {
      setState(() {
        _isInitializing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFFFB800)),
        ),
      );
    }

    return Scaffold(
      // 2. THE FIX: Using a Stack instead of just IndexedStack
      body: Stack(
        children: [
          Offstage(
            offstage: _selectedIndex == 1,
            child: IndexedStack(
              index: _selectedIndex > 1 ? _selectedIndex - 1 : _selectedIndex, 
              children: [
                 HomePage(
                   onProfileTap: () {
                     setState(() {
                       _selectedIndex = 3; 
                     });
                   },
                 ), 
                 // Note: Camera is NOT in this list!
                 DictionaryPage(viewModel: _dictionaryViewModel), 
                 const ProfilePage(), 
              ],
            ),
          ),
          
          if (_selectedIndex == 1)
            GestureWebviewScreen(userToken: _userToken),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          AppRouter.navTabIndex.value = index;
        },
      ),
    );
  }
}