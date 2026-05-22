#!/bin/bash
# Smart Ultrathink Hook - Conservative Mode
# Only fires on technical keywords or prompts >= 50 characters.
# Recommended for Claude Pro plan users to avoid hitting rate limits.

P=$(jq -r '.prompt // ""' 2>/dev/null) || exit 0

LEN=$(printf '%s' "$P" | wc -m | tr -d ' ')
if [ "$LEN" -lt 1 ]; then
    exit 0
fi

# Skip ONLY greetings. y/n must trigger ultrathink (the action after "y" is what matters).
case "$P" in
    thanks|hi|hello|bye)
        exit 0
        ;;
    ありがとう|ありがと|おはよう|こんにちは|こんばんは|お疲れ|おつかれ|お疲れ様|おやすみ)
        exit 0
        ;;
esac

# Technical keywords (English + Japanese)
KEYWORDS='implement|design|compare|architect|deploy|build|review|analyze|debug|refactor|optimize|automate|integrate|secure|test|migrate|scale|performance|実装|設計|比較|最適|ブロック|自動化|デプロイ|構築|提案|検討|レビュー|アーキ|プラン|戦略|分析|診断|修正|改善|どう|どっち|どれ|なぜ|なに|案|方法|候補|選|決め|作'

# Fire only if prompt >= 50 chars OR contains technical keyword
if [ "$LEN" -lt 50 ] && ! printf '%s' "$P" | grep -qiE "$KEYWORDS"; then
    exit 0
fi

cat <<'JSON'
{"hookSpecificOutput":{"hookEventName":"UserPromptSubmit","additionalContext":"## Auto-injected Thinking Principles (Conservative Mode)\n\n### Reasoning Depth\n- Use **ultrathink** to consider deeply\n- Do NOT default to shallow conventional answers\n- Try multiple reasoning paths\n\n### Response Format (for implementation/design/comparison questions)\n- 3+ options in a comparison table\n- 3 reasons supporting the recommended option\n- 3 critical weaknesses (devil's advocate)\n\n### Solution Priority\n1. Custom scripts + standard OS features\n2. OSS / free tools\n3. Paid tools (last resort)\n\nultrathink"}}
JSON

exit 0
