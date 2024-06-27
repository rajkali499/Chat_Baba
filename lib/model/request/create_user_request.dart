/// name : "string"
/// image_url : "string"
/// mobile : "string"
/// email : "string"
/// password : "string"
library;

class CreateUserRequest {
  CreateUserRequest({
    String? name,
    String? imageUrl,
    String? mobile,
    String? email,
    String? password,
  }) {
    _name = name;
    _imageUrl = imageUrl;
    _mobile = mobile;
    _email = email;
    _password = password;
  }

  CreateUserRequest.fromJson(dynamic json) {
    _name = json['name'];
    _imageUrl = json['image_url'];
    _mobile = json['mobile'];
    _email = json['email'];
    _password = json['password'];
  }

  String? _name;
  String? _imageUrl;
  String? _mobile;
  String? _email;
  String? _password;

  CreateUserRequest copyWith({
    String? name,
    String? imageUrl,
    String? mobile,
    String? email,
    String? password,
  }) =>
      CreateUserRequest(
        name: name ?? _name,
        imageUrl: imageUrl ?? _imageUrl,
        mobile: mobile ?? _mobile,
        email: email ?? _email,
        password: password ?? _password,
      );

  String? get name => _name;

  String? get imageUrl => _imageUrl;

  String? get mobile => _mobile;

  String? get email => _email;

  String? get password => _password;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['image_url'] = _imageUrl;
    map['mobile'] = _mobile;
    map['email'] = _email;
    map['password'] = _password;
    return map;
  }
}
