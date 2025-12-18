class Transaction {
  final String reference;
  final String codeAgence;
  final String numcompte;
  final String currency;
  final String sens;
  final String montant;
  final String dateTransaction;
  final String dateValidation;
  final String nomAgence;

  Transaction({
    required this.reference,
    required this.codeAgence,
    required this.numcompte,
    required this.currency,
    required this.sens,
    required this.montant,
    required this.dateTransaction,
    required this.dateValidation,
    required this.nomAgence,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      reference: json['reference'],
      codeAgence: json['code_agence'],
      numcompte: json['numcompte'],
      currency: json['currency'],
      sens: json['sens'],
      montant: json['montant'],
      dateTransaction: json['date_transaction'],
      dateValidation: json['date_validation'],
      nomAgence: json['nom_agence'],
    );
  }
}
