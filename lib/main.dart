import 'package:flutter/material.dart';
import 'package:projet_flutter/providers/auth_provider.dart';
import 'package:projet_flutter/providers/categories_provider.dart';
import 'package:projet_flutter/providers/cities_provider.dart';
import 'package:projet_flutter/views/login_page.dart';
import 'package:provider/provider.dart';
import 'views/home_page.dart';
import 'providers/favorites_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/location_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => CitiesProvider()),
        ChangeNotifierProvider(create: (_) => CategoriesProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const TravelGuideApp(),
    ),
  );
}

class TravelGuideApp extends StatelessWidget {
  const TravelGuideApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Travel Guide Maroc',
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: Consumer<AuthProvider>(
        builder: (_, auth, __) {
          return auth.isLoggedIn ? const HomePage() : LoginPage();
        },
      ),
    );
  }
}
