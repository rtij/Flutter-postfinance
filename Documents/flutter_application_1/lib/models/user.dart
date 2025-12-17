
class User {
  final int idBeneficiaire;
  final String nom;
  final String prenom;
  final String email;
  final String telephone;
  final String adresse;
  final String cinBeneficiaire;
  final List<Account> comptes;

  User({
    required this.idBeneficiaire,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.telephone,
    required this.adresse,
    required this.cinBeneficiaire,
    required this.comptes,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    var comptesFromJson = json['comptes'] as List;
    List<Account> comptesList = comptesFromJson.map((i) => Account.fromJson(i)).toList();

    return User(
      idBeneficiaire: json['id_beneficiaire'],
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      telephone: json['telephone'],
      adresse: json['adresse'],
      cinBeneficiaire: json['cin_beneficiaire'],
      comptes: comptesList,
    );
  }
}

class Account {
  final int rowid;
  final int beneficiaireRowid;
  final String numcompte;
  final String dateCreation;
  final int state;
  final int typeCarteId;
  final String name;

  Account({
    required this.rowid,
    required this.beneficiaireRowid,
    required this.numcompte,
    required this.dateCreation,
    required this.state,
    required this.typeCarteId,
    required this.name,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      rowid: json['rowid'],
      beneficiaireRowid: json['beneficiaire_rowid'],
      numcompte: json['numcompte'],
      dateCreation: json['date_creation'],
      state: json['state'],
      typeCarteId: json['type_carte_id'],
      name: json['name'],
    );
  }
}