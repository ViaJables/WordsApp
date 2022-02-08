class LocalUser {
  String uid = "", name = "", email ="", image = "", userName = "";
  int lives = 3;
  int bombs = 5;
  int clocks = 5;
  int hourglasses = 5;
  int xpPoints = 0;
  int longestStreak = 0;

  LocalUser.empty();

  LocalUser({
    this.uid = "",
    this.name = "",
    this.email = "",
    this.userName = "",
    this.image = "",
    this.lives = 3,
    this.bombs = 5,
    this.clocks= 5,
    this.hourglasses = 5,
    this.xpPoints = 0,
    this.longestStreak = 0
  });

  factory LocalUser.fromMap(Map<String, dynamic> map) {
    return new LocalUser(
      uid: map['uid'] as String,
      userName: map['userName'] as String,
      name: map['name'] as String? ?? "",
      email: map['email'] as String,
      image: map['image'] as String? ?? "",
      lives: map['lives'] as int,
      bombs: map['bombs'] as int,
      clocks: map['clocks'] as int,
      hourglasses: map['hourglasses'] as int,
      longestStreak: map['longestStreak'] as int? ?? 0,
      xpPoints: map['xpPoints'] as int? ?? 0
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
      'lives': this.lives,
      'bombs': this.bombs,
      'clocks': this.clocks,
      'hourglasses': this.hourglasses,
      'xpPoints': this.xpPoints,
      'longestStreak': this.longestStreak,
    } as Map<String, dynamic>;
  }

  @override
  String toString() {
    return 'User{uid: $uid, name: $name, email: $email, image: $image, UserName: $userName, lives: $lives, bombs: $bombs, clocks: $clocks, hourglasses: $hourglasses }';
  }
}
