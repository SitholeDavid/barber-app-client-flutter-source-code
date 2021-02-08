class Client {
  String clientID;
  String name;
  String surname;
  String email;
  String phoneNo;
  String displayPictureUrl;

  Client(
      {this.clientID = '',
      this.name = '',
      this.surname = '',
      this.email = '',
      this.phoneNo = '',
      this.displayPictureUrl = ''});

  Client.fromMap(Map<String, dynamic> map, String uid) {
    clientID = uid;
    name = map['name'];
    surname = map['surname'];
    email = map['email'];
    phoneNo = map['phoneNo'];
    displayPictureUrl = map['displayPictureUrl'];
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'surname': surname,
        'email': email,
        'phoneNo': phoneNo,
        'displayPictureUrl': displayPictureUrl
      };
}
