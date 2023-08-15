import 'dart:convert';

import 'secrets.dart';
import 'package:http/http.dart' as http;

class OpenAiService{


  final List<Map<String, String>> messages = [];
  Future <String> isArtPromptAPI(String prompt) async{
    try{
      final res=await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers : {
          'Content-type':'application/json',
           'Authorization':'Bearer $OpenAiApiKey',
        },
        body:jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {
              'role': 'user',
              'content':
              'Does this message want to generate an AI picture, image, art or anything similar? $prompt . Simply answer with a yes or no.',
            }
          ],
        })
      );
      print(res.body);
      if(res.statusCode==200){
        String content =
        jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim();

        switch (content) {
          case 'Yes':
          case 'yes':
          case 'Yes.':
          case 'yes.':
            final res = await dalle(prompt);
            return res;
          default:
            final res = await chatGPT(prompt);
            return res;
        }
      }

    }
        catch(e){
      print(e);
        }
    return 'an error occured';

  }
  Future <String> chatGPT(String prompt) async{

    messages.add({
      'role': 'user',
      'content': prompt,
    });
    try {
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $OpenAiApiKey',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": messages,
        }),
      );

      if (res.statusCode == 200) {
        String content =
        jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim();

        messages.add({
          'role': 'assistant',
          'content': content,
        });
        return content;
      }
      return 'An internal error occurred';
    } catch (e) {
      return e.toString();
    }


  }
  Future <String> dalle(String prompt) async{

    messages.add({
      'role': 'user',
      'content': prompt,
    });
    try {
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/images/generations'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $OpenAiApiKey',
        },
        body: jsonEncode({
          'prompt': prompt,
          'n': 1,
        }),
      );

      if (res.statusCode == 500) {
        String imageUrl = jsonDecode(res.body)['data'][0]['url'];
        imageUrl = imageUrl.trim();

        messages.add({
          'role': 'assistant',
          'content': imageUrl,
        });
        return imageUrl;
      }
      return 'An internal error occurred';
    } catch (e) {
      return e.toString();
    }

  }
}