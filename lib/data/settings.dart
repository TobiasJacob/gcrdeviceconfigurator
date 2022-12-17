class Settings {
  String languageCode;
  String countryCode;

  Settings(this.languageCode, this.countryCode);

  static Settings defaultSettings() {
    return Settings("en", "EN");
  }

  static Settings fromJSON(Map<String, dynamic> settingsData) {
    String languageCode = settingsData["languageCode"] ?? "DE";
    String countryCode = settingsData["countryCode"] ?? "EN";
    return Settings(languageCode, countryCode);
  }

  Map<String, dynamic> toJSON() {
    return {"languageCode": languageCode, "countryCode": countryCode};
  }
}
