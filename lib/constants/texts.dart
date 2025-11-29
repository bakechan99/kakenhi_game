class AppTexts {
  // App title
  static const String gameTitle = "カケンヒゲーム";
  static const String newGameButton = "ゲームを始める";

  // Setup screen
  static const String setupTitle = "ゲーム設定";
  static const String playerCountLabel = "プレイヤー人数";
  static const String presentationTimeLabel = "プレゼン時間（秒）";

  // Game loop screen
  static const String startGameButton = "ゲーム開始";
  static const String dragInstruction = "研究タイトルを決めてください";
  static const String handEmpty = "手札をここにドラッグしてください";
  static const String confirmResearchTitle = "この研究タイトルでよろしいですか？";
  static const String nextPlayerButton = "次のプレイヤーへ";

  // Game loop screen - Additional
  static const String turnMessageSuffix = "の番です";
  static const String passSmartphoneMessage = "スマホを渡してください";
  static const String readyButton = "準備OK";
  static const String areYouReadySuffix = "さん、準備はいいですか？";
  static const String turnTitleSuffix = " のターン";
  static const String researchAreaHeader = "【研究課題名】 ドラッグで並び替え・タップで文字選択";
  static const String decideButton = "これで決定！";

  // Result screen
  static const String backToTitle = "タイトルへ戻る";

  // pop-up messages 
  static const String confirmTitle = "確認";
  static const String saveSuccess = "この研究タイトルでよろしいですか？";
  static const String defaultPlayerName = "プレイヤー";

  // --- Methods for dynamic texts ---
  
  // Setup Screen
  static String defaultPlayerNameWithIndex(int index) => "$defaultPlayerName$index";
  static String playerCountUnit(int count) => "$count人";
  static String secondsUnit(int sec) => "${sec}秒";

  // Game Loop Screen
  static String nextPlayerMessage(String name) => "次は $name さんの番です";
  static String areYouReady(String name) => "$nameさん、準備はいいですか？";
  static String turnTitle(String name) => "$name のターン";

  // Result Screen
  static String nextPlayerStandby(String name) => "次は $name さん";
  static String presentationTitle(String name) => "$name の発表";
  static String presentationTimeMsg(int seconds) => "時間は$seconds秒です。";
  static String timeLeft(int seconds) => "残り $seconds 秒";
  static String votingTitle(String name) => "$name の投票";
  static String confirmVote(String name) => "$name さんに投票しますか？";
  static String winnerName(String name) => "👑 $name";
  static String voteCount(int votes) => "獲得票数: $votes 票";
}