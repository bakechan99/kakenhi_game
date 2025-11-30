class AppTexts {
  // --- Static Constants (固定の文字列) ---
  
  // Common
  static const String appTitle = "科研費獲得ゲーム";
  static const String cancel = "キャンセル";
  static const String ok = "OK";
  static const String san = "さん";

  // Title Screen
  static const String gameTitle = "科研費獲得ゲーム";
  static const String startGameButton = "ゲーム開始";
  static const String newGameButton = "新規ゲーム";

  // Setup Screen
  static const String setupTitle = "ゲーム設定";
  static const String setupPlayerNameSection = "③ プレイヤー名（ドラッグで入替）";
  static const String defaultPlayerName = "プレイヤー";

  // Game Loop Screen
  static const String dragInstruction = "研究タイトルを決めてください";
  static const String handEmpty = "手札をここにドラッグしてください";
  static const String confirmResearchTitle = "この研究タイトルでよろしいですか？";
  static const String nextPlayerButton = "次のプレイヤーへ";
  static const String turnMessageSuffix = "の番です";
  static const String passSmartphoneMessage = "スマホを渡してください";
  static const String readyButton = "準備OK";
  static const String areYouReadySuffix = "さん、準備はいいですか？";
  static const String turnTitleSuffix = " のターン";
  static const String researchAreaHeader = "【研究課題名】 ドラッグで並び替え・タップで文字選択";
  static const String decideButton = "これで決定！";
  
  // Result Screen
  static const String resultTitle = "🎉 結果発表 🎉";
  static const String backToTitle = "タイトルへ戻る";
  static const String nextPresenter = "次は発表の番です";
  static const String nextVoter = "次は投票の番です";
  static const String presentationStartTitle = "プレゼンを開始します";
  static const String voteConfirmTitle = "投票確認";
  static const String voteSelectionTitle = "最も予算を与えたい研究を選んでください";
  static const String resultHeader = "採択された研究課題は...";

  // Pop-up messages 
  static const String confirmTitle = "確認";

  // --- Methods (変数を埋め込む動的な文字列) ---
  
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
  
  // 研究タイトルを整形して返す
  static String researchTitle(String title) => "【研究課題】$title";
}