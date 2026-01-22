import 'package:flutter/material.dart';
import 'package:flutter_chit_chat/models/mesaj.dart';
import 'package:flutter_chit_chat/viewmodels/chat_viewmodel.dart';
import 'package:provider/provider.dart';

class SohbetPage extends StatefulWidget {
  const SohbetPage({super.key});

  @override
  State<SohbetPage> createState() => _SohbetPageState();
}

class _SohbetPageState extends State<SohbetPage> {
  TextEditingController textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() async{
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 25) {
        await Provider.of<ChatViewmodel>(context, listen: false).eskiMesajlariYukle();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ChatViewmodel chatViewmodel = Provider.of<ChatViewmodel>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Sohbet')),
      body: Center(
        child: Column(
          children: <Widget>[
            buildMessageList(),
            Container(
              padding: EdgeInsets.only(bottom: 24, left: 8, right: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: textEditingController,
                      readOnly: false,
                      cursorColor: Colors.blueGrey,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black
                      ),
                      decoration: InputDecoration(
                        hintText: "Mesaj Yazın",
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 4),
                    child: FloatingActionButton(
                      onPressed: () async {
                        await chatViewmodel.mesajGonder(
                          textEditingController.text
                        );
                        textEditingController.text = '';
                        _scrollController.animateTo(
                          0,
                          curve: Curves.easeOut,
                          duration: const Duration(milliseconds: 10),
                        );
                      },
                      backgroundColor: Colors.blue,
                      elevation: 0,
                      child: Icon(Icons.navigation, size: 35, color: Colors.white,),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded buildMessageList() {
    ChatViewmodel chatViewmodel = Provider.of<ChatViewmodel>(context);
    return Expanded(
            child: ListView.builder(
                controller: _scrollController,
                reverse: true,
                itemBuilder: (context, index) {
                  if(index == chatViewmodel.tumMesajlar.length){
                    if(chatViewmodel.hasMore!){
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }else{
                      return Container();
                    }
                  }else{
                    return sohbetMesaji(chatViewmodel.tumMesajlar[index]);
                  }
                }, itemCount: chatViewmodel.hasMore == true ?
            chatViewmodel.tumMesajlar.length + 1 :
            chatViewmodel.tumMesajlar.length),
          );
  }

  Widget sohbetMesaji(Mesaj mesaj) {
    ChatViewmodel chatViewmodel = Provider.of<ChatViewmodel>(context);
    bool bendenMi = mesaj.bendenMi;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: bendenMi == true ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          bendenMi == false ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: CircleAvatar(
              backgroundImage: NetworkImage(chatViewmodel.sohbetEdilenUser.profilURL),
            ),
          ) : Container(),
          Flexible(
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: bendenMi == true ? Colors.blue : Colors.green,
              ),
              child: Text(mesaj.messageText, style: TextStyle(fontSize: 16, color: Colors.white),),
            ),
          ),
          Container(
              padding: EdgeInsets.all(8),
              child: Text('${mesaj.dateTime!.hour}:${mesaj.dateTime!.minute}'))
        ],
      ),
    );
  }
}
