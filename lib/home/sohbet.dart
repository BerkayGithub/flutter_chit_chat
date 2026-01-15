import 'package:flutter/material.dart';
import 'package:flutter_chit_chat/models/mesaj.dart';
import 'package:flutter_chit_chat/models/user_model.dart';
import 'package:flutter_chit_chat/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';

class Sohbet extends StatefulWidget {
  const Sohbet({
    super.key,
    required this.suankiUser,
    required this.sohbetEdilenUser,
  });

  final UserModel suankiUser;
  final UserModel sohbetEdilenUser;

  @override
  State<Sohbet> createState() => _SohbetState();
}

class _SohbetState extends State<Sohbet> {
  TextEditingController textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    UserModel _suankiUser = widget.suankiUser;
    UserModel _sohbetEdilenUser = widget.sohbetEdilenUser;
    UserViewModel userViewModel = Provider.of<UserViewModel>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Sohbet')),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder<List<Mesaj>>(
                stream: userViewModel.mesajlariCek(_suankiUser.userID, _sohbetEdilenUser.userID),
                builder: (context, asyncSnapshot) {
                  if (!asyncSnapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  var tumMesajlar = asyncSnapshot.data!;
                  return ListView.builder(
                      controller: _scrollController,
                      reverse: true,
                      itemBuilder: (context, index) {
                    return sohbetMesaji(tumMesajlar[index]);
                  }, itemCount: tumMesajlar.length);
                }
              ),
            ),
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
                        await userViewModel.mesajGonder(
                          textEditingController.text,
                          widget.suankiUser,
                          widget.sohbetEdilenUser,
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

  Widget sohbetMesaji(Mesaj mesaj) {
    bool bendenMi = mesaj.bendenMi;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: bendenMi == true ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          bendenMi == false ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: CircleAvatar(
              backgroundImage: NetworkImage(widget.sohbetEdilenUser.profilURL),
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
