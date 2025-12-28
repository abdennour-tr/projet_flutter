import 'package:flutter/material.dart';
import 'package:projet_flutter/providers/cities_provider.dart';
import 'package:projet_flutter/providers/favorites_provider.dart';
import 'package:provider/provider.dart';

import '../providers/location_provider.dart';
import '../services/location_service.dart';

import '../widgets/home/home_hero.dart';
import '../widgets/home/home_top_destinations.dart';
import '../widgets/home/home_categories.dart';
import '../widgets/home/home_inspiration.dart';
import '../widgets/home/build_drawer.dart';
import '../widgets/home/search_results.dart';

import '../views/map_page.dart';
import '../views/search_page.dart';
import '../views/favorite_page.dart';
import '../views/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _askForLocation();

      final citiesProvider = context.read<CitiesProvider>();
      final favoritesProvider = context.read<FavoritesProvider>();

      await citiesProvider.loadCities();
      await favoritesProvider.loadFavorites(citiesProvider.cities);
    });
  }

  // ================= LOCATION =================
  Future<void> _askForLocation() async {
    final locationProvider = context.read<LocationProvider>();

    if (locationProvider.userPosition != null) return;

    final position = await LocationService.getCurrentPosition();

    if (!mounted) return;

    if (position != null) {
      locationProvider.setPosition(position);
    } else {
      _showLocationDialog();
    }
  }

  void _showLocationDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Autorisation de localisation"),
        content: const Text(
          "Pour calculer les distances et itinéraires, "
          "l’application a besoin de votre position.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Plus tard"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _askForLocation();
            },
            child: const Text("Autoriser"),
          ),
        ],
      ),
    );
  }

  // ================= BUILD =================
  @override
  Widget build(BuildContext context) {
    final pages = [
      _HomeContent(
        searchQuery: _searchQuery,
        onSearchChanged: (value) {
          setState(() => _searchQuery = value);
        },
      ),
      const MapPage(),
      const SearchPage(),
      const FavoritePage(),
      const SettingsPage(),
    ];

    return Scaffold(
      appBar: _buildAppBar(context),
      drawer: buildDrawer(context),
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: _bottomNav(
        context,
        _currentIndex,
        (index) => setState(() => _currentIndex = index),
      ),
    );
  }

  // ================= APP BAR =================
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: const Text(
        "Travel Guide Maroc",
        style: TextStyle(
          fontWeight: FontWeight.w800,
          color: Color(0xFF1F2937),
        ),
      ),
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF1B5E20)),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
    );
  }

  // ================= BOTTOM NAV =================
  Widget _bottomNav(
    BuildContext context,
    int currentIndex,
    ValueChanged<int> onTap,
  ) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1B5E20),
            Color(0xFF2E7D32),
            Color(0xFF4CAF50),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          _navItem(Icons.home, currentIndex == 0),
          _navItem(Icons.map, currentIndex == 1),
          _navItem(Icons.search, currentIndex == 2),
          _navItem(Icons.favorite_border, currentIndex == 3),
          _navItem(Icons.settings, currentIndex == 4),
        ],
      ),
    );
  }

  BottomNavigationBarItem _navItem(
    IconData icon,
    bool isActive,
  ) {
    return BottomNavigationBarItem(
      label: '',
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isActive ? Colors.white.withOpacity(0.25) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(icon, size: isActive ? 26 : 24),
      ),
    );
  }
}

// ================= HOME CONTENT =================
class _HomeContent extends StatelessWidget {
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;

  const _HomeContent({
    required this.searchQuery,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSearching = searchQuery.isNotEmpty;
    final userPosition = context.watch<LocationProvider>().userPosition;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HomeHero(),
          const SizedBox(height: 24),
          HomeSearch(onChanged: onSearchChanged),
          const SizedBox(height: 32),
          if (!isSearching) ...[
            const HomeTopDestinations(),
            const SizedBox(height: 32),
            const HomeCategories(),
            const SizedBox(height: 32),
            if (userPosition != null)
              HomeInspiration()
            else
              const Center(
                child: Text(
                  "📍 Localisation requise pour suggestions proches",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
          ] else ...[
            SearchResults(query: searchQuery),
          ],
        ],
      ),
    );
  }
}

// ================= SEARCH INPUT =================
class HomeSearch extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const HomeSearch({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: "Rechercher une destination...",
        prefixIcon: const Icon(Icons.search, color: Color(0xFF1B5E20)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
