class RatedMovie {
  final int movieId;
  final double rating;

  const RatedMovie({required this.movieId, required this.rating});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is RatedMovie &&
              runtimeType == other.runtimeType &&
              movieId == other.movieId &&
              rating == other.rating;

  @override
  int get hashCode => movieId.hashCode ^ rating.hashCode;
}