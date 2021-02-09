import 'package:flutter/material.dart';

class DialogUtil {
  static Future<String> showStringInputDialog({
    BuildContext context,
    String initialVal,
    String title = 'Change value',
    String labelText = 'New Value',
    String hintText = 'e.g. val',
  }) {
    return showDialog<String>(
        context: context,
        builder: (context) {
          String value;
          return AlertDialog(
            title: Text(title),
            content: TextFormField(
              decoration: InputDecoration(
                labelText: labelText,
                hintText: hintText,
              ),
              initialValue: initialVal,
              onChanged: (newVal) => value = newVal,
            ),
            actions: [
              FlatButton(
                child: const Text('Cancel'),
                textColor: Colors.black.withOpacity(0.7),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                child: const Text('Done'),
                textColor: Colors.black.withOpacity(0.7),
                onPressed: () => Navigator.of(context).pop(value),
              ),
            ],
          );
        }
    );
  }

  static Future<bool> showDeleteDialog({
    BuildContext context,
    String title = 'Confirm Deletion',
    String prompt = 'Are you sure you want to delete this item?',
  }) {
    return showDialog<bool>(
        context: context,
        builder: (context) {
          String value;
          return AlertDialog(
            title: Text(title),
            content: Text(prompt),
            actions: [
              FlatButton(
                child: const Text('Cancel'),
                textColor: Colors.black.withOpacity(0.7),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              FlatButton(
                child: const Text('DELETE'),
                textColor: Colors.red,
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          );
        }
    );
  }

  static Future<double> showSliderInputDialog({
    BuildContext context,
    String title = "Change value",
    double min = 0,
    double max = 10,
    int divisions,
    double initialVal = 5,
  }) {
    return showDialog<double>(
        context: context,
        builder: (context) {
          double value;
          return AlertDialog(
            title: Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _SpecialSlider(
                  onValueChanged: (newVal) => value = newVal,
                  min: min,
                  max: max,
                  divisions: divisions ?? (((max - min) * 2).floor()),
                  initialVal: initialVal,
                ),
              ],
            ),
            actions: [
              FlatButton(
                child: const Text('Cancel'),
                textColor: Colors.black.withOpacity(0.7),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                child: const Text('Done'),
                textColor: Colors.black.withOpacity(0.7),
                onPressed: () => Navigator.of(context).pop(value),
              ),
            ],
          );
        }
    );
  }
}

class _SpecialSlider extends StatefulWidget {
  final Function onValueChanged;
  final double min;
  final double max;
  final int divisions;
  final double initialVal;

  const _SpecialSlider({Key key,
    @required this.onValueChanged,
    this.min,
    this.max,
    this.divisions,
    this.initialVal}) : super(key: key);

  @override
  __SpecialSliderState createState() => __SpecialSliderState();
}

class __SpecialSliderState extends State<_SpecialSlider> {
  double value;

  @override
  void initState() {
    value = widget.initialVal;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Slider(
      min: widget.min,
      max: widget.max,
      divisions: widget.divisions,
      value: value,
      onChanged: (newVal) {
        setState(() => value = newVal);
        widget.onValueChanged(newVal);
      },
      label: value.toString(),
    );
  }
}
