class Settings {
  static late String apiUrl;

  static void init() {
    apiUrl = const String.fromEnvironment("API_URL");
  }
}
