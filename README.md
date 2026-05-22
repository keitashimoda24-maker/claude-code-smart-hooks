# Claude Code Smart Hooks

> **Conditional ultrathink injection** for Claude Code. Automatically enforce deep reasoning, 3-way comparison, and devil's advocate critique — without rewriting your prompt every time.

[English](#english) | [日本語](#日本語)

---

## English

### What is this?

A collection of `UserPromptSubmit` hooks for [Claude Code](https://docs.claude.com/en/docs/claude-code) that **redesign your prompt environment** so that Claude's reasoning quality stays consistently high across sessions — without you having to manually paste templates every time.

The flagship hook (`smart_ultrathink.sh`) detects whether your prompt warrants deep thinking, and if so, automatically injects:

- `ultrathink` keyword (triggers Claude's extended reasoning mode)
- A request for 3+ option comparison table
- A request for 3 reasons supporting the recommended option
- A request for 3 critical weaknesses (devil's advocate)
- A solution priority hierarchy (custom scripts > OSS > paid tools)
- Anti-hallucination guardrails

### Why does this matter?

Claude's reasoning depth varies between sessions because of:
- Sampling temperature (stochastic token selection)
- Variable inference paths for the same problem
- Selective memory recall (not all memory files are read every time)

This results in **the same question producing different answers** in different sessions. Sometimes you get the "obvious tool recommendation" answer. Sometimes you get the "deep custom solution" answer.

This hook **structurally forces the deeper path** for every prompt that warrants it.

### Setup

1. Copy `hooks/smart_ultrathink.sh` to `~/.claude/hooks/smart_ultrathink.sh`
2. Make it executable: `chmod +x ~/.claude/hooks/smart_ultrathink.sh`
3. Register in `~/.claude/settings.json`:

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/hooks/smart_ultrathink.sh",
            "timeout": 5
          }
        ]
      }
    ]
  }
}
```

4. Restart Claude Code. Test with a prompt like "design a thing" — the additional context should be injected.

### How activation works

The hook **does NOT** fire on:
- Empty / 1-2 character responses
- `y`, `n`, `ok`, `はい`, `いいえ`, `了解`, etc.
- Common greetings (`hi`, `hello`, `おはよう`, `お疲れ様`, etc.)

The hook **fires on** anything else, including all substantial questions. This is the "maximum quality mode" preset designed for Claude Max plan users.

If you want more conservative activation (e.g., only fire on technical keywords), see `examples/conservative_mode.sh`.

### Testing locally

```bash
echo '{"prompt":"y"}' | bash hooks/smart_ultrathink.sh
# Expected: (empty output)

echo '{"prompt":"design an authentication system"}' | bash hooks/smart_ultrathink.sh
# Expected: JSON with hookSpecificOutput
```

### Cost considerations

This hook increases thinking token usage roughly 2-5x compared to no-hook usage. Recommended for **Claude Max ($100/mo)** or higher. On Pro ($20/mo), consider switching to conservative mode to avoid hitting rate limits.

### License

MIT

---

## 日本語

### これは何？

[Claude Code](https://docs.claude.com/ja/docs/claude-code) の `UserPromptSubmit` フック集です。プロンプト環境を再設計することで、毎回テンプレートを貼り付けなくても、Claude の思考品質をセッション間で安定して高く保ちます。

メインフック `smart_ultrathink.sh` は、プロンプトが深く考えるべき内容かを判定し、該当する場合に以下を自動注入します：

- `ultrathink` キーワード（Claude の拡張思考モード起動）
- 3案以上の比較表要求
- 推奨案の根拠3つ要求
- 致命的弱点3つ要求（悪魔の代弁者）
- 解決アプローチの優先順位（自作 > OSS > 有料ツール）
- ハルシネーション防止ガード

### なぜ重要？

Claude の思考の深さがセッション間でばらつくのは：
- サンプリングの温度（確率的トークン選択）
- 同じ問題でも推論経路が変わる
- メモリの選択的参照（毎回全部読まれるわけではない）

結果として、**同じ質問でもセッションが違えば違う答えが返る**ことがあります。「定番ツール紹介」レベルの答えが返ることもあれば、「深い自作ソリューション」が返ることもある。

このフックは、**深く考えるべきプロンプトに対して、構造的に深い経路を強制**します。

### セットアップ

1. `hooks/smart_ultrathink.sh` を `~/.claude/hooks/smart_ultrathink.sh` にコピー
2. 実行権限付与: `chmod +x ~/.claude/hooks/smart_ultrathink.sh`
3. `~/.claude/settings.json` に登録：

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/hooks/smart_ultrathink.sh",
            "timeout": 5
          }
        ]
      }
    ]
  }
}
```

4. Claude Code を再起動。「設計して」「実装して」等のプロンプトで動作確認。

### 発動条件

このフックが**発動しない**のは：
- 空 or 1-2文字の応答
- `y` / `n` / `OK` / `はい` / `いいえ` / `了解` 等
- 一般的な挨拶（`おはよう` / `お疲れ様` 等）

それ以外のすべてのプロンプトで発動します。これは Claude Max プラン向けの「最大品質モード」プリセットです。

もう少し保守的な発動（技術的キーワードのみ）にしたい場合は `examples/conservative_mode.sh` を参照。

### ローカルテスト

```bash
echo '{"prompt":"y"}' | bash hooks/smart_ultrathink.sh
# 期待: 空出力

echo '{"prompt":"認証システムを設計して"}' | bash hooks/smart_ultrathink.sh
# 期待: hookSpecificOutput を含む JSON
```

### コストの注意

このフックは思考トークン使用量を **2-5倍**に増やします。**Claude Max ($100/月)** 以上の契約を推奨します。Pro ($20/月) では制限到達リスクがあるため、保守モードへの切替を検討してください。

### ライセンス

MIT

---

## Background

This project emerged from a real frustration: asking the same question in two different Claude Code sessions could yield wildly different quality of answers. One session would recommend a $5,000 third-party tool. Another session would design a 50-line custom script that solved the same problem for free.

The difference wasn't the question — it was Claude's reasoning depth. After investigating, the answer was clear: **stop relying on Claude's default reasoning. Force the structure of deep reasoning at the hook level.**

This is the result.

## Author

[@keitashimoda24-maker](https://github.com/keitashimoda24-maker)

## Related Projects

- [devils-advocate](https://github.com/keitashimoda24-maker/devils-advocate) - Devil's advocate agent for plan/design review
- [slash-commands-jp](https://github.com/keitashimoda24-maker/slash-commands-jp) - Japanese slash command reference plugin
