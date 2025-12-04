class Beneficiaire {
  final int id;
  final String nom;
  final String prenom;
  final String adresse;
  final String? numCompte;
  final String? cleRib;
  final String? codeGuichet;
  final String? codeBanque;
  final int? paysBanqueId;
  final String? nomBanque;
  final String? codeSwift;
  final String? memeBanque;
  final int state;

  Beneficiaire({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.adresse,
    this.numCompte,
    this.cleRib,
    this.codeGuichet,
    this.codeBanque,
    this.paysBanqueId,
    this.nomBanque,
    this.codeSwift,
    this.memeBanque,
    required this.state,
  });

  factory Beneficiaire.fromJson(Map<String, dynamic> json) {
    return Beneficiaire(
      id: json['id'],
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      adresse: json['adresse'] ?? '',
      numCompte: json['numcompte'],
      cleRib: json['cle_rib'],
      codeGuichet: json['code_guichet'],
      codeBanque: json['code_banque'],
      paysBanqueId: json['pays_banque_id'],
      nomBanque: json['nom_banque'],
      codeSwift: json['code_swift'],
      memeBanque: json['meme_banque'],
      state: json['state'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "nom": nom,
      "prenom": prenom,
      "adresse": adresse,
      "numcompte": numCompte,
      "cle_rib": cleRib,
      "code_guichet": codeGuichet,
      "code_banque": codeBanque,
      "pays_banque_id": paysBanqueId,
      "nom_banque": nomBanque,
      "code_swift": codeSwift,
      "meme_banque": memeBanque,
      "state": state,
    };
  }
}
