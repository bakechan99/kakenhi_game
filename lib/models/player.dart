import 'card_data.dart';
import 'placed_card.dart'; // 追加

class Player {
  String name;
  List<CardData> hand = [];
  // ここを CardData から PlacedCard に変更
  List<PlacedCard> selectedCards = []; 
  
  Player({required this.name});
  
  // 研究タイトルを生成するゲッター
  String get researchTitle {
    if (selectedCards.isEmpty) return "（未設定）";
    return selectedCards.map((pc) => pc.selectedText).join("");
  }
}