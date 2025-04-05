import 'package:flutter/material.dart';
import '../model/home_model.dart';
import '../view_model/home_view_model.dart';
import 'detail_view.dart';
import 'favorites_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, required String token});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeViewModel _homeViewModel = HomeViewModel();
  List<HomeModel> movies = [];
  List<HomeModel> favoriteMovies = [];

  // Kategori başlıkları - daha az ve öz kategoriler
  final List<String> _categories = [
    "Trending Now",
    "Popular on Netflix",
    "New Releases",
    "My List",
    "Action Movies",
    "Comedies",
    "Dramas",
    "Horror Movies",
  ];

  @override
  void initState() {
    super.initState();
    _homeViewModel.fetchMovie().then((value) {
      if (value != null) {
        setState(() {
          movies = value;
        });
      } else {
        print("Error: No data found");
      }
    });
  }

  void _navigateToDetail(BuildContext context, HomeModel movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailView(
          movie: movie,
          allMovies: movies,
        ),
      ),
    );
  }

  void _navigateToFavorites(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FavoritesView(
          favoriteMovies: favoriteMovies,
          onRemoveFavorite: _toggleFavorite,
          onMovieTap: (context, movie) => _navigateToDetail(context, movie),
        ),
      ),
    );
  }

  void _toggleFavorite(HomeModel movie) {
    setState(() {
      if (favoriteMovies.contains(movie)) {
        favoriteMovies.remove(movie);
      } else {
        favoriteMovies.add(movie);
      }
    });
  }

  bool _isFavorite(HomeModel movie) {
    return favoriteMovies.contains(movie);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  // Netflix tarzı özel AppBar
  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.7),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Sağ taraftaki menü butonları
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.favorite, color: Color(0xFFE50914)),
                onPressed: () => _navigateToFavorites(context),
              ),
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.notifications_none, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.account_circle, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Netflix tarzı film listesi
  Widget _buildBody() {
    if (movies.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFFE50914),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.only(top: 16),
      children: [
        // Öne çıkan film (Featured)
        _buildFeaturedMovie(movies.first),
        
        // Kategoriler
        ..._categories.map((category) => _buildCategorySection(category, movies)).toList(),
      ],
    );
  }

  // Öne çıkan film (Featured)
  Widget _buildFeaturedMovie(HomeModel movie) {
    return GestureDetector(
      onTap: () => _navigateToDetail(context, movie),
      child: Container(
        height: 500,
        margin: const EdgeInsets.only(bottom: 24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Film posteri
            Image.network(
              movie.poster!.replaceFirst("http://", "https://"),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[800],
                  child: const Center(
                    child: Icon(Icons.broken_image, size: 50, color: Colors.white54),
                  ),
                );
              },
            ),
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.5),
                    Colors.black.withOpacity(0.8),
                    Colors.black,
                  ],
                  stops: const [0.0, 0.5, 0.8, 1.0],
                ),
              ),
            ),
            // Film bilgileri
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    _isFavorite(movie) ? Icons.favorite : Icons.favorite_border,
                    color: const Color(0xFFE50914),
                  ),
                  onPressed: () => _toggleFavorite(movie),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Film başlığı
                    Text(
                      movie.title ?? "Unknown Title",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Film detayları
                    if (movie.plot != null && movie.plot!.isNotEmpty)
                      Text(
                        movie.plot!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 20),
                    // Butonlar
                    Row(
                      children: [
                        _buildActionButton(Icons.add, "My List"),
                        const SizedBox(width: 24),
                        _buildActionButton(Icons.thumb_up, "Rate"),
                        const SizedBox(width: 24),
                        _buildActionButton(Icons.share, "Share"),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // İzleme butonu
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        onPressed: () => _navigateToDetail(context, movie),
                        icon: const Icon(Icons.play_arrow, size: 28),
                        label: const Text(
                          "Play",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Kategori bölümü
  Widget _buildCategorySection(String category, List<HomeModel> movies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Kategori başlığı
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            category,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
        // Film listesi
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return _buildMovieThumbnail(movies[index]);
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // Film küçük resmi
  Widget _buildMovieThumbnail(HomeModel movie) {
    return GestureDetector(
      onTap: () => _navigateToDetail(context, movie),
      child: Container(
        width: 160,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Film posteri
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      movie.poster!.replaceFirst("http://", "https://"),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[800],
                          child: const Center(
                            child: Icon(Icons.broken_image, size: 30, color: Colors.white54),
                          ),
                        );
                      },
                    ),
                    // Hover efekti
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _navigateToDetail(context, movie),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0),
                                Colors.black.withOpacity(0.2),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                            _isFavorite(movie) ? Icons.favorite : Icons.favorite_border,
                            color: const Color(0xFFE50914),
                            size: 20,
                          ),
                          onPressed: () => _toggleFavorite(movie),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
            // Film başlığı
            Text(
              movie.title ?? "Unknown Title",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            // Film detayları
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 12),
                const SizedBox(width: 4),
                Text(
                  movie.imdbRating ?? "N/A",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Aksiyon butonu
  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}