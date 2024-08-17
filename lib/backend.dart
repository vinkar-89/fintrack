import 'dart:ffi';

import 'package:flutter_application_1/login.dart';

class Transaction {
  String date;
  String amount;
  String category;
  String purpose;
  String description;
  int isExpenseFlag;
  Transaction(
      {required this.date,
      required this.amount,
      required this.category,
      required this.purpose,
      required this.description,
      required this.isExpenseFlag});
}

class User {
  String username;
  String password;
  String email;
  String phoneNumber;
  DateTime dateOfBirth;
  List<Transaction> transactionList;
  double income;
  double expense;
  User({
    required this.username,
    required this.password,
    required this.email,
    required this.phoneNumber,
    required this.dateOfBirth,
    this.expense = 0,
    this.income = 0,
    List<Transaction>? transactionList,
  }) : this.transactionList = transactionList ?? [];

  //User credential methods
  void updateUsername(String usernameArg) {
    username = usernameArg;
  }

  void updatePassword(String passwordArg) {
    password = passwordArg;
  }

  void updatePhoneNumber(String phoneNumberArg) {
    phoneNumber = phoneNumberArg;
  }

  void updateDateOfBirth(DateTime dateArg) {
    dateOfBirth = dateArg;
  }

  void updateEmail(String emailArg) {
    email = emailArg;
  }

  //Transaction methods
  void updateTransaction(
    Transaction newTransaction,
  ) {
    if (newTransaction.isExpenseFlag == 1) {
      expense += double.parse(newTransaction.amount);
      transactionList.add(newTransaction);
    } else {
      income += double.parse(newTransaction.amount);
      transactionList.add(newTransaction);
    }
  }

  User returnUser(String username) {
    for (User userIterator in appUsers) {
      if (userIterator.username == username) {
        return userIterator;
      }
    }
    return User(
        username: "",
        password: "",
        email: "",
        dateOfBirth: DateTime.now(),
        phoneNumber: "");
  }

  double displayBalance() {
    return (income >= expense) ? income - expense : 0.0;
  }

  int amountPerCategory(String category) {
    int amount = 0;
    for (Transaction iterator in transactionList) {
      if (iterator.category == category) {
        amount += int.parse(iterator.amount);
      }
    }
    return amount;
  }
}
