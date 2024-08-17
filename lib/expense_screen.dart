import 'package:flutter/material.dart';
import 'package:flutter_application_1/home_screen.dart';
import 'backend.dart';
import 'login.dart';

class AddExpenseScreen extends StatelessWidget {
  const AddExpenseScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // List<String> paramsTransac = [];
    Map<String, String> paramsTransac = {
      'Enter amount here': 'Nill',
      'Enter date of transaction - DD/MM/YYYY': 'Nill',
      'Enter receiver/purpose': 'Nill',
      'Enter category': 'Nill',
      'Description': 'Nill',
      'IncomeOrExpense': '0',
    };
    List<String> categoryMap = [
      'Eatables',
      'Utilities',
      'Transportation',
      'Subscriptions',
      'Entertainment',
      'Healthcare',
      'Shopping',
      'Other'
    ];
    final TextEditingController _textEditingControllerOld =
        TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 204, 199, 199),
        title: Text(
          'Expenses',
          style: TextStyle(color: Color(0xFF00e0b0)),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          TextfieldWidget(
            printText: 'Enter amount here',
            tranList: paramsTransac,
            icon: Icons.currency_rupee,
            isSuffixIcon: true,
          ),
          // TextfieldWidget(
          //   printText: 'Enter date of transaction - DD/MM/YYYY',
          //   tranList: paramsTransac,
          //   icon: Icons.date_range,
          // ),
          DatePickerWidget(listArgument: paramsTransac),
          DropdownMenu(
            argList: categoryMap,
            argMap: paramsTransac,
          ),
          TextfieldWidget(
            printText: 'Enter receiver/purpose',
            tranList: paramsTransac,
            icon: Icons.send_to_mobile_rounded,
          ),
          TextfieldWidget(
            printText: 'Description',
            tranList: paramsTransac,
            icon: Icons.notes_rounded,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                // padding: EdgeInsets.fromLTRB(100, 15, 100, 15),
                child: FloatingActionButton.extended(
                  backgroundColor: Colors.cyan,
                  icon: Icon(
                    Icons.ac_unit,
                  ),
                  label: Text(
                    'Reset',
                  ),
                  onPressed: () {
                    _textEditingControllerOld.clear();
                  },
                ),
              ),
              FloatingActionButton.extended(
                backgroundColor: Colors.cyan,
                label: Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.amberAccent,
                  ),
                ),
                onPressed: () {
                  Transaction currTransaction = Transaction(
                    amount: paramsTransac['Enter amount here']!,
                    date: paramsTransac[
                                'Enter date of transaction - DD/MM/YYYY'] !=
                            null
                        ? paramsTransac[
                            'Enter date of transaction - DD/MM/YYYY']!
                        : 'Nill',
                    category: paramsTransac['Enter category']!,
                    purpose: paramsTransac['Enter receiver/purpose']!,
                    description: paramsTransac['Description']!,
                    isExpenseFlag: int.parse(paramsTransac['IncomeOrExpense']!),
                  );
                  currentUser.updateTransaction(currTransaction);
                  String am = currentUser.transactionList[0].amount +
                      currentUser.transactionList[0].category +
                      currentUser.transactionList[0].date +
                      currentUser.transactionList[0].description +
                      currentUser.transactionList[0].purpose;
                  print("check $am");
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class IconToggleWidget extends StatefulWidget {
  final Map<String, String> mapArgument;
  IconToggleWidget({Key? key, required this.mapArgument});

  @override
  State<IconToggleWidget> createState() => _IconToggleWidgetState();
}

class _IconToggleWidgetState extends State<IconToggleWidget> {
  bool _isToggled = false;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon:
          (_isToggled) ? Icon(Icons.arrow_upward) : Icon(Icons.arrow_downward),
      onPressed: () {
        setState(() {
          _isToggled = !_isToggled;
          widget.mapArgument['IncomeOrExpense'] = (_isToggled) ? '1' : '0';
        });
      },
    );
  }
}

class TextfieldWidget extends StatefulWidget {
  final String printText;
  final Map<String, String> tranList;
  final IconData icon;
  bool isSuffixIcon = false;
  TextfieldWidget(
      {Key? key,
      required this.printText,
      required this.tranList,
      required this.icon,
      this.isSuffixIcon = false})
      : super(key: key);

  @override
  State<TextfieldWidget> createState() => _TextfieldWidgetState();
}

class _TextfieldWidgetState extends State<TextfieldWidget> {
  TextEditingController _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 200,
          child: TextField(
            controller: _textEditingController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: widget.printText,
              prefixIcon: Icon(widget.icon),
            ),
            keyboardType: TextInputType.text,
            onChanged: (text) {
              setState(() {
                Text(text);
                // widget.tranList.add(text);
                widget.tranList[widget.printText] = text;
              });
            },
          ),
          // padding
        ),
        // SizedBox(
        //   width: 5,
        // ),
        Visibility(
          visible: widget.isSuffixIcon,
          child: IconToggleWidget(mapArgument: widget.tranList),
        )
      ],
    );
  }
}

class DateFieldWidget extends StatefulWidget {
  final String printText;
  DateFieldWidget({Key? key, required this.printText}) : super(key: key);
  @override
  State<DateFieldWidget> createState() => _DateFieldWidgetState();
}

class _DateFieldWidgetState extends State<DateFieldWidget> {
  TextEditingController _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textEditingController,
      decoration: InputDecoration(
        labelText: widget.printText,
        border: OutlineInputBorder(),
      ),
      onChanged: (value) {
        //
      },
    );
  }
}

class DropdownMenu extends StatefulWidget {
  final List<String> argList;
  final Map<String, String> argMap;
  const DropdownMenu({Key? key, required this.argList, required this.argMap})
      : super(key: key);

  @override
  State<DropdownMenu> createState() => _DropdownMenuState();
}

class _DropdownMenuState extends State<DropdownMenu> {
  // final TextEditingController textEditingController = TextEditingController();
  String? selectedValue;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      child: DropdownButton<String>(
        value: selectedValue,
        onChanged: (String? newValue) {
          setState(() {
            selectedValue = newValue;
            widget.argMap['Enter category'] = selectedValue!;
          });
        },
        hint: Text('Select Category'),
        items: widget.argList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}

class DatePickerWidget extends StatefulWidget {
  final Map<String, String> listArgument;
  DatePickerWidget({Key? key, required this.listArgument});

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2024),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        widget.listArgument['Enter date of transaction - DD/MM/YYYY'] =
            '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Text(
          //   'Selected Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
          //   style: TextStyle(fontSize: 20),
          // ),
          // SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _selectDate(context),
            child: Text(
              'Date of Transaction: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
              style: TextStyle(fontSize: 15),
            ),
            // Text('Select Date of Transaction'),
          ),
        ],
      ),
    );
  }
}
