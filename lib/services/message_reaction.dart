import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageReaction {
 final _firestore = FirebaseFirestore.instance;
 void showEmojiOptions(BuildContext context,String messageId , String userId , List reactions) {
  showModalBottomSheet(
    backgroundColor: Colors.white,
    context: context,
    builder: (context) {
      List <String> reactionsImojis = ['😴','😢' ,'🔥','❤️','😂'];
      List <String> moreReactionsImojis = [  "😀","😊", "😍", "🤔", "🙄", "😎", "🤗",  "😡",
                                             "🙌", "👋", "👍", "👎", "👏", "✌️", "💪", "🙏", "🤲", "🤝",
                                             "💔", "🌟", "🎉", "💯", "🚀", "📅", "⏰", "💡",
                                             "🌍", "🌙", "☀️", "❄️", "⛄", "🍎", "🍕", "🍔", "🍟",
                                             "⚽", "🏀", "🎸", "🎵", "🎬", "🛠️", "🏠", "🏥", "🚗", "✈️"];
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ...reactionsImojis.map((imoji){
          return IconButton(  onPressed: (){
                                addReaction(messageId , imoji , userId , reactions ); 
                                Navigator.pop(context);},
                              icon:Text(imoji , 
                                        style:const TextStyle(fontSize: 20 )));
          }),
          IconButton(onPressed: (){
          
           showModalBottomSheet(
                  backgroundColor: Colors.white,
                  context: context,
                  builder: (context) {
                    return Container(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.3, 
                        maxWidth: MediaQuery.of(context).size.width * 0.9, 
                      ),
                      child: GridView.count(
                        crossAxisCount: 5,
                        mainAxisSpacing: 5,
                        shrinkWrap: true,
                        children: moreReactionsImojis.map((imoji) {
                          return IconButton(
                            onPressed: () {
                              addReaction(messageId, imoji, userId, reactions);
                              Navigator.pop(context);
                              Navigator.pop(context); 
                            },
                            icon: Text(imoji, style: const TextStyle(fontSize: 22)),
                          );
                        }).toList(),
                      ),
                    );
                  },
                );
              },
          
          icon:const Icon(Icons.add_outlined,color: Colors.black, size: 22,))
        ],
      );
    },
  );
}
void addReaction(String messageId, String pressedReaction, String userId, List reactions) {
  bool userFound = false;

  for (var reaction in reactions) {
    if (reaction['userId'] == userId) {
      reaction['reaction'] = pressedReaction;  
      userFound = true;
      break;  
    }
  }

  if (!userFound) {
    reactions.add({
      'userId': userId,
      'reaction': pressedReaction,
    });
  }

  
  _firestore.collection('messages').doc(messageId).update({
    'reactions': reactions,
  });
  
  
}

}