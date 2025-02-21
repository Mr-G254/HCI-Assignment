import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';

class App extends StatefulWidget{
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App>{
  final SpeechToText speech = SpeechToText();
  final FlutterTts TTS = FlutterTts();
  bool available = false;
  String error = '';
  String status = '';
  bool listening = false;
  Color background = Colors.white;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialize();
  }

  void initialize()async{
    available = await speech.initialize(onError: (val) => error = val.errorMsg,onStatus: (val) => status = val);
  }

  void listen(){
    setState(() {
      listening = true;
    });

    if(available){
      speech.listen(onResult: (val){
        print(val.recognizedWords);
        if(val.recognizedWords == "red"){
          TTS.speak('Here is the red screen');

          setState(() {
            background = Colors.red;
            listening = false;
          });
        }else if(val.recognizedWords == "blue"){
          TTS.speak('Here is the blue screen');

          setState(() {
            background = Colors.blue;
            listening = false;
          });
        }else{
          setState(() {
            listening = false;
          });
        }

      });
    }else{
      print('Not available');
    }
  }

  void stopListen()async{
    await speech.stop();

    setState(() {
      listening = false;
    });
  }

  @override
  Widget build(BuildContext context){
    final window = Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: SafeArea(
            child: Visibility(
              visible: listening,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: const Text(
                  "Listening...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Times',
                      fontSize: 17,
                      color: Colors.black
                  ),
                ),
              ),
            ),
          )
        ),
        Expanded(
          child: GestureDetector(
            child: Container(
              padding: const EdgeInsets.all(30),
              alignment: Alignment.bottomCenter,
              child: IconButton(
                style: IconButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
                    fixedSize: const Size(80, 80),
                    highlightColor: Colors.grey.withOpacity(0.6)
                ),
                onPressed: (){
                },
                icon: const Icon(
                  Icons.mic_none,
                  size: 40,
                  color: Colors.black,
                )
              ),
            ),
            onLongPressDown: (val){
              listen();
            },
            onLongPressEnd: (val){
              stopListen();
            },
          )
        )
      ],
    );

    return Scaffold(
      backgroundColor: background,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.zero,
        child: window,
      ),
    );
  }

}