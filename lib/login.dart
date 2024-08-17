import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/home_screen.dart';
import 'package:flutter_application_1/main.dart';
import 'package:email_validator/email_validator.dart';
import 'backend.dart';

Map<String, String> userFields = {
  "Username": "",
  "Password": "",
  "Email": "",
  "PhoneNumber": "",
  "DOB": "",
};
List<User> appUsers = [];
int userIndex = 0;

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'Login or join us today\n',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          ),
          Container(
            height: 100,
            width: 300,
            // padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
            child: UsernameWidget(
              entryText: 'Username',
              loginType: 1,
            ),
          ),
          Container(
              height: 120,
              width: 300,
              // padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
              child: PasswordWidget(
                entryText: 'Password',
                loginType: 1,
              )),
          TextButton(
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen())),
            child: Text(
              "LOGIN",
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUpScreen())),
            child: Text(
              "SIGN UP",
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '\nCreate your account for free.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(0, 255, 204, 1.0),
              ),
            ),
            Container(
              height: 100,
              width: 300,
              child: UsernameWidget(
                entryText: 'Username',
                loginType: 0,
              ),
            ),
            Container(
              height: 100,
              width: 300,
              child: PasswordWidget(
                entryText: 'Password',
                loginType: 0,
              ),
            ),
            Container(
              height: 100,
              width: 300,
              child:
                  PasswordWidget(entryText: 'Re-enter password', loginType: 2),
            ),
            Container(
              height: 100,
              width: 300,
              child: EmailWidget(
                entryText: 'Email',
              ),
            ),
            Container(
              height: 100,
              width: 300,
              child: NumberEntryWidget(),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              width: 150,
              child: TextButton(
                onPressed: () {
                  appUsers.add(User(
                      username: userFields['Username']!,
                      password: userFields['Password']!,
                      email: userFields['Email']!,
                      dateOfBirth: DateTime.now(),
                      phoneNumber: userFields['PhoneNumber']!));
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  shape: RoundedRectangleBorder(),
                ),
                child: Text(
                  "SIGN UP",
                  style: TextStyle(
                    fontSize: 18,
                    // fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 21, 192, 138),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UsernameWidget extends StatefulWidget {
  final String entryText;
  final int loginType;
  const UsernameWidget({
    Key? key,
    required this.entryText,
    required this.loginType,
  }) : super(key: key);

  @override
  State<UsernameWidget> createState() => _UsernameWidgetState();
}

class _UsernameWidgetState extends State<UsernameWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  bool _isError = false;
  bool isAlphaNumeric(String input) {
    final RegExp alphaNumeric = RegExp(r'^[a-zA-Z0-9]+$');
    return alphaNumeric.hasMatch(input);
  }

  String _validateInput(String value, int flag) {
    if (value.isEmpty) {
      return "Username cannot be empty";
    } else if (isAlphaNumeric(value) == false) {
      return "Username can only contain letters and numbers.";
    } else if (value.length >= 15) {
      return "Too many characters";
    } else if (flag == 0) {
      for (User userIterator in appUsers) {
        if (userIterator.username == value) {
          return "Username already exists";
        }
      }
    } else if (flag == 1) {
      int temp = 0;
      for (User userIterator in appUsers) {
        if (userIterator.username == value) {
          userIndex = temp;
          return "Present";
        }
        temp++;
      }
      return "Username does not exist";
    }
    // check if username exists in database
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextFormField(
          controller: _textEditingController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: widget.entryText,
            prefixIcon: Icon(Icons.account_box_rounded),
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]'))
          ],
          onChanged: (value) {
            setState(() {
              if (widget.loginType == 0) {
                _isError = _validateInput(value, 0).isNotEmpty;
                if (_isError == false) userFields['Username'] = value;
              } else {
                _isError = (_validateInput(value, 1) != "Present");
                userFields['Username'] = value;
              }
            });
          },
        ),
        if (_isError)
          Visibility(
            visible: _isError,
            child: Container(
                child: Text(
              _validateInput(_textEditingController.text, widget.loginType),
              style: TextStyle(
                color: Colors.red,
                fontSize: 10,
              ),
              textAlign: TextAlign.start,
            )),
          ),

        // if (_validateInput(_textEditingController.text) != "")
        //   Text(_validateInput(_textEditingController.text)),
      ],
    );
  }
}

class PasswordWidget extends StatefulWidget {
  final String entryText;
  final int loginType;
  const PasswordWidget({
    Key? key,
    required this.entryText,
    required this.loginType,
  }) : super(key: key);

  @override
  State<PasswordWidget> createState() => _PasswordWidgetState();
}

class _PasswordWidgetState extends State<PasswordWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  bool _isError = false;
  bool _isObscure = true;
  bool hasSpecialCharacters(String password) {
    final RegExp specialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    return specialChar.hasMatch(password);
  }

  String _validateInput(String value, int flag) {
    String curr_pwd = "";
    for (User userIterator in appUsers) {
      if (userIterator.username == userFields['Username']) {
        curr_pwd = userIterator.password;
      }
    }
    if (flag != 2) {
      if (value.isEmpty) {
        return "Password cannot be empty";
      } else if (hasSpecialCharacters(value) == false) {
        return "Password must contain atleast one special character";
      } else if (value.length >= 15) {
        return "Too many characters";
      } else if (flag == 1) {
        if (curr_pwd != value) {
          return "Password is not correct";
        }
      }
    } else {
      if (value != userFields['Password']) {
        return "Password does not match";
      }
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextFormField(
          controller: _textEditingController,
          obscureText: _isObscure,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: widget.entryText,
            suffixIcon: IconButton(
              icon: Icon(!_isObscure ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                });
              },
            ),
          ),
          onChanged: (value) {
            setState(() {
              if (widget.loginType != 2) {
                _isError = (_validateInput(value, widget.loginType).isNotEmpty);
                if (widget.loginType == 0) {
                  if (_isError == false) userFields['Password'] = value;
                }
              } else {
                _isError = (_validateInput(value, widget.loginType) ==
                    'Password does not match');
              }
            });
          },
        ),
        if (_isError)
          Visibility(
            visible: _isError,
            child: Container(
                child: Text(
              _validateInput(_textEditingController.text, widget.loginType),
              style: TextStyle(
                color: Colors.red,
                fontSize: 10,
              ),
              // textAlign: TextAlign.start,
            )),
          ),
      ],
    );
  }
}

class ConfirmPasswordWidget extends StatefulWidget {
  final String entryText;
  const ConfirmPasswordWidget({
    Key? key,
    required this.entryText,
  }) : super(key: key);

  @override
  State<ConfirmPasswordWidget> createState() => _ConfirmPasswordWidgetState();
}

class _ConfirmPasswordWidgetState extends State<ConfirmPasswordWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Flexible(
          child: TextFormField(
            controller: _textEditingController,
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: widget.entryText,
            ),
            onChanged: (value) {
              setState(() {
                if (value != userFields['Password']) {
                  print("Error");
                }
              });
            },
          ),
        ),
      ],
    );
  }
}

class EmailWidget extends StatefulWidget {
  final String entryText;
  const EmailWidget({
    Key? key,
    required this.entryText,
  }) : super(key: key);

  @override
  State<EmailWidget> createState() => _EmailWidgetState();
}

class _EmailWidgetState extends State<EmailWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  bool _isNotValid = false;
  String _validateInput(String value) {
    if (value.isEmpty) {
      return "Email cannot be empty";
    } else if (EmailValidator.validate(value) == false) {
      return "Email invalid";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextFormField(
          controller: _textEditingController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: widget.entryText,
            prefixIcon: Icon(Icons.email),
          ),
          onChanged: (value) {
            setState(() {
              _isNotValid = _validateInput(value).isNotEmpty;
              if (!_isNotValid) {
                userFields['Email'] = value;
              }
            });
          },
        ),
        if (_isNotValid)
          Visibility(
            visible: _isNotValid,
            child: Container(
                child: Text(
              _validateInput(_textEditingController.text),
              style: TextStyle(
                color: Colors.red,
                fontSize: 10,
              ),
              // textAlign: TextAlign.start,
            )),
          ),
      ],
    );
  }
}

class NumberEntryWidget extends StatefulWidget {
  const NumberEntryWidget({super.key});

  @override
  State<NumberEntryWidget> createState() => _NumberEntryWidgetState();
}

class _NumberEntryWidgetState extends State<NumberEntryWidget> {
  bool _isError = false;
  TextEditingController _textEditingController = TextEditingController();
  String _validateInput(String value) {
    if (value.isEmpty) {
      return "Phone number cannot be empty";
    } else if (value.length != 10) {
      return "Phone number must have 10 digits";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextFormField(
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          decoration: InputDecoration(
            labelText: 'Enter phone number',
            border: OutlineInputBorder(),
            prefixText: "+91",
          ),
          onChanged: (value) {
            setState(() {
              _isError = _validateInput(value).isNotEmpty;
              if (_isError == false) userFields['PhoneNumber'] = value!;
            });
          },
        ),
        if (_isError)
          Visibility(
            visible: _isError,
            child: Container(
                child: Text(
              _validateInput(_textEditingController.text),
              style: TextStyle(
                color: Colors.red,
                fontSize: 10,
              ),
              // textAlign: TextAlign.start,
            )),
          ),
      ],
    );
  }
}
