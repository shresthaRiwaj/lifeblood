class ChatRoomModel {
  String? chatroomid;
  Map<String, dynamic>? participants;
  String? lastMessage;
  // DateTime? messageon;

  ChatRoomModel({
    this.chatroomid,
    this.participants,
    this.lastMessage,
  });

  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    chatroomid = map["chatroomid"];
    participants = map["participants"];
    lastMessage = map["lastMessage"];
    // messageon = map["messageon"].toDate();
  }

  Map<String, dynamic> toMap() {
    return {
      "chatroomid": chatroomid,
      "participants": participants,
      "lastMessage": lastMessage,
      // "messageon": messageon,
    };
  }
}
