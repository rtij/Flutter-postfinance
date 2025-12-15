
  String formatPhoneNumber(String phoneNumber) {
    final cleanedNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanedNumber.length >= 3 && !cleanedNumber.startsWith('00')) {
      return '00$cleanedNumber';
    }
    return phoneNumber;
  }
