import 'package:flutter/material.dart';
import 'package:projet_flutter/models/city_model.dart';
import 'package:projet_flutter/views/category_page.dart';

class HomeCategories extends StatelessWidget {
  const HomeCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      _Category("Beach", Icons.beach_access, "assets/categories/beach.jpg",
          PlaceCategory.beach),
      _Category("Mountain", Icons.terrain, "assets/categories/mountain.webp",
          PlaceCategory.mountain),
      _Category("City", Icons.location_city, "assets/cities/chefchaouen2.jpg",
          PlaceCategory.city),
      _Category("Nature", Icons.park, "assets/categories/nature.jpg",
          PlaceCategory.nature),
      _Category("Monument", Icons.account_balance,
          "assets/categories/monument.png", PlaceCategory.monument),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔹 Title
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            _Title("Categories"),
          ],
        ),

        const SizedBox(height: 16),

        // 🔹 Category Cards
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CategoryPage(
                        category: categories[index].category,
                        title: categories[index].title,
                      ),
                    ),
                  );
                },
                child: _CategoryCard(category: categories[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _Category {
  final String title;
  final IconData icon;
  final String image;
  final PlaceCategory category;

  _Category(this.title, this.icon, this.image, this.category);
}

class _CategoryCard extends StatelessWidget {
  final _Category category;

  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // 🖼 Background Image
            Positioned.fill(
              child: Image.asset(
                category.image,
                fit: BoxFit.cover,
              ),
            ),

            // 🌈 Gradient overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.6),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),

            // 🟢 Icon
            Positioned(
              top: 14,
              left: 14,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  category.icon,
                  size: 18,
                  color: const Color(0xFF1B5E20),
                ),
              ),
            ),

            // 📝 Title
            Positioned(
              left: 14,
              bottom: 14,
              child: Text(
                category.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String text;
  const _Title(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}
