import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Student {
  final int id;
  final String firstName;
  final String lastName;
  final String gender;
  final String dateOfBirth;

  Student({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.dateOfBirth,
  });

// Convert a Student into a Map. The keys must correspond to the names of the
// columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstname': firstName,
      'lastname': lastName,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
    };
  }

// Implement toString to make it easier to see information about
  // each students when using the print statement.
  @override
  String toString() {
    return 'Dog{id: $id, fistname: $firstName, lastname: $lastName, gender: $gender, dateOfBirth: $dateOfBirth}';
  }
}

// async function to open the database
Future<Database> database() async {
  // Get a location using getDatabasesPath
  final path = await getDatabasesPath();
  // Open the database at a given path
  return openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(path, 'mydb.db'),

    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );
}

// Define a function that inserts dogs into the database
Future<void> insertStudent(Student student) async {
  // Get a reference to the database.
  final db = await database();

  // Insert the Dog into the correct table. You might also specify the
  // `conflictAlgorithm` to use in case the same dog is inserted twice.
  //
  // In this case, replace any previous data.
  await db.insert(
    'students',
    student.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Form Validation Demo';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: const MyCustomForm(),
      ),
    );
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
// Create a text controller and use it to retrieve the current value
  // of the TextField.
  final myController = TextEditingController();
  final myController1 = TextEditingController();

  //String? gender; //no radio button will be selected
  String gender = "male"; //if you want to set default value

  TextEditingController dateInput = TextEditingController();
  @override
  void initState() {
    dateInput.text = ""; //set the initial value of text field

    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    dateInput.dispose();
    super.dispose();
  }

  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 50.0),
      margin: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),

      // border-radius

      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: myController,
                  decoration: const InputDecoration(
                    // border input with white color
                    border: OutlineInputBorder(),

                    hintText: 'Enter your first name',
                    labelText: 'First Name',
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a first name';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: myController1,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your last name',
                    labelText: 'Last Name',
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
              ),
              Column(
                children: [
                  RadioListTile(
                    title: Text("Male"),
                    value: "male",
                    groupValue: gender,
                    onChanged: (value) {
                      setState(() {
                        gender = value.toString();
                      });
                    },
                  ),
                  RadioListTile(
                    title: Text("Female"),
                    value: "female",
                    groupValue: gender,
                    onChanged: (value) {
                      setState(() {
                        gender = value.toString();
                      });
                    },
                  ),
                  RadioListTile(
                    title: Text("Other"),
                    value: "other",
                    groupValue: gender,
                    onChanged: (value) {
                      setState(() {
                        gender = value.toString();
                      });
                    },
                  )
                ],
              ),

              // date picker
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: dateInput,

                  //editing controller of this TextField
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      icon: Icon(Icons.calendar_today), //icon of text field
                      labelText: "Date of birth" //label text of field
                      ),
                  readOnly: false,
                  //set it true, so that user will not able to edit text
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1950),

                        //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(2100));

                    if (pickedDate != null) {
                      print(
                          pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                      print(
                          formattedDate); //formatted date output using intl package =>  2021-03-16
                      setState(() {
                        dateInput.text =
                            formattedDate; //set output date to TextField value.
                      });
                    } else {}
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  // padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                      // size of the button
                      minimumSize:
                          MaterialStateProperty.all<Size>(Size(100, 50)),
                    ),
                    onPressed: () async {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              // Retrieve the text the user has entered by using the
                              // TextEditingController.
                              title: Text(
                                'Your Information',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                              contentTextStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                              content: Text(
                                // ignore: prefer_interpolation_to_compose_strings
                                'First Name: ${myController.text}' +
                                    " \n" +
                                    'Last Name: ${myController1.text}' +
                                    " \n" +
                                    'gender: ${gender}' +
                                    " \n" +
                                    'Date of Birth: ${dateInput.text}',
                              ),
                              //
                            );
                          },
                        );

                        // insert data to database with flutter and sqflite
                        //var fido = Student(
                        // id: 0,
                        //firstName: myController.text,
                        //lastName: myController1.text,
                        // gender: gender,
                        // dateOfBirth: dateInput.text,
                        //);

                        // Insert a student into the database.
                        // await insertStudent(fido);

                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
