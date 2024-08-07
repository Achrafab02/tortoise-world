import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IntegerPickerWidget extends StatefulWidget {
  final String title;
  final int minValue;
  final int maxValue;
  final int initialValue;
  final ValueChanged<int> onChanged;

  const IntegerPickerWidget({
    required this.title,
    required this.minValue,
    required this.maxValue,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<IntegerPickerWidget> createState() => _IntegerPickerWidgetState();
}

class _IntegerPickerWidgetState extends State<IntegerPickerWidget> {
  @override
  void initState() {
    _controller.text = "${widget.initialValue}";
    super.initState();
  }

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Text(
            widget.title,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        Container(
          width: 60.0,
          foregroundDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(
              color: Colors.lightGreen,
              width: 2.0,
            ),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: TextFormField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(8.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(color: Colors.lightGreen),
                    ),
                  ),
                  controller: _controller,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: false,
                    signed: true,
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              ),
              SizedBox(
                height: 38.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 0.5,
                            color: Colors.lightGreen,
                          ),
                        ),
                      ),
                      child: InkWell(
                        child: const Icon(
                          Icons.arrow_drop_up,
                          size: 18.0,
                        ),
                        onTap: () {
                          int value = int.parse(_controller.text);
                          if (value >= widget.minValue && value < widget.maxValue) {
                            setState(() {
                              value++;
                              _controller.text = (value).toString();
                              widget.onChanged.call(value);
                            });
                          }
                        },
                      ),
                    ),
                    InkWell(
                      child: const Icon(
                        Icons.arrow_drop_down,
                        size: 18.0,
                      ),
                      onTap: () {
                        int value = int.parse(_controller.text);
                        if (value > widget.minValue && value <= widget.maxValue) {
                          setState(() {
                            value--;
                            _controller.text = (value).toString();
                            widget.onChanged.call(value);
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
