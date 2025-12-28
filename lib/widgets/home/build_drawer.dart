import 'package:flutter/material.dart';
import 'package:projet_flutter/views/about_page.dart';
import 'package:projet_flutter/views/home_page.dart';
import 'package:projet_flutter/views/search_page.dart';
import 'package:projet_flutter/views/settings_page.dart';
import '../../views/map_page.dart';
import '../../views/favorite_page.dart';

Drawer buildDrawer(BuildContext context) {
  return Drawer(
    backgroundColor: Colors.white,
    child: Column(
      children: [
        // ================= HEADER =================
        Container(
          height: 220,
          padding: const EdgeInsets.all(20),
          alignment: Alignment.bottomLeft,
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage("assets/places/marakech.webp"),
              fit: BoxFit.cover,
            ),
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.75),
                Colors.black.withOpacity(0.3),
                Colors.transparent,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Text(
                "Travel Guide Maroc",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 6),
              Text(
                "Explore • Discover • Travel",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // ================= MENU =================
        _DrawerItem(
          icon: Icons.home_rounded,
          title: "Home",
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          },
        ),

        _DrawerItem(
          icon: Icons.map_rounded,
          title: "Map",
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MapPage()),
            );
          },
        ),

        _DrawerItem(
          icon: Icons.favorite_rounded,
          title: "Favorites",
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FavoritePage()),
            );
          },
        ),

        _DrawerItem(
          icon: Icons.search,
          title: "Destinations",
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SearchPage()),
            );
          },
        ),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Divider(),
        ),

        _DrawerItem(
          icon: Icons.settings_rounded,
          title: "Settings",
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsPage()),
            );
          },
        ),

        _DrawerItem(
          icon: Icons.info_outline_rounded,
          title: "About",
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AboutPage()),
            );
          },
        ),

        const Spacer(),

        // ================= FOOTER =================
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            children: const [
              Text(
                "Version 1.0.0",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 6),
              Text(
                "© 2025 Travel Guide Maroc",
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// ================= DRAWER ITEM =================

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF1B5E20).withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 20,
            color: const Color(0xFF1B5E20),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 14,
          color: Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }
}
