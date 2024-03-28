import 'package:flutter/material.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyMaterialApp(),
    );
  }
}

class MyAppBar extends StatelessWidget {
  String title;
  MyAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title);
  }
}

class Counter extends StatefulWidget {
  const Counter({super.key});

  @override
  State<Counter> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Counter> {
  int count = 0;
  void increment() {
    setState(() {
      count++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("You have pushed $count times"),
        ElevatedButton(onPressed: increment, child: Text("Increment"))
      ],
    );
  }
}

class LayoutExamples extends StatelessWidget {
  const LayoutExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 600,
          color: Colors.purple,
          child: Center(
              child: (Container(
            height: 100,
            color: Colors.blue,
            child: Text("Example"),
            alignment: Alignment.center,
          ))),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("test 1"),
            Text("test 2"),
            Text("test 3"),
            Text("test 4"),
          ],
        )
      ],
    );
  }
}

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "My app",
      theme: ThemeData(
    useMaterial3: true,

    // Define the default brightness and colors.
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.purple,
      // ···
      brightness: Brightness.dark,
    ),

    // Define the default `TextTheme`. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    textTheme: TextTheme(
      displayLarge: const TextStyle(
        fontSize: 72,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
        home: LoginPage());
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Prijavi se")),
      body: Center(
        child: Container(
          width: 400,
          constraints: BoxConstraints(maxWidth: 400, maxHeight: 400),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Image.network(
                      "https://www.fit.ba/content/public/images/og-image.jpg",
                      height: 100,
                      width: 100),
                  TextField(
                    decoration: InputDecoration(
                        labelText: "Email", prefixIcon: Icon(Icons.email)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: Icon(Icons.password)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(onPressed: () {}, child: Text("Prijavi se")),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
