import 'package:flutter/material.dart';
import 'package:mb_course/consts/consts.dart';
import 'default_text.dart';


class BuildSectionCardWg extends StatefulWidget {
  final String title;
  final List<Widget> children;
  const BuildSectionCardWg({super.key, required this.title, required this.children});

  @override
  State<BuildSectionCardWg> createState() => _BuildSectionCardState();
}

class _BuildSectionCardState extends State<BuildSectionCardWg> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultTextWg(text: widget.title, fontSize: 16),
            const SizedBox(height: 8),
            ...widget.children,
          ],
        ),
      ),
    );
  }
}


class BuildListItemWg extends StatefulWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final bool showDropdown;
  final bool? isDropdownMenu;
  const BuildListItemWg({
    super.key, 
    required this.icon, 
    required this.text, 
    required this.onTap, 
    required this.showDropdown,
    this.isDropdownMenu = false,
  });

  @override
  State<BuildListItemWg> createState() => _BuildListItemWgState();
}

class _BuildListItemWgState extends State<BuildListItemWg> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(widget.icon, color: const Color(0xFF4A6057)),
      title: DefaultTextWg(text: widget.text),
      trailing: Icon(
        widget.showDropdown && widget.isDropdownMenu == true
            ? Icons.expand_less
            : Icons.chevron_right,
      ),
      onTap: widget.onTap,
    );
  }
}


class BuildSubMenuItemWg extends StatefulWidget {
  final String text;
  final IconData? icon;
  final VoidCallback onTap;
  const BuildSubMenuItemWg({
    super.key, 
    this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  State<BuildSubMenuItemWg> createState() => _BuildSubMenuItemWgState();
}

class _BuildSubMenuItemWgState extends State<BuildSubMenuItemWg> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32.0), // Indent submenu items
      child: ListTile(
        leading: Icon(widget.icon ?? Icons.add_circle_rounded, color: const Color(0xFF4A6057)),
        title: DefaultTextWg(text: widget.text),
        trailing: const Icon(Icons.chevron_right),
        onTap: widget.onTap,
      ),
    );
  }
}


class BuildToogleItemWg extends StatefulWidget {
  final IconData icon;
  final String text;
  final bool value;
  final ValueChanged<bool> onChanged;
  const BuildToogleItemWg({super.key,
    required this.icon,
    required this.text,
    required this.value,
    required this.onChanged,});

  @override
  State<BuildToogleItemWg> createState() => _BuildToogleItemWgState();
}

class _BuildToogleItemWgState extends State<BuildToogleItemWg> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(widget.icon, color: primaryColor),
      title: DefaultTextWg(text: widget.text),
      trailing: Switch(
        value: widget.value,
        onChanged: widget.onChanged,
        activeColor: primaryColor,
      ),
    );
  }
}