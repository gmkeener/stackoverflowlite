

class FirestoreDocument {
  String? name;
  Map? fields;
  String? createTime;
  String? updateTime;

  FirestoreDocument({this.name, this.fields, this.createTime, this.updateTime});

  FirestoreDocument.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    fields = json['fields'] != null ? json['fields'] : null;
    createTime = json['createTime'];
    updateTime = json['updateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.fields != null) {
      data['fields'] = this.fields;
    }
    data['createTime'] = this.createTime;
    data['updateTime'] = this.updateTime;
    return data;
  }
}
