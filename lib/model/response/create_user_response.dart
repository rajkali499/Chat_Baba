/// access_token : "token"
/// refresh_token : "token"
library;

class CreateUserResponse {
  CreateUserResponse({
    String? accessToken,
    String? refreshToken,
  }) {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
  }

  CreateUserResponse.fromJson(dynamic json) {
    _accessToken = json['access_token'];
    _refreshToken = json['refresh_token'];
  }

  String? _accessToken;
  String? _refreshToken;

  CreateUserResponse copyWith({
    String? accessToken,
    String? refreshToken,
  }) =>
      CreateUserResponse(
        accessToken: accessToken ?? _accessToken,
        refreshToken: refreshToken ?? _refreshToken,
      );

  String? get accessToken => _accessToken;

  String? get refreshToken => _refreshToken;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['access_token'] = _accessToken;
    map['refresh_token'] = _refreshToken;
    return map;
  }
}
