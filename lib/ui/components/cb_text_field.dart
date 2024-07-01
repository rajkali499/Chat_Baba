import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CBTextField extends StatelessWidget {
  TextEditingController? controller;
  TextInputType? inputType;
  Function(String)? onChange;  Function(String)? onSubmit;
  Function()? onTap;
  String? Function(String?)? validate;
  String labelText;
  String? hintText;
  bool centerLabel;
  String? initialValue;
  TextAlign? textAlign;
  int? maxLine;
  int? minLine;
  Widget? label;
  double? fontsize;
  double? borderRadius;
  Color? color;
  Color? enableColor;
  FontWeight? fontweight;
  Color? fillcolor;
  bool? fill;
  double? letterSpace;
  bool? obscure;
  Color? textFontColor;
  String? textFontFamily;
  String? labelFontFamily;
  double? textFontSize;
  FontWeight? textFontWeight;
  bool? enable;
  Widget? prefix;
  bool? alignWithHint;
  bool disableLabel;
  Widget? suffix;
  BoxConstraints? prefixBoxConstraints;
  List<TextInputFormatter>? inputFormat;
  FocusNode ? focus;
  FloatingLabelBehavior? floating;
  bool? isCapitalizedRequired;
  bool? isSensitive;

  CBTextField(
      {Key? key,
        this.suffix,
        this.inputFormat,
        this.enableColor,
        this.centerLabel = false,
        this.letterSpace,
        this.enable,
        this.onSubmit,
        this.textFontColor,
        this.textFontFamily,
        this.textFontSize,
        this.initialValue,
        this.textFontWeight,
        this.borderRadius,
        this.fontweight,
        this.fontsize,
        this.labelText = "",
        this.controller,
        this.onChange,
        this.inputType,
        this.validate,
        this.maxLine,
        this.hintText = "",
        this.onTap,
        this.textAlign,
        this.color,
        this.fill,
        this.fillcolor,
        this.obscure,
        this.minLine = 1,
        this.prefix,
        this.labelFontFamily,
        this.label,
        this.alignWithHint,
        this.prefixBoxConstraints,
        this.floating = FloatingLabelBehavior.auto,
        this.focus,
        this.disableLabel = false,this.isCapitalizedRequired=true,
        this.isSensitive=false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focus,
      onTap: onTap,
      scrollPadding: EdgeInsets.zero,
      enabled: enable ?? true,
      toolbarOptions: ToolbarOptions(copy: isSensitive==true?false:true ,paste: isSensitive==true?false:true,selectAll: isSensitive==true?false:true, cut: isSensitive==true?false:true),
      initialValue: initialValue,
      textCapitalization: isCapitalizedRequired==true?TextCapitalization.words:TextCapitalization.none,
      keyboardType: inputType ?? TextInputType.name,
      maxLines: maxLine ?? 1,
      minLines: minLine ?? 1,
      obscureText: obscure ?? false,
      controller: controller,
      validator: validate,
      onChanged: onChange,
      onFieldSubmitted: onSubmit,
      textAlign: textAlign ?? TextAlign.start,
      inputFormatters: inputFormat,
      style: TextStyle(
        fontFamily: "inter",
        fontSize: textFontSize ?? 22,
        color: textFontColor,
        fontWeight: textFontWeight ?? FontWeight.w400,
      ),
      decoration: InputDecoration(
        errorMaxLines: 2,
        prefixIcon: prefix,
        suffixIcon: suffix,
        prefixIconConstraints: prefixBoxConstraints ??
            const BoxConstraints(minHeight: 25, minWidth: 25),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 25,
        ),
        fillColor: fillcolor,
        filled: fill,
        errorStyle:  const TextStyle(  fontFamily: "inter",color: Colors.red),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(borderRadius ?? 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: enableColor ?? Colors.transparent),
          borderRadius: BorderRadius.circular(borderRadius ?? 1),
        ),
        labelText: labelText,
        floatingLabelBehavior: floating,
        labelStyle: TextStyle(
          // fontFamily: labelFontFamily ?? "Inter",
          fontFamily: "inter",
          color: color ?? Colors.black.withOpacity(0.7),
          fontSize: fontsize ?? 22,
          fontWeight: fontweight ?? FontWeight.w500,
        ),
        hintText: hintText,
        alignLabelWithHint: alignWithHint ?? true,
        hintStyle: TextStyle(
          // fontFamily: textFontFamily ?? "Inter",
          fontFamily: "inter",
          color: color ?? Colors.transparent,
          fontSize: fontsize ?? 22,
          fontWeight: fontweight ?? FontWeight.w400,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(borderRadius ?? 3),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: enableColor ?? Colors.transparent),
          borderRadius: BorderRadius.circular(borderRadius ?? 3),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(borderRadius ?? 3),
        ),
      ),
    );
  }
}
