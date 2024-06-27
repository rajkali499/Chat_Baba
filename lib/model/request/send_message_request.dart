/// content : "qqqq"
/// chat_id : "d8145ea3-1190-4328-805b-29a6569581e0"
library;

class SendMessageRequest {
  SendMessageRequest({
    String? content,
    String? chatId,
  }) {
    _content = content;
    _chatId = chatId;
  }

  SendMessageRequest.fromJson(dynamic json) {
    _content = json['content'];
    _chatId = json['chat_id'];
  }

  String? _content;
  String? _chatId;

  SendMessageRequest copyWith({
    String? content,
    String? chatId,
  }) =>
      SendMessageRequest(
        content: content ?? _content,
        chatId: chatId ?? _chatId,
      );

  String? get content => _content;

  String? get chatId => _chatId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['content'] = _content;
    map['chat_id'] = _chatId;
    return map;
  }
}
