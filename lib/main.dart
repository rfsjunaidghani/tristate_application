import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'screens/dashboard.dart';
import 'screens/create_invoice.dart';
import 'screens/invoice.dart';
import 'screens/profile.dart';
import 'screens/login.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TriState',
      debugShowCheckedModeBanner: false,
      // Theme Configuration:
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF5F7FA), // AppBar ka background bhi same ho jayega
          elevation: 0,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

// Hum StatefulWidget use kar rahe hain kyun ke tabs click hone par screen change hogi
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  
  // current tab index
  int _selectedIndex = 0;

  // when click on tab update index function
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Is se screen reload ho kar nayi selected screen dikhayegi
    });
  }

  final List<String> _titles = [
    'Dashboard',
    'Create Daily Invoice',
    'My Invoices',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    // Build screens here so each one receives the tab-switch callback.
    final List<Widget> screens = [
      Dashboard(onNavigate: _onItemTapped),
      CreateInvoice(onNavigate: _onItemTapped),
      Invoice(onNavigate: _onItemTapped),
      Profile(onNavigate: _onItemTapped),
    ];
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F7FA),
        elevation: 0, 
        scrolledUnderElevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Color(0x1F000000), // (divider)
            height: 1.0,
          ),
        ),
        
        // Show title according to selected tab 
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            _titles[_selectedIndex], 
            style: const TextStyle(
              color: Color(0xFF0b1f3a), 
              fontSize: 20,             
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        // Avatar 
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xffbdbdbd), // Grey circle background
              child: const Text(
                'J',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
      
      // show tab screen show
      body: screens[_selectedIndex],

      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        height: 60.0,
        color: const Color(0xFF3B82F6),
        buttonBackgroundColor: const Color(0xFF3B82F6),
        backgroundColor: const Color(0xFFF5F7FA),
        // backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 400),
        onTap: _onItemTapped,
        items: const [
          Icon(Icons.home_outlined, size: 30, color: Colors.white),
          Icon(Icons.add_circle_outline_rounded, size: 30, color: Colors.white),
          Icon(Icons.receipt_long_rounded, size: 30, color: Colors.white),
          Icon(Icons.account_circle_outlined, size: 30, color: Colors.white),
        ],
      ),
    );
  }
}
