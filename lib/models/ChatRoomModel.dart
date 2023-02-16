class ChatRoomModel {
  String? chatroomid;
  Map<String, dynamic>? participants;
  String? lastMessage1;
  String? lastMessage2;
  String? lastMessageUid;


  ChatRoomModel({this.chatroomid, this.participants, this.lastMessage1,this.lastMessage2,this.lastMessageUid,});

  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    chatroomid = map["chatroomid"];
    participants = map["participants"];
    lastMessage1 = map["lastmessage1"];
    lastMessage2 = map["lastmessage2"];
    lastMessageUid = map["lastmessage"];

  }
  Map<String, dynamic> toMap() {
    return {
      "chatroomid": chatroomid,
      "participants": participants,
      "lastmessage1": lastMessage1,
      "lastmessage2": lastMessage2,
      "lastmessage" : lastMessageUid

    };
  }
}
