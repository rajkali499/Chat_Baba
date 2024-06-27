/// name : "test"
/// image_url : ""
/// mobile : ""
/// email : "test@gmail.com"
/// id : "516f352e-47a4-447c-8b68-d829d4a32856"
/// created_at : "2024-06-14T15:25:25.672478"
/// updated_at : "2024-06-14T15:25:25.672478"
library;

class AppUserResponse {
  AppUserResponse({
    String? name,
    String? imageUrl,
    String? mobile,
    String? email,
    String? id,
    String? createdAt,
    String? updatedAt,
  }) {
    _name = name;
    _imageUrl = imageUrl;
    _mobile = mobile;
    _email = email;
    _id = id;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  AppUserResponse.fromJson(dynamic json) {
    _name = json['name'];
    _imageUrl = json['image_url'];
    _mobile = json['mobile'];
    _email = json['email'];
    _id = json['id'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  String? _name;
  String? _imageUrl;
  String? _mobile;
  String? _email;
  String? _id;
  String? _createdAt;
  String? _updatedAt;

  AppUserResponse copyWith({
    String? name,
    String? imageUrl,
    String? mobile,
    String? email,
    String? id,
    String? createdAt,
    String? updatedAt,
  }) =>
      AppUserResponse(
        name: name ?? _name,
        imageUrl: imageUrl ?? _imageUrl,
        mobile: mobile ?? _mobile,
        email: email ?? _email,
        id: id ?? _id,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );

  String? get name => _name;

  String? get imageUrl => _imageUrl;

  String? get mobile => _mobile;

  String? get email => _email;

  String? get id => _id;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['image_url'] = _imageUrl;
    map['mobile'] = _mobile;
    map['email'] = _email;
    map['id'] = _id;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }
}
