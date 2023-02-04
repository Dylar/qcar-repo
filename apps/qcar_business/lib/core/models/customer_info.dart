import 'dart:convert';

import 'package:hive/hive.dart';

import 'model_data.dart';

part 'customer_info.g.dart';

enum Gender { MALE, FEMALE, DIVERS }

@HiveType(typeId: CUSTOMER_INFO_TYPE_ID)
class CustomerInfo extends HiveObject {
  CustomerInfo({
    required this.dealer,
    required this.name,
    required this.lastName,
    required this.gender,
    required this.birthday,
    required this.email,
    required this.phone,
  });

  static CustomerInfo empty() => fromMap({});

  String toJson() => jsonEncode(toMap());

  static String toListJson(List<CustomerInfo> infos) =>
      jsonEncode(infos.map((e) => e.toMap()).toList());

  static CustomerInfo fromMap(Map<String, dynamic> map) => CustomerInfo(
        dealer: map[FIELD_DEALER] ?? "",
        name: map[FIELD_NAME] ?? "",
        lastName: map[FIELD_LAST_NAME] ?? "",
        birthday: map[FIELD_BIRTHDAY] ?? "",
        gender: Gender.values.firstWhere(
          (gender) => gender.name == (map[FIELD_GENDER] ?? ""),
          orElse: () => Gender.DIVERS,
        ),
        email: map[FIELD_EMAIL] ?? "",
        phone: map[FIELD_PHONE] ?? "",
      );

  Map<String, dynamic> toMap() => {
        FIELD_DEALER: dealer,
        FIELD_NAME: name,
        FIELD_LAST_NAME: lastName,
        FIELD_BIRTHDAY: birthday,
        FIELD_GENDER: gender.name,
        FIELD_EMAIL: email,
        FIELD_PHONE: phone,
      };

  CustomerInfo copy({
    String? dealer,
    String? name,
    String? lastName,
    Gender? gender,
    String? birthday,
    String? email,
    String? phone,
  }) =>
      CustomerInfo(
        dealer: dealer ?? this.dealer,
        name: name ?? this.name,
        lastName: lastName ?? this.lastName,
        gender: gender ?? this.gender,
        birthday: birthday ?? this.birthday,
        email: email ?? this.email,
        phone: phone ?? this.phone,
      );

  String get fullName => "$name $lastName";

  @HiveField(0)
  String dealer = "";
  @HiveField(1)
  String name = "";
  @HiveField(2)
  String lastName = "";
  @HiveField(3)
  Gender gender = Gender.DIVERS;
  @HiveField(4)
  String birthday = "";
  @HiveField(5)
  String email = "";
  @HiveField(6)
  String phone = "";
}
