import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/cities_service.dart';
import '../../providers/favorites_provider.dart';
import '../../models/city_model.dart';
import '../../views/place_details_page.dart';

class HomeTopDestinations extends StatefulWidget {
  const HomeTopDestinations({super.key});

  @override
  State<HomeTopDestinations> createState() => _HomeTopDestinationsState();
}

class _HomeTopDestinationsState extends State<HomeTopDestinations> {
  List<Place> cities = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCities();
  }

  Future<void> _loadCities() async {
    final allCities = await CitiesService.loadCities();
    setState(() {
      cities = allCities.take(10).toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔹 Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            _Title("Top Destinations"),
          ],
        ),

        const SizedBox(height: 16),

        if (isLoading)
          const SizedBox(
            height: 260,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        else
          SizedBox(
            height: 260,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(right: 8),
              itemCount: cities.length,
              separatorBuilder: (_, __) => const SizedBox(width: 18),
              itemBuilder: (context, index) {
                final city = cities[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PlaceDetailsPage(place: city),
                      ),
                    );
                  },
                  child: _DestinationCard(city: city),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _DestinationCard extends StatelessWidget {
  final Place city;

  const _DestinationCard({required this.city});

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = context.watch<FavoritesProvider>();
    final isFavorite = favoritesProvider.isFavorite(city);

    return Container(
      width: 190,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Stack(
          children: [
            // 🖼 Image
            Positioned.fill(
              child: Image.asset(
                city.images.first,
                fit: BoxFit.cover,
              ),
            ),

            // 🌑 Gradient overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),

            // ❤️ Favorite
            Positioned(
              top: 14,
              right: 14,
              child: GestureDetector(
                onTap: () {
                  favoritesProvider.toggleFavorite(city);
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    size: 18,
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ),

            // ⭐ Rating
            Positioned(
              top: 14,
              left: 14,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      city.rating.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 📍 City name
            Positioned(
              left: 18,
              bottom: 18,
              child: Text(
                city.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
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
