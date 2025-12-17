
class Compte {
  final int rowid;
  final int beneficiaireRowid;
  final String numcompte;
  final String dateCreation;
  final int state;
  final int typeCarteId;
  final String name;
  final double soldeConsolide;
  final double soldeDisponible;

  Compte({
    required this.rowid,
    required this.beneficiaireRowid,
    required this.numcompte,
    required this.dateCreation,
    required this.state,
    required this.typeCarteId,
    required this.name,
    required this.soldeConsolide,
    required this.soldeDisponible,
  });

  factory Compte.fromJson(Map<String, dynamic> json) {
    return Compte(
      rowid: json['rowid'],
      beneficiaireRowid: json['beneficiaireRowid'],
      numcompte: json['numcompte'],
      dateCreation: json['dateCreation'],
      state: json['state'],
      typeCarteId: json['typeCarteId'],
      name: json['name'],
      soldeConsolide: json['soldeConsolide'],
      soldeDisponible: json['soldeDisponible'],
    );
  }
}



class CardAccount {
  final int rowid;
  final String numcompte;
  final String name;
  final String soldeConsolide;
  final String soldeDisponible;

  CardAccount({
    required this.rowid,
    required this.numcompte,
    required this.name,
    required this.soldeConsolide,
    required this.soldeDisponible,
  });

  factory CardAccount.fromJson(Map<String, dynamic> json) {
    return CardAccount(
      rowid: json['rowid'],
      numcompte: json['numcompte'],
      name: json['name'],
      soldeConsolide: json['solde_consolide'],
      soldeDisponible: json['solde_disponible'],
    );
  }
}