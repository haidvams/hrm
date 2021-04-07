class User {
  int _id;
  String _username;
  String _password;
  String _sid;
  User(this._username, this._password, this._sid);

  User.map(dynamic obj) {
    this._username = obj["username"];
    this._password = obj["password"];
    this._sid      = obj["sid"];
    this._id = obj["id"];

  }

  String get username => _username;
  String get password => _password;
  String get sid => _sid;
  int get id => _id;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["username"] = _username;
    map["password"] = _password;
    map["sid"] = _sid;
    if (_id != null) {
      map["id"] = _id;
    }
    return map;
  }

}