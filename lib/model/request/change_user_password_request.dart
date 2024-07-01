/// old_password : "OLD_PASSWORD"
/// new_password : "NEW_PASSWORD"
library;

class ChangeUserPasswordRequest {
  ChangeUserPasswordRequest({
    String? oldPassword,
    String? newPassword,
  }) {
    _oldPassword = oldPassword;
    _newPassword = newPassword;
  }

  ChangeUserPasswordRequest.fromJson(dynamic json) {
    _oldPassword = json['old_password'];
    _newPassword = json['new_password'];
  }

  String? _oldPassword;
  String? _newPassword;

  ChangeUserPasswordRequest copyWith({
    String? oldPassword,
    String? newPassword,
  }) =>
      ChangeUserPasswordRequest(
        oldPassword: oldPassword ?? _oldPassword,
        newPassword: newPassword ?? _newPassword,
      );

  String? get oldPassword => _oldPassword;

  String? get newPassword => _newPassword;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['old_password'] = _oldPassword;
    map['new_password'] = _newPassword;
    return map;
  }
}
