class Classement {
  final int id;
  final String pseudo;
  final double temps;
  final int score;

  Classement(
      {required this.id,
      required this.pseudo,
      required this.temps,
      required this.score});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pseudo': pseudo,
      'temps': temps,
      'score': score,
    };
  }

  factory Classement.fromMap(Map<String, dynamic> map) {
    return Classement(
      id: map['id'],
      pseudo: map['pseudo'],
      temps: map['temps'],
      score: map['score'],
    );
  }
}
