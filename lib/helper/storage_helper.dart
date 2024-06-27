//import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  SharedPreferences? storage;

  static const _postLastUpdate = "postLastUpdate";
  static const _accessToken = "accessToken";
  static const _userId = "userId";
  static const _loggedIn = "loggedIn";
  static const _refreshToken = "refreshToken";
  static const _challengeLastUpdate = "challengeLastUpdate";
  static const _customRewardsLastUpdate = "customRewardsLastUpdate";
  static const _productRewardsLastUpdate = "productsRewardsLastUpdate";
  static const _usersLastUpdate = "usersLastUpdate";
  static const _resourceLastUpdate = "resourceLastUpdate";
  static const _tagsLastUpdate = "tagsLastUpdate";
  static const learningLastUpdate = "learningLastUpdate";

  init() async {
    storage = storage ?? await SharedPreferences.getInstance();
  }

  setAccessToken(String token) async {
    await init();
    await storage!.setString(_accessToken, token);
  }

  Future<String> getAccessToken() async {
    await init();
    return storage!.getString(_accessToken) ?? "";
  }

  setUserId(String userId) async {
    await init();
    await storage!.setString(_userId, userId);
  }

  Future<String> getUserId() async {
    await init();
    return storage!.getString(_userId) ?? "";
  }

  setRefreshToken(String token) async {
    await init();
    await storage!.setString(_refreshToken, token);
  }

  Future<String> getRefreshTokenToken() async {
    await init();
    return storage!.getString(_refreshToken) ?? "";
  }

  savePostLastUpdate(int updateOn) async {
    await init();
    await storage!.setInt(_postLastUpdate, updateOn);
  }

  getPostLastUpdate() async {
    await init();
    return storage!.getInt(_postLastUpdate) ?? 0;
  }

  saveUsersLastUpdate(int updateOn) async {
    await init();
    storage!.setString(_usersLastUpdate, updateOn.toString());
  }

  Future<int> getUsersLastUpdate() async {
    await init();
    return int.parse((storage!.getString(_usersLastUpdate)) ?? "0");
  }

  saveResourcesLastUpdate(int updateOn) async {
    await init();
    storage!.setString(_resourceLastUpdate, updateOn.toString());
  }

  getResourcesLastUpdate() async {
    await init();
    return int.parse((storage!.getString(_resourceLastUpdate)) ?? "0");
  }

  saveTagsLastUpdate(int updateOn) async {
    await init();
    storage!.setString(_tagsLastUpdate, updateOn.toString());
  }

  getTagsLastUpdate() async {
    await init();
    return int.parse((storage!.getString(_tagsLastUpdate)) ?? "0");
  }

  saveChallengeLastUpdate(int updateOn) async {
    await init();
    storage!.setString(_challengeLastUpdate, updateOn.toString());
  }

  getChallengeLastUpdate() async {
    await init();
    return int.parse((storage!.getString(_challengeLastUpdate)) ?? "0");
  }

  saveLastUpdate(String tag, int updateOn) async {
    await init();
    storage!.setString(tag, updateOn.toString());
  }

  getLastUpdate(String tag) async {
    await init();
    return int.parse((storage!.getString(tag)) ?? "0");
  }

  saveCustomRewardsLastUpdate(int updateOn) async {
    await init();
    storage!.setString(_customRewardsLastUpdate, updateOn.toString());
  }

  getCustomRewardsLastUpdate() async {
    await init();
    return int.parse((storage!.getString(_customRewardsLastUpdate)) ?? "0");
  }

  saveProductRewardsLastUpdate(int updateOn) async {
    await init();
    storage!.setString(_productRewardsLastUpdate, updateOn.toString());
  }

  getProductRewardsLastUpdate() async {
    await init();
    return int.parse((storage!.getString(_productRewardsLastUpdate)) ?? "0");
  }

  setIsLoggedIn(bool logIn) async {
    await init();
    await storage?.setBool(_loggedIn, logIn);
  }

  getIsLoggedIn() async {
    await init();
    return storage?.getBool(_loggedIn) ?? false;
  }
}
