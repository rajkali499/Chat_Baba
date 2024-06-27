/// is_group_chat : true
/// last_message_id : "abc4d096-2fdd-4431-b429-451ba790a9fa"
/// image_url : "string"
/// created_at : "2024-06-18T08:19:42.162710"
/// updated_at : "2024-06-18T14:55:58.097181"
/// name : "Group"
/// participant_ids : ["2b120f75-1ade-4702-8ce0-1473c76169c7","843b3387-fa56-410d-bc6b-1461273afce4"]
/// id : "f3933bce-c3e8-4754-b193-6c5956906f28"
/// last_message : {"content":"How are you","id":"abc4d096-2fdd-4431-b429-451ba790a9fa","updated_at":"2024-06-18T14:55:58.087663","sender_id":"2b120f75-1ade-4702-8ce0-1473c76169c7","chat_id":"f3933bce-c3e8-4754-b193-6c5956906f28","created_at":"2024-06-18T14:55:58.087663"}
library;

class GetChatsResponse {
  GetChatsResponse({
    bool? isGroupChat,
    String? lastMessageId,
    String? imageUrl,
    String? createdAt,
    String? updatedAt,
    String? name,
    List<String>? participantIds,
    String? id,
    LastMessage? lastMessage,
  }) {
    _isGroupChat = isGroupChat;
    _lastMessageId = lastMessageId;
    _imageUrl = imageUrl;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _name = name;
    _participantIds = participantIds;
    _id = id;
    _lastMessage = lastMessage;
  }

  GetChatsResponse.fromJson(dynamic json) {
    _isGroupChat = json['is_group_chat'];
    _lastMessageId = json['last_message_id'];
    _imageUrl = json['image_url'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _name = json['name'];
    _participantIds = json['participant_ids'] != null
        ? json['participant_ids'].cast<String>()
        : [];
    _id = json['id'];
    _lastMessage = json['last_message'] != null
        ? LastMessage.fromJson(json['last_message'])
        : null;
  }

  bool? _isGroupChat;
  String? _lastMessageId;
  String? _imageUrl;
  String? _createdAt;
  String? _updatedAt;
  String? _name;
  List<String>? _participantIds;
  String? _id;
  LastMessage? _lastMessage;

  GetChatsResponse copyWith({
    bool? isGroupChat,
    String? lastMessageId,
    String? imageUrl,
    String? createdAt,
    String? updatedAt,
    String? name,
    List<String>? participantIds,
    String? id,
    LastMessage? lastMessage,
  }) =>
      GetChatsResponse(
        isGroupChat: isGroupChat ?? _isGroupChat,
        lastMessageId: lastMessageId ?? _lastMessageId,
        imageUrl: imageUrl ?? _imageUrl,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        name: name ?? _name,
        participantIds: participantIds ?? _participantIds,
        id: id ?? _id,
        lastMessage: lastMessage ?? _lastMessage,
      );

  bool? get isGroupChat => _isGroupChat;

  String? get lastMessageId => _lastMessageId;

  String? get imageUrl => _imageUrl;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  String? get name => _name;

  List<String>? get participantIds => _participantIds;

  String? get id => _id;

  LastMessage? get lastMessage => _lastMessage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['is_group_chat'] = _isGroupChat;
    map['last_message_id'] = _lastMessageId;
    map['image_url'] = _imageUrl;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['name'] = _name;
    map['participant_ids'] = _participantIds;
    map['id'] = _id;
    if (_lastMessage != null) {
      map['last_message'] = _lastMessage?.toJson();
    }
    return map;
  }
}

/// content : "How are you"
/// id : "abc4d096-2fdd-4431-b429-451ba790a9fa"
/// updated_at : "2024-06-18T14:55:58.087663"
/// sender_id : "2b120f75-1ade-4702-8ce0-1473c76169c7"
/// chat_id : "f3933bce-c3e8-4754-b193-6c5956906f28"
/// created_at : "2024-06-18T14:55:58.087663"

class LastMessage {
  LastMessage({
    String? content,
    String? id,
    String? updatedAt,
    String? senderId,
    String? chatId,
    String? createdAt,
  }) {
    _content = content;
    _id = id;
    _updatedAt = updatedAt;
    _senderId = senderId;
    _chatId = chatId;
    _createdAt = createdAt;
  }

  LastMessage.fromJson(dynamic json) {
    _content = json['content'];
    _id = json['id'];
    _updatedAt = json['updated_at'];
    _senderId = json['sender_id'];
    _chatId = json['chat_id'];
    _createdAt = json['created_at'];
  }

  String? _content;
  String? _id;
  String? _updatedAt;
  String? _senderId;
  String? _chatId;
  String? _createdAt;

  LastMessage copyWith({
    String? content,
    String? id,
    String? updatedAt,
    String? senderId,
    String? chatId,
    String? createdAt,
  }) =>
      LastMessage(
        content: content ?? _content,
        id: id ?? _id,
        updatedAt: updatedAt ?? _updatedAt,
        senderId: senderId ?? _senderId,
        chatId: chatId ?? _chatId,
        createdAt: createdAt ?? _createdAt,
      );

  String? get content => _content;

  String? get id => _id;

  String? get updatedAt => _updatedAt;

  String? get senderId => _senderId;

  String? get chatId => _chatId;

  String? get createdAt => _createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['content'] = _content;
    map['id'] = _id;
    map['updated_at'] = _updatedAt;
    map['sender_id'] = _senderId;
    map['chat_id'] = _chatId;
    map['created_at'] = _createdAt;
    return map;
  }
}
