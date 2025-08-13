import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/helper/app_text.dart';
import '../../../../../core/utils/color_resources.dart';
import '../../../../../core/utils/images_path.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthInput extends StatefulWidget {
  final String? label;
  final String hintText;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLength;
  final Widget? suffixIcon;
  final String? prefixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final Color fillColor;
  final bool isRequired;
  final bool isBorder;
  final String? subLabel;
  final bool isPassword;
  final bool isSelect;
  final Function()? onTap;
  final Function(String)? onChange;
  final bool readOnly;
  final Function()? onNext;
  final Function()? onDone;
  final int? maxLine;
  final bool isShowCounter;
  final Color? colorBorder;
  final TextStyle? textStyle;
  final TextStyle? styleLable;
  final TextStyle? hintStyle;
  final bool? enabled;
  final String? errorText;
  final bool? showCursor;

  const AuthInput({
    super.key,
    this.label,
    required this.controller,
    required this.hintText,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.suffixIcon,
    this.prefixIcon,
    this.inputFormatters,
    this.fillColor = Colors.white,
    this.isRequired = true,
    this.isBorder = false,
    this.subLabel,
    this.isPassword = false,
    this.onTap,
    this.isSelect = false,
    this.readOnly = false,
    this.onChange,
    this.onNext,
    this.onDone,
    this.maxLine,
    this.textInputAction,
    this.isShowCounter = false,
    this.colorBorder,
    this.textStyle,
    this.styleLable,
    this.hintStyle,
    this.enabled = true,
    this.errorText,
    this.showCursor
  });

  @override
  State<AuthInput> createState() => _AuthInputState();
}

class _AuthInputState extends State<AuthInput> {
  bool obscureText = false;
  bool isFocus = false;

  @override
  void initState() {
    if (widget.isPassword) {
      obscureText = true;
    }

    widget.focusNode?.addListener(() {
      setState(() {
        isFocus = widget.focusNode!.hasFocus;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (widget.label != null)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: widget.label,
                    style:
                    widget.styleLable ??
                        AppText.text12.copyWith(
                          color: ColorResources.onBACKGROUND,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  if (widget.subLabel != null)
                    TextSpan(
                      text: widget.subLabel,
                      style: AppText.text12.copyWith(
                        color: ColorResources.onBACKGROUND,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  if (widget.isRequired)
                    TextSpan(
                      text: ' *',
                      style: AppText.text14.copyWith(
                        color: ColorResources.RED,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 6),
          ],
        ),
      TextFormField(
        readOnly: widget.readOnly,
        onTap: widget.onTap,
        focusNode: widget.focusNode,
        obscureText: obscureText,
        showCursor: widget.showCursor,
        controller: widget.controller,
        cursorColor: ColorResources.PRIMARY_TEXT,
        style: widget.textStyle ?? TextStyle(color: ColorResources.BLACK, fontSize: 14.sp, fontWeight: FontWeight.w600),
        maxLength: widget.isPassword ? null : widget.maxLength,
        keyboardType: widget.maxLine != null && widget.maxLine! > 1 ? TextInputType.multiline : widget.keyboardType,
        inputFormatters: widget.inputFormatters,
        textInputAction: widget.onNext != null ? TextInputAction.next : widget.textInputAction,
        maxLines: widget.isPassword ? 1 : widget.maxLine,
        onFieldSubmitted: (value) {
          if (widget.onNext != null) {
            widget.onNext!();
          }
          if (widget.onDone != null) {
            widget.onDone!();
          }
        },
        onChanged: widget.onChange,
        decoration: InputDecoration(
          enabled: widget.enabled ?? true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
            !widget.isBorder
                ? BorderSide.none
                : BorderSide(
              color: widget.colorBorder ?? ColorResources.DIVIDER.withValues(alpha: 0.8),
              width: 0.25,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
            !widget.isBorder
                ? BorderSide.none
                : BorderSide(color: ColorResources.DIVIDER.withValues(alpha: 0.8), width: 0.25),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: ColorResources.DIVIDER.withValues(alpha: 0.8),
              width: 0.25,
            ),
          ),
          fillColor: widget.fillColor,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
          isDense: false,
          hintText: widget.hintText,
          hintStyle: widget.hintStyle ?? AppText.text14.copyWith(color: ColorResources.LABEL),
          suffixIcon:
          widget.isPassword
              ? Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () {
                setState(() {
                  obscureText = !obscureText;
                });
              },
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                color:
                !obscureText
                    ? ColorResources.PRIMARY_TEXT
                    : const Color(0xff181313).withValues(alpha: .37),
              ),
            ),
          )
              : widget.isSelect
              ? Icon(
            Icons.keyboard_arrow_down_rounded,
            color: ColorResources.onBACKGROUND,
            size: 18.sp,
          )
              : widget.suffixIcon,
          counterText: !widget.isShowCounter ? '' : null,
          prefixIcon:
          widget.prefixIcon != null
              ? IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40.w,
                  alignment: Alignment.center,
                  child: widget.prefixIcon?.endsWith('.svg') ?? false
                      ? SvgPicture.asset(
                    widget.prefixIcon ?? ImagesPath.icUser,
                    width: 15.w,
                    height: 15.h,
                    colorFilter: ColorFilter.mode(
                      isFocus || widget.controller.text.isNotEmpty
                          ? ColorResources.PRIMARY_TEXT
                          : ColorResources.COLOR_464647,
                      BlendMode.srcIn,
                    ),
                  )
                      : Image.asset(
                    widget.prefixIcon ?? ImagesPath.icUser,
                    width: 15.w,
                    height: 15.h,
                    fit: BoxFit.contain,
                    color: isFocus || widget.controller.text.isNotEmpty
                        ? ColorResources.PRIMARY_TEXT
                        : ColorResources.COLOR_464647,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: VerticalDivider(
                    thickness: 0.5,
                    color: ColorResources.DIVIDER.withValues(alpha: 0.8),
                    indent: 0,
                    endIndent: 0,
                    width: 0,
                  ),
                ),
              ],
            ),
          )
              : null,
        ),
      ),
      Visibility(
          visible: widget.errorText != null,
          child: Text(widget.errorText.toString(), style: AppText.text11.copyWith(color: Colors.red),)
      )
    ],
  );
}
