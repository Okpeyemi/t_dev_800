class Settings {
  static late String apiUrl;

  static void setUp() {
    apiUrl = const String.fromEnvironment("API_URL");
  }
}
