import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
                  'Bingo Game',
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 20,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 51, 75, 41),
        ),

        body: Clover(),
        backgroundColor: const Color.fromARGB(255, 168, 210, 150),
      ),
    );
  }
}

class Clover extends StatefulWidget {  
  @override
  _CloverState createState() => _CloverState();
}

class _CloverState extends State<Clover> {
  // 5x5 크기의 bool 리스트 선언 (동그라미 유무를 나타냄)
  List<List<bool>> board = List.generate(5, (_) => List.filled(5, false));

  // 5x5 크기의 색상 리스트 선언 (동그라미의 색상 저장)
  List<List<String>> colors = List.generate(5, (_) => List.filled(5, ""));

  // 사용할 색상
  final List<String> _colors = [
    "Red",
    "Yellow",
    "Green",
    "Blue",
    "Purple",
    "White"
  ];

  // 다음에 사용할 색상
  String nextColor = "";  

  // 점수 변수
  int score = 0;

  // OverlayEntry 참조
  OverlayEntry? gameOverOverlay;

  // 랜덤 색상 선택 함수
  void _selectNextColor() {
    setState(() {
      nextColor = _colors[Random().nextInt(_colors.length)];
    });
  }

  // 박스 클릭 시 동그라미 상태 및 색상을 변경하는 함수
  void _onBoxTapped(int row, int col) {
    setState(() {
      if (!board[row][col]) {
        // 동그라미가 없을 때만 추가
        board[row][col] = true;
        colors[row][col] = nextColor; // 선택된 색상 사용
        score++; // 점수 증가
        _selectNextColor(); // 다음 사용할 색상 랜덤으로 선택

        // 한 줄이 완성되었는지 체크 후 제거
        _checkCompleteLine(row, col);

        // 모든 칸이 다 찼는지 체크
        if (_gameover()) {
          _showGameOver();
        }
      }
    });
  }

  // 게임 오버 확인 함수
  bool _gameover(){  
    for(int i =0; i<5; i++){
      for(int j = 0; j<5; j++){
        if(!board[i][j]){
          return false;
        }
      }
    }
    return true;
  }

  // 게임 오버 화면을 Overlay로 표시하는 함수
  void _showGameOver() {
    gameOverOverlay = OverlayEntry(
      builder: (context) => Positioned.fill(
        child: Container(
          color: Colors.black54, // 약간 투명한 검정 배경
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 게임 오버 텍스트
                const Positioned(                  
                  top: 200,                  
                  child: Text(
                    'Game Over',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // 재시작 버튼
                Positioned(
                  top: 300,
                  child: ElevatedButton(
                    onPressed: _restartGame, // 버튼 클릭 시 게임 재시작
                    child: const Text('Restart'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(gameOverOverlay!);
  }

  // 게임을 재시작하는 함수
  void _restartGame() {
    setState(() {
      // 보드 및 색상 초기화
      board = List.generate(5, (_) => List.filled(5, false));
      colors = List.generate(5, (_) => List.filled(5, ""));
      score = 0;
      _selectNextColor(); // 새로운 색상 선택
    });
    // 게임 오버 오버레이 제거
    gameOverOverlay?.remove();
  }

  // 가로, 세로 한 줄이 완성되었는지 체크하는 함수
  void _checkCompleteLine(int row, int col) {
    bool isRowComplete = true;
    bool isColComplete = true;

    String firstRowcolor = colors[row][0];
    String firstColcolor = colors[0][col];  

    // 가로줄 체크
    if (firstRowcolor != "") {      
      for (int i = 0; i < 5; i++) {              
        if(colors[row][i] != firstRowcolor || !board[row][i]){          
          isRowComplete = false;
          break;
        }
      }
    }else {
      isRowComplete = false;      
    }

    // 세로줄 체크
    if(firstColcolor != ""){
      for (int i = 0; i < 5; i++) {   
        if(colors[i][col] != firstColcolor || !board[i][col]){          
          isColComplete = false;
          break;
        }
      }
    }else {
      isColComplete = false;      
    }

    // 가로줄이 완성되었으면 해당 줄을 비움
    if (isRowComplete) {
      for (int i = 0; i < 5; i++) {
        board[row][i] = false;
        colors[row][i] = "";
      }
      score += 5;
    }

    // 세로줄이 완성되었으면 해당 줄을 비움
    if (isColComplete) {      
      for (int i = 0; i < 5; i++) {
        board[i][col] = false;
        colors[i][col] = "";
      }
      score += 5;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    _selectNextColor();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,     
      crossAxisAlignment: CrossAxisAlignment.center,

      children: [     
        SizedBox( height: 10 ),
        SizedBox(
          width: 250,
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            
            children: [
              // 점수판 
              SizedBox(
                height: 50,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,                  
                  
                  children: [
                    Text(
                      'SCORE',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),

                    SizedBox(height: 5),
                    
                    Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                        Text(
                          '$score',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
               
              //Next 마커
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [                    
                  const Text(
                    'Next',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                  
                  const SizedBox(height: 10),
              
                  Container(
                    width: 49,
                    height: 49,
                    //padding: const EdgeInsets.all(1),
                    //clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      //color: Colors.brown[300],
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/$nextColor.png'),
                              fit: BoxFit.fitHeight,
                              onError: (exception, stackTrace) {
                                print('Failed to load image for color: $nextColor');
                              },
                            ),
                            
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // 5x5 보드판
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (row) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (col) {
                    return GestureDetector(
                      onTap: () => _onBoxTapped(row, col),
                      child: Container(
                        width: 47,  // 박스의 너비
                        height: 47, // 박스의 높이
                        margin: EdgeInsets.all(3), // 박스 간 간격
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 95, 79, 73),
                          borderRadius: BorderRadius.circular(10),         
                                           
                        ),
                        child: Center(
                          child: board[row][col]
                            ? Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                  image: AssetImage('assets/${colors[row][col]}.png'),
                                  fit: BoxFit.fitHeight,                                  
                                    onError: (exception, stackTrace) {
                                      print('Failed to load image for color: ${colors[row][col]}');
                                    },
                                ),
                              ),
                            )
                            : null,  // 마커가 없을 때
                        ),
                      ),
                    );
                  }),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
