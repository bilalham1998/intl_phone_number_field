// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'country_code_model.g.dart';

@JsonSerializable()
class CountryCodeModel {
  final String name;
  final String dial_code;
  final String code;
    final int? min_length;
  final int? max_length;

  CountryCodeModel(
      {required this.name, required this.dial_code, required this.code, this.min_length , this.max_length});

  CountryCodeModel fromJson(Map<String, dynamic> json) {
    return _$CountryCodeModelFromJson(json);
  }

  factory CountryCodeModel.fromJson(Map<String, dynamic> json) {
    return _$CountryCodeModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$CountryCodeModelToJson(this);
  }
}
