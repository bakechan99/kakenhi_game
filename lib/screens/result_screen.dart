import 'dart:async';
import 'package:audioplayers/audioplayers.dart'; // 音声用
import 'package:flutter/material.dart';
import '../models/player.dart';
import '../models/placed_card.dart';

// 画面の状態を管理する列挙型
enum ScreenPhase {
  presentationStandby, // プレゼン前のスマホ受渡
  presentation,        // プレゼン中（タイマー稼働）
  votingStandby,       // 投票前のスマホ受渡
  voting,              // 投票入力中
  result               // 結果発表
}

class ResultScreen extends StatefulWidget {
  final List<Player> players;
  const ResultScreen({super.key, required this.players});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  // 現在のフェーズ
  ScreenPhase currentPhase = ScreenPhase.presentationStandby;

  // インデックス管理
  int currentPresenterIndex = 0; // 今発表している人
  int currentVoterIndex = 0;     // 今投票している人
  
  // 投票データの管理（プレイヤーIDをキーにするのが理想ですが、簡易的にインデックスで管理）
  // List<投票された数>
  List<int> voteCounts = [];

  // タイマー関連
  Timer? _timer;
  int _timeLeft = 30; // プレゼン時間（秒）
  final AudioPlayer _audioPlayer = AudioPlayer(); // 音声プレイヤー

  @override
  void initState() {
    super.initState();
    // 投票箱を0で初期化
    voteCounts = List.filled(widget.players.length, 0);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  // --- タイマー処理 ---
  void _startTimer() {
    setState(() {
      _timeLeft = 30; // 時間のリセット
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          // 時間切れ！
          _timer?.cancel();
          _playSound(); // 音を鳴らす
        }
      });
    });
  }

  Future<void> _playSound() async {
    try {
      // assets/audio/timeup.mp3 を用意すれば鳴ります
      await _audioPlayer.play(AssetSource('audio/timeup.mp3'));
    } catch (e) {
      debugPrint("音声ファイルが見つかりません（後で追加すればOK）: $e");
    }
  }

  // --- 進行管理ロジック ---

  // 1. プレゼン準備完了ボタンを押した時
  void _startPresentation() {
    setState(() {
      currentPhase = ScreenPhase.presentation;
    });
    _startTimer();
  }

  // 2. プレゼン終了ボタンを押した時
  void _finishPresentation() {
    _timer?.cancel();
    _audioPlayer.stop();

    if (currentPresenterIndex < widget.players.length - 1) {
      // 次のプレゼンターへ
      setState(() {
        currentPresenterIndex++;
        currentPhase = ScreenPhase.presentationStandby;
      });
    } else {
      // 全員終わったら投票フェーズへ
      setState(() {
        currentPhase = ScreenPhase.votingStandby;
      });
    }
  }

  // 3. 投票準備完了ボタンを押した時
  void _startVoting() {
    setState(() {
      currentPhase = ScreenPhase.voting;
    });
  }

  // 4. 誰かに投票した時
  void _submitVote(int targetIndex) {
    voteCounts[targetIndex]++; // 票を入れる

    if (currentVoterIndex < widget.players.length - 1) {
      // 次の投票者へ
      setState(() {
        currentVoterIndex++;
        currentPhase = ScreenPhase.votingStandby;
      });
    } else {
      // 全員投票完了 -> 結果発表へ
      setState(() {
        currentPhase = ScreenPhase.result;
      });
    }
  }

  // --- UI構築 ---

  @override
  Widget build(BuildContext context) {
    switch (currentPhase) {
      case ScreenPhase.presentationStandby:
        return _buildStandbyScreen(
          player: widget.players[currentPresenterIndex],
          message: "次は発表の番です",
          onReady: _startPresentation,
        );
      case ScreenPhase.presentation:
        return _buildPresentationScreen();
      case ScreenPhase.votingStandby:
        return _buildStandbyScreen(
          player: widget.players[currentVoterIndex],
          message: "次は投票の番です",
          onReady: _startVoting,
        );
      case ScreenPhase.voting:
        return _buildVotingScreen();
      case ScreenPhase.result:
        return _buildResultScreen();
    }
  }

  // 共通：スマホ受渡画面（背景画像つき）
  Widget _buildStandbyScreen({required Player player, required String message, required VoidCallback onReady}) {
    return Scaffold(
      body: Stack(
        children: [
          Container(color: Colors.blueGrey), // 背景色（画像があればここにDecorationImage）
          Container(color: Colors.black.withOpacity(0.5)),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("次は ${player.name} さん", style: const TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(message, style: const TextStyle(fontSize: 18, color: Colors.white70)),
                const SizedBox(height: 40),
                const Icon(Icons.phone_android, size: 80, color: Colors.white),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: onReady,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("準備OK", style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // プレゼン画面
  Widget _buildPresentationScreen() {
    final player = widget.players[currentPresenterIndex];
    final isTimeUp = _timeLeft == 0;

    return Scaffold(
      appBar: AppBar(title: Text("${player.name} の発表")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // タイマー表示
            Text(
              "残り $_timeLeft 秒",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: isTimeUp ? Colors.red : Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            
            // 完成したタイトルの表示エリア
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.blueAccent, width: 4),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))],
              ),
              child: Column(
                children: [
                  const Text("【今回の研究課題】", style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 10),
                  // 選んだ言葉をつなげて表示
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: player.selectedCards.map((p) {
                      return Text(
                        p.selectedText, // PlacedCardの便利機能で選んだ文字だけ取得
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            
            const Spacer(),
            
            // 発表終了ボタン
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _finishPresentation,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.pink, foregroundColor: Colors.white),
                child: const Text("発表終了（次の人へ）", style: TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // 投票画面
  Widget _buildVotingScreen() {
    final voter = widget.players[currentVoterIndex];

    return Scaffold(
      appBar: AppBar(title: Text("${voter.name} の投票")),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "最も予算を与えたい（面白かった）\n研究を選んでください",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.players.length,
              itemBuilder: (context, index) {
                final candidate = widget.players[index];
                
                // 自分自身には投票できないようにする
                if (index == currentVoterIndex) return const SizedBox.shrink();

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(candidate.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      // タイトルを連結して表示
                      candidate.selectedCards.map((c) => c.selectedText).join(""),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: ElevatedButton(
                      onPressed: () => _submitVote(index),
                      child: const Text("投票"),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 結果発表画面
  Widget _buildResultScreen() {
    // 最大得票数を探す
    int maxVotes = 0;
    for (var count in voteCounts) {
      if (count > maxVotes) maxVotes = count;
    }

    // 同率1位も含めて勝者リストを作る
    List<Player> winners = [];
    for (int i = 0; i < widget.players.length; i++) {
      if (voteCounts[i] == maxVotes) {
        winners.add(widget.players[i]);
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text("🎉 結果発表 🎉")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("採択された研究課題は...", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 30),
            if (winners.length == 1)
               Text("👑 ${winners.first.name} 👑", style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.orange))
            else
               // 同率一位の場合
               Column(
                 children: winners.map((w) => Text("👑 ${w.name}", style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.orange))).toList(),
               ),
            
            const SizedBox(height: 20),
            Text("獲得票数: $maxVotes 票", style: const TextStyle(fontSize: 24)),
            
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                // タイトル画面に戻る（全てのルートを消してタイトルへ）
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text("タイトルへ戻る"),
            )
          ],
        ),
      ),
    );
  }
}