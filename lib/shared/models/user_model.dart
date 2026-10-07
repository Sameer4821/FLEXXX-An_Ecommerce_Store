class AddressModel {
  final String id;
  final String label; // "Home", "Work", "Other"
  final String recipientName;
  final String phone;
  final String streetAddress;
  final String city;
  final String state;
  final String pincode;
  final bool isDefault;

  const AddressModel({
    required this.id,
    required this.label,
    required this.recipientName,
    required this.phone,
    required this.streetAddress,
    required this.city,
    required this.state,
    required this.pincode,
    this.isDefault = false,
  });

  String get fullAddress =>
      "$streetAddress, $city, $state - $pincode";
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatarUrl;
  final int flexCoins;
  final String membershipTier;
  final List<AddressModel> addresses;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatarUrl,
    required this.flexCoins,
    required this.membershipTier,
    required this.addresses,
  });
}
