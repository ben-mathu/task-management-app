import 'package:flutter/material.dart';

class CustomTextButton extends StatefulWidget {
  final String? text;
  final VoidCallback onPressed;
  final bool isLoading;
  const CustomTextButton({
    super.key,
    required this.onPressed,
    this.text,
    this.isLoading = false,
  });

  @override
  State<CustomTextButton> createState() => _CustomTextButtonState();
}

class _CustomTextButtonState extends State<CustomTextButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SizedBox(
        child: TextButton(
          onPressed: widget.onPressed,
          child:
              widget.isLoading
                  ? SizedBox(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(),
                  )
                  : Text(widget.text!),
        ),
      ),
    );
  }
}
