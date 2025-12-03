import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  final Function(int)? onNavigateToTab;

  const HomeScreen({super.key, this.onNavigateToTab});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userName = authProvider.userEmail?.split('@')[0] ?? 'Traveler';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeSection(userName),
              const SizedBox(height: 24),
              _buildQuickActionCards(context),
              const SizedBox(height: 32),
              _buildPopularDestinations(context),
              const SizedBox(height: 32),
              _buildRecentlyViewed(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // welcome banner
  Widget _buildWelcomeSection(String userName) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryOrange.withOpacity(0.1),
            AppColors.secondaryOrange.withOpacity(0.05),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome, $userName!',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGrey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Where to next? ✈️',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.mediumGrey,
            ),
          ),
        ],
      ),
    );
  }

  // flight & hotel search cards
  Widget _buildQuickActionCards(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _buildActionCard(
              context: context,
              title: 'Flight\nSearch',
              icon: Icons.flight_takeoff,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primaryOrange, AppColors.secondaryOrange],
              ),
              onTap: () => onNavigateToTab?.call(0),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildActionCard(
              context: context,
              title: 'Hotel\nSearch',
              icon: Icons.hotel,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.accentOrange,
                  AppColors.secondaryOrange.withOpacity(0.8),
                ],
              ),
              onTap: () => onNavigateToTab?.call(1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryOrange.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: AppColors.white,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // popular destinations carousel
  Widget _buildPopularDestinations(BuildContext context) {
    final destinations = [
      {'name': 'Tokyo', 'country': 'Japan', 'image': 'tokyo.jpg'},
      {'name': 'Paris', 'country': 'France', 'image': 'paris.jpg'},
      {'name': 'New York', 'country': 'USA', 'image': 'new_york.jpg'},
      {'name': 'London', 'country': 'UK', 'image': 'london.jpg'},
      {'name': 'Sydney', 'country': 'Australia', 'image': 'sydney.jpg'},
      {'name': 'Shanghai', 'country': 'China', 'image': 'shanghai.jpg'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Popular Destinations',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGrey,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: destinations.length,
            itemBuilder: (context, index) {
              final destination = destinations[index];
              return Padding(
                padding: EdgeInsets.only(
                  right: index < destinations.length - 1 ? 12 : 0,
                ),
                child: _buildDestinationCard(
                  context: context,
                  name: destination['name']!,
                  country: destination['country']!,
                  image: destination['image']!,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // destination card thumbnails
  Widget _buildDestinationCard({
    required BuildContext context,
    required String name,
    required String country,
    required String image,
  }) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Search hotels in $name')),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: AssetImage('assets/images/destinations/$image'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.15),
              BlendMode.darken,
            ),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.5),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                country,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // recently viewed items
  Widget _buildRecentlyViewed(BuildContext context) {
    final hasRecentItems = false;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recently Viewed',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGrey,
            ),
          ),
          const SizedBox(height: 16),
          if (!hasRecentItems)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.lightGrey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.lightGrey,
                  width: 1,
                ),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.history,
                    size: 48,
                    color: AppColors.mediumGrey,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'No recent views yet',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.mediumGrey,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Start searching for flights and hotels!',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.mediumGrey,
                    ),
                  ),
                ],
              ),
            )
          else
            const SizedBox.shrink(),
        ],
      ),
    );
  }
}
