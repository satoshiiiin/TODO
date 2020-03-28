import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/animated_focus_light.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO_APP',
      home: Todo()
    );
  }
}

class Todo extends StatefulWidget{
  @override
  TodoState createState() => TodoState();
}

class TodoState extends State<Todo>{

  List<String> _content = [];
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<TargetFocus> targets = List();

  GlobalKey forcasAddButton = GlobalKey();
  GlobalKey forcasField = GlobalKey();

  @override
  void initState(){
    addTarget();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyTask'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.help),
            onPressed: () => showTutorial())
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Container(
              // 入力フォーム
              child: TextFormField(
                key: forcasField,
                validator: (value) => value.isEmpty ? 'タスクを入力してください' : null,
                controller: _controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'TODO',
                  suffixIcon: RaisedButton(
                    key: forcasAddButton,
                    color: Colors.lightBlue,
                    shape: CircleBorder(),
                    onPressed: () => _formKey.currentState.validate() ? editText() : null,
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              // タスクリスト
              child: ListView.builder(
                itemCount: _content.length,
                itemBuilder: (context, index){
                  return Card(
                    elevation: 4,
                    child: ListTile(
                      title: Text(_content[index]),
                      leading: IconButton(
                        icon: Icon(Icons.check_circle_outline),
                        onPressed: () => setState(() => _content.removeAt(index)),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  // フォーカスしたときに表示されるテキストやテキストの位置を
  // 指定したTargetFocusWidgetをtargetsに追加
  void addTarget(){
    targets.add(
      TargetFocus(
        identify: "Target 1",
        keyTarget: forcasField,
        contents: [
          ContentTarget(
            align: AlignContent.bottom,
            child: Text(
              'タスクを入力することができます',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20.0
              ),
            ),
          ),
        ],
        shape: ShapeLightFocus.RRect,
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 2",
        keyTarget: forcasAddButton,
        contents: [
          ContentTarget(
            align: AlignContent.bottom,
            child: Text(
              'タスクを追加することができます',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20.0
              ),
            ),
          ),
        ],
      ),
    );
  }

  void editText(){
    setState(() {
    _content.add(_controller.text);
    _controller.clear();
    });
  }
  // addTarget()で追加したtargetsを表示
  void showTutorial() {
    TutorialCoachMark(
      context,
      targets: targets,
      colorShadow: Colors.red,
      finish: () => print('finish'),
      clickTarget: (target) => print(target),
      clickSkip: () => print('skip'),  
    )..show();
  }
}