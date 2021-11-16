class LocalUser {
  String uid, name, email, image, userName;

  LocalUser.empty();

  LocalUser({this.uid, this.name, this.email, this.image, this.userName});

  factory LocalUser.fromMap(Map<String, dynamic> map) {
    return new LocalUser(
      uid: map['uid'] as String,
      userName: map['userName'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      image: map['image'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'uid': this.uid,
      'name': this.name,
      'email': this.email,
      'image': this.image,
      'userName': this.userName,
    } as Map<String, dynamic>;
  }

  @override
  String toString() {
    return 'User{uid: $uid, name: $name, email: $email, image: $image, UserName: $userName}';
  }
}
