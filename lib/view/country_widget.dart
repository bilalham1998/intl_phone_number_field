import 'package:flutter/material.dart';
import '../models/country_code_model.dart';
import '../models/dialog_config.dart';
import 'flag_view.dart';

class CountryWidget extends StatelessWidget {
  final CountryCodeModel countryCodeModel;
  final DialogConfig dialogConfig;
  final bool isSelected;
  String? language;
  CountryWidget(
      {required this.countryCodeModel,
      required this.dialogConfig,
      required this.isSelected,
      this.language,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: dialogConfig.countryItemHeight,
      color: isSelected ? dialogConfig.selectedItemColor : Colors.transparent,
      padding: const EdgeInsets.only(left: 40, right: 55),
      child: Row(children: [
        FlagView(
            countryCodeModel:  countryCodeModel,
            isFlat: dialogConfig.flatFlag,
            size: dialogConfig.itemFlagSize),
        const SizedBox(width: 25),
        Expanded(
          child: Text(
            countryCodeModel.name,
            overflow: TextOverflow.ellipsis,
            style: dialogConfig.textStyle,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          (language != null && language == "ar") ?( "\u200E" + countryCodeModel .dial_code): countryCodeModel.dial_code,
          style: dialogConfig.textStyle,
        )
      ]),
    );
  }
}
