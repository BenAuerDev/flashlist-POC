import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PasswordInput extends HookWidget {
  const PasswordInput({
    super.key,
    this.labelText,
    required this.onSaved,
    required this.textInputAction,
  });

  final String? labelText;
  final Function(String?)? onSaved;
  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) {
    var isObscured = useState(true);

    return Stack(
      children: [
        TextFormField(
          obscureText: isObscured.value,
          decoration: InputDecoration(labelText: labelText ?? 'Password'),
          validator: (value) {
            // TODO: add stricter password validation
            if (value == null || value.isEmpty || value.length <= 6) {
              return 'Please enter a valid password, at least 6 characters long';
            }
            return null;
          },
          onSaved: onSaved,
        ),
        Positioned(
          right: 0,
          top: 6,
          child: IconButton(
            onPressed: () {
              isObscured.value = !isObscured.value;
            },
            icon: isObscured.value
                ? const Icon(Icons.visibility)
                : const Icon(Icons.visibility_off),
          ),
        ),
      ],
    );
  }
}
