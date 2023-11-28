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
      title: 'Todo App',
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
      home: const MyHomePage(title: 'Todo App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _todoController = TextEditingController();
  final List<String> _todos = [];
  late FocusNode _todoFocusNode;

  @override
  void initState() {
    super.initState();
    _todoFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _todoFocusNode.dispose();
    super.dispose();
  }

  void addTodo(val) {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your todo')),
      );
      _todoFocusNode.requestFocus();
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Adding: ${_todoController.text}')),
    );
    setState(() {
      _todos.add(val);
    });
    _todoController.clear();
    _todoFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ReorderableListView(
              header: Column(children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                          focusNode: _todoFocusNode,
                          controller: _todoController,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: 'Enter your todo',
                              suffixIcon: IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    addTodo(_todoController.text);
                                  })),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your todo';
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) {
                            addTodo(value);
                          }),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                )
              ]),
              children: <Widget>[
                for (final todo in _todos)
                  Dismissible(
                    key: ValueKey(todo),
                    background: Container(
                      color: Theme.of(context).colorScheme.error,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) {
                      setState(() {
                        _todos.remove(todo);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('$todo dismissed')),
                      );
                    },
                    child: ListTile(
                      key: ValueKey(todo),
                      title: Text(todo),
                      tileColor: Theme.of(context).colorScheme.surfaceVariant,
                    ),
                  )
              ],
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final String todo = _todos.removeAt(oldIndex);
                  _todos.insert(newIndex, todo);
                });
              })),
    );
  }
}
