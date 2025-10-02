import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/config/app_theme.dart';
import '../../domain/entities/movie.dart';
import '../../../../shared/widgets/movie_details_popup.dart';
import '../providers/movies_viewmodel.dart';

class PopularMoviesCarousel extends StatefulWidget {
  const PopularMoviesCarousel({super.key});

  @override
  State<PopularMoviesCarousel> createState() => _PopularMoviesCarouselState();
}

class _PopularMoviesCarouselState extends State<PopularMoviesCarousel> {
  late final PageController _pageController;
  Timer? _timer;
  int _currentPage = 5000;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.8,
      initialPage: _currentPage,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _startAutoPlay());
  }

  void _startAutoPlay() {
    final moviesViewModel = context.read<MoviesViewModel>();
    if (moviesViewModel.popularMovies.isNotEmpty) {
      _setupTimer();
    } else {
      moviesViewModel.addListener(_onMoviesLoaded);
    }
  }

  void _onMoviesLoaded() {
    final moviesViewModel = context.read<MoviesViewModel>();
    if (moviesViewModel.popularMovies.isNotEmpty) {
      _setupTimer();
      moviesViewModel.removeListener(_onMoviesLoaded);
    }
  }

  void _setupTimer() {
    final movieCount = context.read<MoviesViewModel>().popularMovies.take(10).length;
    if (movieCount < 2 || _timer?.isActive == true) return;

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      _currentPage++;

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    try {
      context.read<MoviesViewModel>().removeListener(_onMoviesLoaded);
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MoviesViewModel>(
      builder: (context, moviesViewModel, child) {
        final carouselMovies = moviesViewModel.popularMovies.take(10).toList();

        if (carouselMovies.isEmpty || moviesViewModel.searchQuery.isNotEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text('Tendencias',
                  style: TextStyle(
                      color: AppTheme.pureWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              height: 180.0,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  _currentPage = index;
                },
                itemBuilder: (context, index) {
                  final movieIndex = index % carouselMovies.length;
                  final movie = carouselMovies[movieIndex];

                  return AnimatedBuilder(
                    animation: _pageController,
                    builder: (context, child) {
                      double value = 1.0;
                      if (_pageController.position.haveDimensions) {
                        value = (_pageController.page ?? 0) - index;
                        value = (1 - (value.abs() * 0.15)).clamp(0.85, 1.0);
                      }
                      return Center(
                        child: SizedBox(
                          height: Curves.easeOut.transform(value) * 180,
                          child: child,
                        ),
                      );
                    },
                    child: _CarouselCard(movie: movie),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CarouselCard extends StatelessWidget {
  final Movie movie;
  const _CarouselCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return MovieDetailsPopup(movie: movie);
          },
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
          child: Stack(
            children: <Widget>[
              CachedNetworkImage(
                imageUrl: movie.fullBackdropUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                placeholder: (context, url) => Container(color: AppTheme.softCharcoal),
                errorWidget: (context, url, error) => const Icon(Icons.movie_creation_outlined),
              ),
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color.fromARGB(200, 0, 0, 0), Color.fromARGB(0, 0, 0, 0)],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: Text(
                    movie.title,
                    style: const TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}