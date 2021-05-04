import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'dart:async';
import 'package:snake_game/food.dart';
import 'package:snake_game/snake.dart';
import 'package:snake_game/pixel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: Scaffold(
        backgroundColor: Colors.black,
        body: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static List<int> snakePosition = [45, 65, 85, 105, 125];
  static const int numberOfSquares = 700;
  static const int numberOfRows = 20;
  var direction = 'down';
  bool gameHasStarted = false;
  static var randomNumber = Random();
  int food = randomNumber.nextInt(500);
  void generteNewFood() {
    food = randomNumber.nextInt(500);
  }

  void startGame() {
    gameHasStarted = true;
    direction = 'down';
    snakePosition = [45, 65, 85, 105, 125];
    const duration = Duration(milliseconds: 250);
    Timer.periodic(duration, (timer) {
      updateSnake();
      if (gameOver()) {
        timer.cancel();
        print('game over');
        _showGameOverScreen();
      }
    });
  }

  void updateSnake() {
    setState(() {
      switch (direction) {
        case 'down':
          print('down');
          if (snakePosition.last > numberOfSquares - numberOfRows) {
            snakePosition
                .add(snakePosition.last + numberOfRows - numberOfSquares);
          } else {
            snakePosition.add(snakePosition.last + numberOfRows);
          }
          break;

        case 'up':
          print('up');
          if (snakePosition.last < numberOfRows) {
            snakePosition
                .add(snakePosition.last - numberOfRows + numberOfSquares);
          } else {
            snakePosition.add(snakePosition.last - numberOfRows);
          }
          break;

        case 'left':
          print('left');
          if (snakePosition.last % numberOfRows == 0) {
            snakePosition.add(snakePosition.last - 1 + numberOfRows);
          } else {
            snakePosition.add(snakePosition.last - 1);
          }
          break;
        case 'right':
          if ((snakePosition.last + 1) % numberOfRows == 0) {
            snakePosition.add(snakePosition.last + 1 - numberOfRows);
          } else {
            snakePosition.add(snakePosition.last + 1);
          }
          break;

        default:
      }
      if (snakePosition.last == food) {
        generteNewFood();
      } else {
        snakePosition.removeAt(0);
      }
    });
  }

  bool gameOver() {
    for (int i = 0; i < snakePosition.length; i++) {
      int count = 0;
      for (var j = 0; j < snakePosition.length; j++) {
        if (snakePosition[i] == snakePosition[j]) {
          count += 1;
        }
        if (count == 2) {
          return true;
        }
      }
    }
    return false;
  }

  _showGameOverScreen() {
    showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 4.0,
            title: Text('Game Over'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Score : ${snakePosition.length - 1}'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                  child: Text('Replay?'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    startGame();
                  }),
              TextButton(
                  child: Text('Exit'),
                  onPressed: () {
                    SystemNavigator.pop();
                  }),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onVerticalDragUpdate: (details) {
              if (direction != 'up' && details.delta.dy > 0) {
                direction = 'down';
              } else if (direction != 'down' && details.delta.dy < 0) {
                direction = 'up';
              }
            },
            onHorizontalDragUpdate: (details) {
              if (direction != 'left' && details.delta.dx > 0) {
                direction = 'right';
              } else if (direction != 'right' && details.delta.dx < 0) {
                direction = 'left';
              }
            },
            child: Container(
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: numberOfSquares,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: numberOfRows),
                itemBuilder: (BuildContext context, int index) {
                  if (snakePosition.contains(index)) {
                    return Snake();
                  }
                  if (index == food) {
                    return Food();
                  } else {
                    return Pixel();
                  }
                },
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                if (gameHasStarted == false) {
                  startGame();
                }
              },
              child: Text(
                's t a r t',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            Text(
              '<S n a k e> ',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
      ],
    );
  }
}
