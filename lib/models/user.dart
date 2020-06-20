

class User {

  String _userName;
  String _userAddress;
  int _id;

  User(this._userName, this._userAddress);

  User.map(dynamic obj) {
    this._userName = obj['name'];
    this._userAddress = obj['address'];
    this._id = obj['id'];
  }

  String get userName => _userName;
  String get userAddress => _userAddress;
  int get id => _id;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    //  those map keys are must be as same as database table columns
    map["name"] = _userName;
    map["address"] = _userAddress;

    if(id != null) {
      map["id"] = _id;
    }
    return map;
  }

  User.fromMap(Map<String, dynamic> map){
    this._userName = map["name"];
    this._userAddress = map["address"];
    this._id = map["id"];
  }

}