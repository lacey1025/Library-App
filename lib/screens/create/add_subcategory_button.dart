import 'package:flutter/material.dart';

class AddSubcategoryButton extends StatefulWidget {
  final void Function(String) onSubmitted;
  final TextEditingController controller;

  const AddSubcategoryButton({
    super.key,
    required this.onSubmitted,
    required this.controller,
  });

  @override
  State<AddSubcategoryButton> createState() => _AddSubcategoryButtonState();
}

class _AddSubcategoryButtonState extends State<AddSubcategoryButton> {
  bool _isEditing = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && _isEditing) {
        setState(() {
          _isEditing = false;
          widget.controller.clear();
        });
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _submit() {
    final text = widget.controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSubmitted(text);
      widget.controller.clear();
    }
    FocusScope.of(context).unfocus();
    setState(() => _isEditing = false);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        setState(() => _isEditing = true);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _focusNode.requestFocus();
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.only(top: 5),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 152, 56, 56),
          borderRadius: BorderRadius.circular(8),
        ),
        child:
            _isEditing
                ? SizedBox(
                  width: 250,
                  child: TextField(
                    focusNode: _focusNode,
                    cursorColor: Colors.white,
                    style: Theme.of(context).textTheme.bodyMedium,
                    controller: widget.controller,
                    autofocus: true,
                    onSubmitted: (_) => _submit(),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      hintText: "add new subcategory",
                      hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 218, 181, 181),
                      ),
                      fillColor: Colors.transparent,
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.check, color: Colors.white),
                        onPressed: _submit,
                      ),
                    ),
                  ),
                )
                : const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
