import 'package:flutter/material.dart';

class ListItem extends StatefulWidget {
  final String title;
  final String errorMsg;
  final bool error;
  final bool multiline;
  final Function onPress;
  final Widget child;
  const ListItem({
    Key? key,
    this.title = '',
    this.errorMsg = '',
    this.error = false,
    this.multiline = false,
    required this.onPress,
    required this.child,
  }) : super(key: key);

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Ink(
          //alignment: Alignment.center,
          padding: const EdgeInsets.all(5),
          height: widget.multiline ? 100 : 57.0,
          width: 300,

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: widget.error ? Colors.red : Colors.transparent,
            ),
            color: Theme.of(context).cardColor,
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5.0,
                offset: Offset(0.0, 3.0),
              )
            ],
          ),
          child: InkWell(
            onTap: () => widget.onPress(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(child: widget.child),
              ],
            ),
          ),
        ),
        Visibility(
          visible: widget.error,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.errorMsg,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
