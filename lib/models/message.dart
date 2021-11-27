class Message {
  Message({required this.message, this.response = ""});

  final String message;
  String response;

  Map<String, String> toSaveData() {
    return {
      "message": message,
      "response": response,
    };
  }

  factory Message.fromSaveData(Map<String, String> data) {
    return Message(message: data["message"]!, response: data["response"] ?? "");
  }
}
