import 'package:chatapp/widgets/user_Widget.dart';
import 'package:flutter/material.dart';

class ReactionWidget extends StatelessWidget {
  const ReactionWidget({
    Key? key,
    required this.reactions,
  }) : super(key: key);

  final List reactions;

  @override
  Widget build(BuildContext context) {
    if (reactions.isEmpty) {
      return const SizedBox.shrink();
    }

    Map<String, int> uniqueReactions = {};

  for (var reaction in reactions) {
    String emoji = reaction['reaction'];
    uniqueReactions[emoji] = (uniqueReactions[emoji] ?? 0) + 1;
  }

  
  var sortedReactions = uniqueReactions.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));

    return GestureDetector(
    onTap: (){
  showModalBottomSheet(
  context: context,
  backgroundColor: Colors.white, 
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(18),
      topRight: Radius.circular(18),
    ),
  ),
  builder: (context) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width * 0.95,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Reactions',
                     style: TextStyle(color: Colors.black , fontSize: 22 , fontWeight: FontWeight.w600), 
                     textAlign: TextAlign.start),
          const SizedBox(height: 20,),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: reactions.map((reaction) {
              return Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: UserWidget(
                      user: reaction['userId'],
                      userImageRaduis: 22,
                      text:'',
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(reaction['reaction'],style: const TextStyle(fontSize: 25),),
                  )
                ],
              );
            }).toList(),
          ),
          const SizedBox(height: 20,),
        ],
      ),
    );
  },
  isScrollControlled: true, 
);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...sortedReactions.take(2).map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Text(entry.key),
            );
          }),
          if (reactions.length > 1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Text(
                '${reactions.length}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ]) 
          ),
        ),
      
    );
  }
}