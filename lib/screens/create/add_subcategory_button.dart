import 'package:flutter/material.dart';

class AddSubcategoryButton extends StatefulWidget {
  final void Function(String) onSubmitted;

  const AddSubcategoryButton({super.key, required this.onSubmitted});

  @override
  State<AddSubcategoryButton> createState() => _AddSubcategoryButtonState();
}

class _AddSubcategoryButtonState extends State<AddSubcategoryButton> {
  bool _isEditing = false;
  final TextEditingController _controller = TextEditingController();

  void _submit() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSubmitted(text);
      _controller.clear();
      setState(() => _isEditing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() => _isEditing = true);
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
                    cursorColor: Colors.white,
                    style: Theme.of(context).textTheme.bodyMedium,
                    controller: _controller,
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
