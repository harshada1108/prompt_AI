import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:prompt_ai/feature.dart';
import 'package:prompt_ai/openai_service.dart';
import 'package:prompt_ai/pallets.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts_web.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final fluttertts=FlutterTts();
  final OpenAiService openAiService =OpenAiService();
  final speechToText = SpeechToText();
  //final flutterTts = FlutterTts();
  String lastWords = '';
  String? generatedContent;
  String? generatedImageUrl;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSpeechToText();
    initTextToSpeech();

  }
  Future<void> initTextToSpeech() async {
    await fluttertts.setSharedInstance(true);
    setState(() {});
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  Future<void> systemSpeak(String content) async {
    await fluttertts.speak(content);
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
     fluttertts.stop();
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        leading: Icon(
          Icons.menu,
        ),
        title: Text(
          'PROMPT AI'
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
          Stack(
            children: [
              Center(
                child: Container(
                  height: 120,
                  width: 120,
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    color: Pallete.assistantCircleColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Container(
                height: 123,

                decoration:BoxDecoration(
                  image:DecorationImage(
                    image: AssetImage('assets/images/virtualAssistant.png'),
                  ),
                  shape: BoxShape.circle,

                )
                ,
              )

            ],
          ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 20,
              vertical: 10),
              child: Text(generatedContent==null? 'Good Morning ,What task can I do for you?':generatedContent!,
              style: TextStyle(
                fontFamily: 'Cera Pro',
                  fontSize: generatedContent==null? 20:18,
              ),),
              margin: EdgeInsets.symmetric(horizontal: 40).copyWith(
                top: 20
              ),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20).copyWith(
                  topLeft: Radius.zero,
                ),
                border: Border.all(
                  color: Pallete.borderColor,
                )
              ),
            ),

            SizedBox(height: 12,),
            if(generatedImageUrl!=null)
    Padding(
    padding: const EdgeInsets.all(10.0),
    child: ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: Image.network(generatedImageUrl!),
    ),
    ),


            Visibility(
              visible: generatedContent==null && generatedImageUrl==null,
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text('Here are few commands!',style: TextStyle(
                  fontFamily: 'Cera Pro',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),),

            ),
            ),
            FeaturedBox(color: Pallete.firstSuggestionBoxColor, HeaderText: 'ChatGPT', descriptiontext: 'A smarter way to stay organized and informed with ChatGPT'),
            FeaturedBox(color: Pallete.secondSuggestionBoxColor, HeaderText: 'Dall-E', descriptiontext: 'Get inspired and stay creative with your personal assistant powered by Dall-E'),
            FeaturedBox(color: Pallete.thirdSuggestionBoxColor, HeaderText: 'Smart Voice Assistant', descriptiontext:'Get the best of both worlds with a voice assistant powered by Dall-E and ChatGPT')

          ],

        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async {
          if(await speechToText.hasPermission && speechToText.isNotListening){
            startListening();
          }else if(speechToText.isListening){
            final speech=await openAiService.isArtPromptAPI(lastWords);
            if(speech.contains('https')){
              generatedContent=null;
              generatedImageUrl=await openAiService.dalle(lastWords);
              setState(() {

              });
            }else{
              generatedContent=speech;
              generatedImageUrl=null;
              setState(() {});
              await systemSpeak(speech);
            }
            await stopListening();
            print(speech);

          } else {
            initSpeechToText();
          }

        },
        backgroundColor: Pallete.firstSuggestionBoxColor,
        child: Icon(Icons.mic),
      ),

    );
  }
}
