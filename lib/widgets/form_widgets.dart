import 'package:devproj/theme/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:devproj/pages/shared_pages/home_screen.dart';
import 'package:devproj/theme/app_colours.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';

class CustomFormField extends StatefulWidget {
  final String label;
  final bool obscureText;
  final bool isPasswordVisible;
  final VoidCallback? onSuffixIconPressed;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final TextEditingController? controller;

  const CustomFormField({
    Key? key,
    required this.label,
    this.obscureText = false,
    this.isPasswordVisible = false,
    this.onSuffixIconPressed,
    this.onChanged,
    this.validator,
    this.onSaved,
    this.controller,
  }) : super(key: key);

  @override
  _CustomFormFieldState createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  String _normalizeEmail(String email) {
    return email.replaceAll(' ', '').toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (widget.validator != null) {
          return widget.validator!(_normalizeEmail(value ?? ''));
        }
        return null;
      },
      onSaved: (value) {
        if (widget.onSaved != null) {
          widget.onSaved!(_normalizeEmail(value ?? ''));
        }
      },
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: widget.controller,
              obscureText:
                  widget.obscureText ? !widget.isPasswordVisible : false,
              style: const TextStyle(color: AppColors.darkBlue),
              decoration: InputDecoration(
                fillColor: AppColors.white,
                labelText: widget.label,
                labelStyle: AppStyles.labelTextStyle,
                border: const OutlineInputBorder(),
                suffixIcon: widget.obscureText
                    ? IconButton(
                        icon: Icon(
                          widget.isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: AppColors.darkBlue,
                        ),
                        onPressed: widget.onSuffixIconPressed,
                      )
                    : null,
              ),
              onChanged: (value) {
                String normalizedValue = _normalizeEmail(value);
                state.didChange(normalizedValue);
                if (widget.onChanged != null) {
                  widget.onChanged!(normalizedValue);
                }
              },
            ),
            if (state.hasError)
              Text(
                state.errorText ?? "",
                style: AppStyles.errorTextStyle,
              ),
          ],
        );
      },
    );
  }
}
