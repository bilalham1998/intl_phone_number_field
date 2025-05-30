// ignore_for_file: non_constant_identifier_names

library intl_phone_number_field;

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

import 'models/country_code_model.dart';
import 'models/country_config.dart';
import 'models/dialog_config.dart';
import 'models/phone_config.dart';
import 'util/general_util.dart';
import 'view/country_code_bottom_sheet.dart';
import 'view/flag_view.dart';
import 'view/rixa_textfield.dart';

export 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';

export 'models/country_code_model.dart';
export 'models/country_config.dart';
export 'models/dialog_config.dart';
export 'models/phone_config.dart';

class InternationalPhoneNumberInput extends StatefulWidget {
  final TextEditingController controller;
  final double? height;
  final bool inactive;
  final DialogConfig dialogConfig;
  final CountryConfig countryConfig;
  final PhoneConfig phoneConfig;
  final CountryCodeModel initCountry;
  final dynamic Function(IntPhoneNumber number)? onInputChanged;
  final double betweenPadding;
  final MaskedInputFormatter? formatter;
  final List<TextInputFormatter> inputFormatters;
  final Future<String?> Function()? loadFromJson;
  final String? Function(dynamic )? validator;
  final InputDecoration? decoration;
  String? language;
  InternationalPhoneNumberInput(
      {super.key,
      TextEditingController? controller,
      this.height = 60,
        this.decoration,
      this.inputFormatters = const [],
      CountryCodeModel? initCountry,
      this.betweenPadding = 23,
      this.onInputChanged,
      this.loadFromJson,
      this.formatter,
      this.language,
      this.validator,
      this.inactive = false,
      DialogConfig? dialogConfig,
      CountryConfig? countryConfig,
      PhoneConfig? phoneConfig})
      : dialogConfig = dialogConfig ?? DialogConfig(),
        controller = controller ?? TextEditingController(),
        countryConfig = countryConfig ?? CountryConfig(),
        initCountry = initCountry ??
            CountryCodeModel(
                name: "United States", dial_code: "+1", code: "US"),
        phoneConfig = phoneConfig ?? PhoneConfig();

  @override
  State<InternationalPhoneNumberInput> createState() =>
      _InternationalPhoneNumberInputState();
}

class _InternationalPhoneNumberInputState
    extends State<InternationalPhoneNumberInput> {
  List<CountryCodeModel>? countries;
  late CountryCodeModel selected;

  String? errorText;
  late FocusNode node;

  @override
  void initState() {
    selected = widget.initCountry;
    if (widget.loadFromJson == null) {
      getAllCountry();
    } else {
      widget.loadFromJson!()
          .then((data) => data != null ? loadFromJson(data) : getAllCountry());
    }
    node = widget.phoneConfig.focusNode ?? FocusNode();
    if (widget.phoneConfig.autovalidateMode == AutovalidateMode.always &&
        widget.validator != null) {
      String? error = widget.validator!(IntPhoneNumber(
          code: selected.code,
          dial_code: selected.dial_code,
          min_length: selected!.min_length!,
          max_length: selected!.max_length!,
          number: widget.controller.text.trimLeft().trimRight()));
      if (errorText != error) {
        errorText = error;
      }
    }
    node.addListener(listenNode);
    super.initState();
  }

  @override
  void dispose() {
    node.removeListener(listenNode);
    super.dispose();
  }

  void listenNode() {
    if (node.hasFocus &&
        widget.phoneConfig.autovalidateMode ==
            AutovalidateMode.onUserInteraction &&
        widget.validator != null) {
      String? error = widget.validator!(IntPhoneNumber(
          code: selected.code,
          dial_code: selected.dial_code,
          min_length: selected!.min_length!,
          max_length: selected!.max_length!,
          number: widget.controller.text.trimLeft().trimRight()));
      if (errorText != error) {
        errorText = error;
        if (mounted) setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return    Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(


            child:
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 50 ,
                    child: TextButton(
                      onPressed: () {
                        if (!widget.inactive && countries != null) {
                          showModalBottomSheet(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(30))),
                              barrierColor: Colors.black.withOpacity(0.6),
                              isScrollControlled: true,
                              backgroundColor:
                              widget.dialogConfig.backgroundColor,
                              context: context,
                              builder: (context) {
                                return SingleChildScrollView(
                                  child: CountryCodeBottomSheet(
                                    language: widget.language,
                                    decoration: widget!.decoration!,
                                    countries: countries!,
                                    selected: selected,
                                    onSelected: (countryCodeModel) {
                                      setState(() {
                                        selected = countryCodeModel;
                                      });
                                      if (widget.onInputChanged != null) {
                                        widget.onInputChanged!(IntPhoneNumber(
                                            code: selected.code,
                                            dial_code: selected.dial_code,
                                            min_length: selected!.min_length!,
          max_length: selected!.max_length!,
                                            number: widget.controller.text
                                                .trimLeft()
                                                .trimRight()));
                                      }
                                    },
                                    dialogConfig: widget.dialogConfig,
                                  ),
                                );
                              });
                        }
                      },
                      style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: widget.countryConfig.decoration,
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FlagView(
                              countryCodeModel: selected,
                              isFlat: widget.countryConfig.flatFlag,
                              size: widget.countryConfig.flagSize,
                            ),
                            const SizedBox(width: 3),
                            Icon(Icons.arrow_drop_down , size: 20,color: Color(0xFF1C2230),),

                            // Text(
                            //   selected.dial_code,
                            //   style: widget.countryConfig.textStyle,
                            // )
                          ],
                        ),
                      ),
                    ),
                  )),
              SizedBox(width: widget.betweenPadding),
              Expanded(
                  flex: 8,

                  //     child: SizedBox(
                  // height:(widget.height ?? 0.0) - 15.0,
                  child:
                  RixaTextField(
                    code:  widget.language == "ar" ? "\u200E" + (selected.dial_code):selected.dial_code ,
                    color: Colors.green,
                    validator: widget.validator,
                    hintText: widget.phoneConfig.hintText ?? "",
                    hintStyle: widget.phoneConfig.hintStyle,
                    textStyle: widget.phoneConfig.textStyle,
                    controller: widget.controller,
                    focusNode: node,
                    decoration: widget.phoneConfig.decoration,
                    errorStyle: widget.phoneConfig.errorStyle,
                    backgroundColor: widget.phoneConfig.backgroundColor,
                    labelStyle: widget.phoneConfig.labelStyle,
                    textInputAction: widget.phoneConfig.textInputAction,
                    labelText: widget.phoneConfig.labelText,
                    floatingLabelStyle: widget.phoneConfig.floatingLabelStyle,
                    radius: widget.phoneConfig.radius,
                    isUnderline: false,
                    textInputType: TextInputType.numberWithOptions(decimal: true),
                    expands: false,
                    errorColor: Colors.red,
                    autoFocus: widget.phoneConfig.autoFocus,
                    inputFormatters: [
                      ...widget.inputFormatters,
                      CommaNumberInputFormatter(),
           
                      if (widget.formatter != null) widget.formatter!
                    ],
                    focusedColor: errorText != null
                        ? widget.phoneConfig.errorColor
                        : widget.phoneConfig.focusedColor,
                    enabledColor: errorText != null
                        ? widget.phoneConfig.errorColor
                        : widget.phoneConfig.enabledColor,
                    showCursor: widget.phoneConfig.showCursor,
                    borderWidth: widget.phoneConfig.borderWidth,
                    onChanged: (text) {
                      if (widget.onInputChanged != null) {
                        widget.onInputChanged!(IntPhoneNumber(
                            code: selected.code,
                            dial_code: selected.dial_code,
                            min_length: selected!.min_length!,
          max_length: selected!.max_length!,
                            number: text.trimLeft().trimRight()));
                      }
                      if (widget.validator != null) {
                        String? error = widget.validator!(IntPhoneNumber(
                            code: selected.code,
                            dial_code: selected.dial_code,
                            min_length: selected!.min_length!,
          max_length: selected!.max_length!,
                            number: text.trimLeft().trimRight()));
                        if (errorText != error) {
                          setState(() {
                            errorText = error;
                          });
                        }
                      }
                    },
                  )
              ),
              // ),
            ]),
          ),


        ],

    );

  }

  Future<void> getAllCountry() async {
    if (widget.loadFromJson != null) {
    } else {
      countries = await GeneralUtil.loadJson();
    }
    setState(() {});
  }

  void loadFromJson(String data) {
    Iterable jsonResult = json.decode(data);
    countries = List<CountryCodeModel>.from(jsonResult.map((model) {
      try {
        return CountryCodeModel.fromJson(model);
      } catch (e, stackTrace) {
        log("Json Converter Failed: ", error: e, stackTrace: stackTrace);
      }
    }));
    setState(() {});
  }

 
}

class IntPhoneNumber {
  String code, dial_code, number;
    int  min_length , max_length;
  IntPhoneNumber(
      {required this.code, required this.dial_code, required this.number,required this.min_length ,required this.max_length });
  String get fullNumber => "$dial_code $number";
  int get minLength => min_length;
  int get maxLength => max_length;
  String get rawNumber => number.replaceAll(" ", "");
  String get rawDialCode => dial_code.replaceAll("+", "");
  String get rawFullNumber =>
      fullNumber.replaceAll(" ", "").replaceAll("+", "");
}

 class CommaNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Allow digits and commas
    final RegExp regExp = RegExp(r'^[0-9]*$');

    // If the new value matches the regular expression, return it
    if (regExp.hasMatch(newValue.text)) {
      return newValue;
    }

    // If it doesn't match, return the old value
    return oldValue;
  }
}