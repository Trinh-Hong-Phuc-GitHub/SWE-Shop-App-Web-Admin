class VendorUserModel {
  final bool? approved;

  final String? vendorId;

  final String? businessName;

  final String? cityValue;

  final String? countryValue;

  final String? emailAddress;

  final String? phoneNumber;

  final String? address;

  final String? stateValue;
  final String? storeImage;

  VendorUserModel(
      {required this.approved,
        required this.vendorId,
        required this.businessName,
        required this.cityValue,
        required this.countryValue,
        required this.emailAddress,
        required this.phoneNumber,
        required this.address,
        required this.stateValue,
        required this.storeImage,
      });

  VendorUserModel.fromJson(Map<String, Object?> json)
      : this(
    approved: json['approved']! as bool,
    vendorId: json['vendorId']! as String,
    businessName: json['businessName']! as String,
    cityValue: json['cityValue']! as String,
    countryValue: json['countryValue']! as String,
    emailAddress: json['emailAddress']! as String,
    phoneNumber: json['phoneNumber']! as String,
    address: json['address']! as String,
    stateValue: json['stateValue']! as String,
    storeImage: json['storeImage']! as String,
  );

  Map<String, Object?> toJson() {
    return {
      'approved': approved,
      'vendorId': vendorId,
      'bussinessName': businessName,
      'cityValue': cityValue,
      'countryValue': countryValue,
      'emailAddress': emailAddress,
      'phoneNumber': phoneNumber,
      'address': address,
      'stateValue': stateValue,
      'storeImage': storeImage,
    };
  }
}