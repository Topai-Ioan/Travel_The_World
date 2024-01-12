import 'package:flutter/material.dart';
import '../../../../constants.dart';

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
  _FormContainerWidgetState createState() => _FormContainerWidgetState();
}

class _FormContainerWidgetState extends State<FormContainerWidget> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
        borderRadius: BorderRadius.circular(3),
      ),
      child: TextFormField(
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
        controller: widget.controller,
        keyboardType: widget.inputType,
        key: widget.fieldKey,
        obscureText: widget.isPasswordField ? _obscureText : false,
        onSaved: widget.onSaved,
        validator: widget.validator,
        onFieldSubmitted: widget.onFieldSubmitted,
        decoration: InputDecoration(
          fillColor: Theme.of(context).colorScheme.tertiary,
          border: InputBorder.none,
          filled: true,
          hintText: widget.hintText,
          hintStyle:
              TextStyle(color: Theme.of(context).primaryColor.withOpacity(0.5)),
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
          color: obscureText
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.primary,
        ),
      );
    } else {
      return const Text("");
    }
  }
}

class FormContainerWidgetState extends State<FormContainerWidget> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: secondaryColor.withOpacity(.35),
        borderRadius: BorderRadius.circular(3),
      ),
      child: TextFormField(
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
        controller: widget.controller,
        keyboardType: widget.inputType,
        key: widget.fieldKey,
        obscureText: widget.isPasswordField == true ? _obscureText : false,
        onSaved: widget.onSaved,
        validator: widget.validator,
        onFieldSubmitted: widget.onFieldSubmitted,
        decoration: InputDecoration(
          border: InputBorder.none,
          filled: true,
          hintText: widget.hintText,
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            child: widget.isPasswordField == true
                ? Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: _obscureText == false
                        ? blueColor
                        : Theme.of(context).colorScheme.primary,
                  )
                : const Text(""),
          ),
        ),
      ),
    );
  }
}
