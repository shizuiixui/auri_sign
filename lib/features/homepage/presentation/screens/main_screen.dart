import 'package:flutter/material.dart';
import 'package:auri_sign/core/widgets/bottom_nav_bar.dart';
import 'package:auri_sign/features/profile/presentation/screens/profile.dart';
import 'package:auri_sign/features/homepage/presentation/screens/homepage.dart';
import 'package:auri_sign/features/dictionary/presentation/screens/dictionary.dart';
import 'package:auri_sign/features/dictionary/data/repositories/dictionary_repository.dart';
import 'package:auri_sign/features/dictionary/presentation/viewmodels/dictionary_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavFunction extends StatefulWidget {
  const NavFunction({super.key});

  @override
  State<NavFunction> createState() => _NavFunctionState();
}
class _NavFunctionState extends State<NavFunction> {
  int _selectedIndex = 0;
  
  late final DictionaryViewModel _dictionaryViewModel;
  bool _isInitializing = true; 

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // 1. Get the token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? ''; 

    final repository = DictionaryRepository(
      baseUrl: 'http://192.168.100.10:5000/api/dictionary', // change with your laptop IP
      authToken: token, 
    );
    
    _dictionaryViewModel = DictionaryViewModel(repository);

    // 3. Tell the UI we are done loading
    setState(() {
      _isInitializing = false;
    });
  }

  List<Widget> get _pages => [
    HomePage(
      onProfileTap: () {
        setState(() {
          _selectedIndex = 3; 
        });
      },
    ), 
    const SizedBox.shrink(), 
    
    // We can now safely pass the ViewModel
    DictionaryPage(viewModel: _dictionaryViewModel), 
    
    const ProfilePage(), 
  ];

  @override
  Widget build(BuildContext context) {
    // Show a loading screen while we fetch the token from storage
    if (_isInitializing) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFFFB800)),
        ),
      );
    }

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushNamed(context, '/gesture_detection');
          } else {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
      ),
    );
  }
}