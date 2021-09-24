import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/models/user.dart';
import 'package:healthy_lifestyle_app/providers/all_user.dart';
import 'package:healthy_lifestyle_app/providers/current_user.dart';
import 'package:healthy_lifestyle_app/views/widgets/message/message_list.dart';
import 'package:provider/provider.dart';

class SearchSharing extends SearchDelegate{
  
  @override
  List<Widget> buildActions(BuildContext context) {
      return[
        IconButton(icon:Icon(Icons.clear), onPressed:(){
          query="";
        })
      ];
    }
  
    @override
    Widget buildLeading(BuildContext context) {
      return IconButton(icon:Icon(Icons.arrow_back), onPressed: (){
        Navigator.pop(context);
      });
    }
  
    @override
    Widget buildResults(BuildContext context) {
      return Container();
    }
  
    @override
    Widget buildSuggestions(BuildContext context) {
      AllUser allUser = Provider.of<AllUser>(context, listen: false);
      User userinfo = Provider.of<CurrentUser>(context, listen: false).currentUserInfo;
      List<Map<String, dynamic>> data = allUser.users;
      data.removeWhere((element) => element["user_id"] == userinfo.userId);
      List<Map<String, dynamic>> suggestionList = query.isEmpty?data : data.where((element) => element['username'].toString().toLowerCase().startsWith(query)).toList();
      return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (ctx, index){
          return MessageList(suggestionList[index]);
        }
      );
  }

}