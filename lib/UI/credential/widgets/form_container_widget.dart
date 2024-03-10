import 'package:flutter/material.dart';
import 'package:travel_the_world/themes/app_colors.dart';
import 'package:travel_the_world/themes/app_fonts.dart';

class FormContainerWidget extends StatefulWidget {
  final TextEditingController controller;
  final Key? fieldKey;
  final bool isPasswordField;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputType? inputType;

  const FormContainerWidget({
    super.key,
    required this.controller,
    this.fieldKey,
    this.isPasswordField = false,
    this.hintText,
    this.labelText,
    this.helperText,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
    this.inputType,
  });

  @override
  FormContainerWidgetState createState() => FormContainerWidgetState();
}

class FormContainerWidgetState extends State<FormContainerWidget> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        style: Fonts.f16w400(
            color:
                getThemeColor(context, AppColors.darkOlive, AppColors.olive)),
        controller: widget.controller,
        keyboardType: widget.inputType,
        key: widget.fieldKey,
        obscureText: widget.isPasswordField ? _obscureText : false,
        onSaved: widget.onSaved,
        validator: widget.validator,
        onFieldSubmitted: widget.onFieldSubmitted,
        decoration: InputDecoration(
          fillColor:
              getThemeColor(context, AppColors.olive, AppColors.darkOlive),
          border: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          filled: true,
          hintText: widget.hintText,
          hintStyle: Fonts.f16w400(
              color: getThemeColor(
            context,
            AppColors.darkOlive,
            AppColors.olive,
          )),
          suffixIcon: PasswordVisibilityIcon(
            obscureText: _obscureText,
            isPasswordField: widget.isPasswordField,
            onTap: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
        ),
      ),
    );
  }
}

class PasswordVisibilityIcon extends StatelessWidget {
  final bool obscureText;
  final bool isPasswordField;
  final VoidCallback onTap;

  const PasswordVisibilityIcon({
    super.key,
    required this.obscureText,
    required this.isPasswordField,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isPasswordField) {
      return GestureDetector(
        onTap: onTap,
        child: Icon(
          obscureText ? Icons.visibility_off : Icons.visibility,
          color: obscureText ? AppColors.black : AppColors.white,
        ),
      );
    } else {
      return const Text("");
    }
  }
}
