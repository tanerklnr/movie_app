import 'package:flutter/material.dart';
import '../model/home_model.dart';
import 'dart:math';

class DetailView extends StatelessWidget {
  final HomeModel movie;
  final List<HomeModel> allMovies; // Tüm filmlerin listesi

  const DetailView({
    super.key, 
    required this.movie,
    required this.allMovies, // Tüm filmlerin listesini parametre olarak al
  });

  @override
  Widget build(BuildContext context) {
    // Mevcut filmi hariç tutarak benzer filmleri seç
    final similarMovies = _getSimilarMovies();
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Film posteri ve başlık bölümü
          Stack(
            children: [
              // Film posteri - boyutu artırıldı
              Container(
                height: MediaQuery.of(context).size.height * 0.7, // Yükseklik artırıldı
                width: double.infinity,
                child: Image.network(
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
              ),
              // Gradient overlay - yükseklik film posteriyle aynı
              Container(
                height: MediaQuery.of(context).size.height * 0.7, // Yükseklik artırıldı
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.5),
                      Colors.black.withOpacity(0.7),
                      Colors.black,
                    ],
                    stops: const [0.0, 0.5, 0.8, 1.0],
                  ),
                ),
              ),
              // Geri butonu ve menü
              Positioned(
                top: MediaQuery.of(context).padding.top,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Geri butonu
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      // Menü butonları
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.favorite_border, color: Colors.white),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.share, color: Colors.white),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Film başlığı ve detayları
              Positioned(
                bottom: 20,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title ?? "Unknown Title",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Film detayları
                    Row(
                      children: [
                        _buildInfoItem(Icons.calendar_today, movie.year ?? "N/A"),
                        const SizedBox(width: 16),
                        _buildInfoItem(Icons.access_time, movie.runtime ?? "N/A"),
                        const SizedBox(width: 16),
                        _buildInfoItem(Icons.star, movie.imdbRating ?? "N/A"),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Aksiyon butonları
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE50914),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            onPressed: () {},
                            icon: const Icon(Icons.play_arrow, size: 24),
                            label: const Text(
                              "Play",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Film içeriği
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                // Film açıklaması
                if (movie.plot != null && movie.plot!.isNotEmpty)
                  Text(
                    movie.plot!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                const SizedBox(height: 20),
                // Film türü
                if (movie.genre != null)
                  Text(
                    "Genre: ${movie.genre}",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                // Yönetmen
                if (movie.director != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      "Director: ${movie.director}",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ),
                // Oyuncular
                if (movie.actors != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      "Cast: ${movie.actors}",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                // Benzer içerikler başlığı
                const Text(
                  "More Like This",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                // Benzer içerikler için yatay kaydırılabilir liste
                SizedBox(
                  height: 200, // Benzer içerikler için yükseklik
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: similarMovies.length,
                    itemBuilder: (context, index) {
                      final similarMovie = similarMovies[index];
                      return GestureDetector(
                        onTap: () {
                          // Benzer filme tıklandığında detay sayfasına git
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailView(
                                movie: similarMovie,
                                allMovies: allMovies,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 120, // Benzer içerik genişliği
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[800],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              similarMovie.poster!.replaceFirst("http://", "https://"),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(Icons.broken_image, color: Colors.white54),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Benzer filmleri seçen yardımcı metot
  List<HomeModel> _getSimilarMovies() {
    // Mevcut filmi hariç tut
    final filteredMovies = allMovies.where((m) => m != movie).toList();
    
    // Eğer yeterli film yoksa boş liste döndür
    if (filteredMovies.isEmpty) return [];
    
    // Rastgele 5 film seç (veya mevcut film sayısı kadar)
    final random = Random();
    final count = min(5, filteredMovies.length);
    final similarMovies = <HomeModel>[];
    
    // Rastgele filmleri seç
    for (int i = 0; i < count; i++) {
      final index = random.nextInt(filteredMovies.length);
      similarMovies.add(filteredMovies[index]);
      filteredMovies.removeAt(index); // Seçilen filmi listeden çıkar
    }
    
    return similarMovies;
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
} 