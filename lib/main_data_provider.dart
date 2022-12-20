import 'dart:async';

import 'data/database.dart';
import 'i18n/language_settings.dart';

enum MainDataProviderState { loading, finished }

class MainDataProvider {
  late Database database;
  late LanguageSettings languageSettings;
  late Future loadFuture;
  late Timer updateAxisValues;
  late Function updateUserInterface;

  MainDataProviderState state = MainDataProviderState.loading;
  String errorMsg = "";

  MainDataProvider() {
    loadData();
  }

  Future<void> loadData() async {
    database = Database();
    await database.load();
    languageSettings = await LanguageSettings.load();

    updateAxisValues =
        Timer.periodic(const Duration(milliseconds: 100), (timer) {
      database.updateCurrentAxisValue();
    });
    state = MainDataProviderState.finished;
    updateUserInterface();
  }
}
