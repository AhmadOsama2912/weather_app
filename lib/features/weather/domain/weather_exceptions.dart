class CityNotFoundException implements Exception {
  final String message;
  const CityNotFoundException([this.message = 'City not found']);

  @override
  String toString() => message;
}
