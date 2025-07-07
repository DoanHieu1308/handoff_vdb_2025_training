import 'package:shared_preferences/shared_preferences.dart';

import 'constants/preferences.dart';

class SharedPreferenceHelper {
  final SharedPreferences _sharedPreference;

  SharedPreferenceHelper(this._sharedPreference);

  // General Methods: Access token
  String? get getJwtToken => _sharedPreference.getString(Preferences.jwtToken);

  Future<void> setJwtToken(String authToken) async {
    await _sharedPreference.setString(Preferences.jwtToken, authToken);
  }

}