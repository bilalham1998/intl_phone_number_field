// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_code_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CountryCodeModel _$CountryCodeModelFromJson(Map<String, dynamic> json) =>
    CountryCodeModel(
      name: json['name'] as String,
      dial_code: json['dial_code'] as String,
      code: json['code'] as String,
         min_length: json['min_length'] as int,
      max_length: json['max_length'] as int,
    );

Map<String, dynamic> _$CountryCodeModelToJson(CountryCodeModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'dial_code': instance.dial_code,
      'code': instance.code,
    };
