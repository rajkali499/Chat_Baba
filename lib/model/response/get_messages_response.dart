/// content : "Don't you have brain?"
/// chat_id : "f3933bce-c3e8-4754-b193-6c5956906f28"
/// id : "2e44f95e-b6fc-4cda-8358-11bc5abedf5a"
/// sender_id : "843b3387-fa56-410d-bc6b-1461273afce4"
/// created_at : "2024-06-19T06:39:05.401185"
/// updated_at : "2024-06-19T06:39:05.401185"
library;

class GetMessagesResponse {
  GetMessagesResponse({
    String? content,
    String? chatId,
    String? id,
    String? senderId,
    String? createdAt,
    String? updatedAt,
  }) {
    _content = content;
    _chatId = chatId;
    _id = id;
    _senderId = senderId;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  GetMessagesResponse.fromJson(dynamic json) {
    _content = json['content'];
    _chatId = json['chat_id'];
    _id = json['id'];
    _senderId = json['sender_id'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  String? _content;
  String? _chatId;
  String? _id;
  String? _senderId;
  String? _createdAt;
  String? _updatedAt;

  GetMessagesResponse copyWith({
    String? content,
    String? chatId,
    String? id,
    String? senderId,
    String? createdAt,
    String? updatedAt,
  }) =>
      GetMessagesResponse(
        content: content ?? _content,
        chatId: chatId ?? _chatId,
        id: id ?? _id,
        senderId: senderId ?? _senderId,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );

  String? get content => _content;

  String? get chatId => _chatId;

  String? get id => _id;

  String? get senderId => _senderId;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['content'] = _content;
    map['chat_id'] = _chatId;
    map['id'] = _id;
    map['sender_id'] = _senderId;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }
}
