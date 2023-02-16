class MessageModel {
  String? messageid;
  String? sender;
  String? text;
  String? trns_text;
  bool? seen;
  DateTime? createdon;

  MessageModel(
      {this.messageid,
      this.sender,
      this.text,
      this.trns_text,
      this.seen,
      this.createdon,
      });

  MessageModel.fromMap(Map<String, dynamic> map) {
    messageid = map["messageid"];
    sender = map["sender"];
    text = map["text"];
    trns_text = map["trns_text"];
    seen = map["seen"];
    createdon = map["createdon"].toDate();
  }

  Map<String, dynamic> toMap() {
    return {
      "messageid": messageid,
      "sender": sender,
      "text": text,
      "trns_text" : trns_text,
      "seen": seen,
      "createdon": createdon,
    };
  }
}
