class Config{
  static const String apiURL = '192.168.128.13:1802';
  static const String loginAPI = '/api/users/login';
  static const String registerAPI = '/api/users/person/register';
  static const String isValidTokenAPI = '/api/users/isValidToken';
  static const String getOffers = '/api/offers';
  static const String getOfferById = '/api/offers/getById';
  static const String getOfferByPriceRange = '/api/offers/getByPriceRange';
  static const String updateFavorite = '/api/favorites/updateFavorites';
  static const String getFavorites = '/api/favorites';
  static const String getMaxPriceAllOffers = 'api/offers/getMaxPriceAllOffers';
}