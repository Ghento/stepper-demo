import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:stepper/recipe.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Stepper Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentStep = 0;
  bool complete = false;

  CountDownController _controller = CountDownController();

  final List<Instruction> instruction = [
    Instruction(1, 'Melt Chees', 20),
    Instruction(2, 'Cook mince', 10),
    Instruction(3, 'Mix cheese and mince in oven', 14),
    Instruction(4, 'Leave the mixture to cool down', 5),
  ];

  next() {
    _currentStep + 1 != instruction.length
        ? goTo(_currentStep + 1)
        : setState(() => complete = true);
  }

  goTo(int step) {
    setState(() => _currentStep = step);
  }

  cancel() {
    if (_currentStep > 0) {
      goTo(_currentStep - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    Recipe recipe = Recipe('Lasagne', 30, 4, instruction);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          complete
              ? Expanded(
                  child: Center(
                  child: AlertDialog(
                    title: Text('Cooking'),
                    content: Text('Completed!!!'),
                    actions: [
                      FlatButton(
                        child: Text('Close'),
                        onPressed: () {
                          setState(() {
                            complete = false;
                          });
                        },
                      )
                    ],
                  ),
                ))
              : Stepper(
                  steps: _createSteps(_currentStep, recipe),
                  currentStep: _currentStep,
                  onStepContinue: next,
                  onStepCancel: cancel,
                  onStepTapped: (step) => goTo(step),
                ),
        ],
      ),
    );
  }

  _button({required String title, VoidCallback? onPressed}) {
    return Expanded(
        child: RaisedButton(
      child: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      onPressed: onPressed,
      color: Colors.purple,
    ));
  }

  _createSteps(int _currentStep, Recipe recipe) {
    List<Step> recipeSteps = [];

    for (var i = 0; i < recipe.instruction.length; i++) {
      recipeSteps.add(
        Step(
          title: Text('Step ' + recipe.instruction[i].step.toString()),
          isActive: _currentStep >= 0,
          state: _currentStep >= i ? StepState.complete : StepState.disabled,
          content: Align(
            alignment: Alignment.topLeft,
            child: Container(
              color: Colors.red,
              child: Column(
                children: [
                  Text(recipe.instruction[i].description),
                  /*SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      _button(
                          title: 'Start', onPressed: () => _controller.start()),
                      CircularCountDownTimer(
                          controller: _controller,
                          autoStart: false,
                          width: 50,
                          height: 50,
                          duration: recipe.instruction[i].duration,
                          fillColor: Colors.blueGrey,
                          ringColor: Colors.red),
                    ],
                  )*/
                ],
              ),
            ),
          ),
        ),
      );
    }

    return recipeSteps;
  }
}
