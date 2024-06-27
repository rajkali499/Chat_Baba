/// name : "string"
/// is_group_chat : false
/// participant_ids : ["string"]
/// image_url : "string"
library;

class CreateChatRequest {
  CreateChatRequest({
    String? name,
    bool? isGroupChat,
    List<String>? participantIds,
    String? imageUrl,
  }) {
    _name = name;
    _isGroupChat = isGroupChat;
    _participantIds = participantIds;
    _imageUrl = imageUrl;
  }

  CreateChatRequest.fromJson(dynamic json) {
    _name = json['name'];
    _isGroupChat = json['is_group_chat'];
    _participantIds = json['participant_ids'] != null
        ? json['participant_ids'].cast<String>()
        : [];
    _imageUrl = json['image_url'];
  }

  String? _name;
  bool? _isGroupChat;
  List<String>? _participantIds;
  String? _imageUrl;

  CreateChatRequest copyWith({
    String? name,
    bool? isGroupChat,
    List<String>? participantIds,
    String? imageUrl,
  }) =>
      CreateChatRequest(
        name: name ?? _name,
        isGroupChat: isGroupChat ?? _isGroupChat,
        participantIds: participantIds ?? _participantIds,
        imageUrl: imageUrl ?? _imageUrl,
      );

  String? get name => _name;

  bool? get isGroupChat => _isGroupChat;

  List<String>? get participantIds => _participantIds;

  String? get imageUrl => _imageUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['is_group_chat'] = _isGroupChat;
    map['participant_ids'] = _participantIds;
    map['image_url'] = _imageUrl;
    return map;
  }
}
