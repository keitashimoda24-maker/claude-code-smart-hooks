#!/bin/bash
# Smart Ultrathink Hook for Claude Code
# Automatically injects "ultrathink" + thinking principles into user prompts that need deep reasoning.
# Lightweight responses (y/n, greetings) are excluded to optimize token usage.
#
# Setup: Register this as a UserPromptSubmit hook in ~/.claude/settings.json
# License: MIT

P=$(jq -r '.prompt // ""' 2>/dev/null) || exit 0

# Skip empty or 1-2 character responses
LEN=$(printf '%s' "$P" | wc -m | tr -d ' ')
if [ "$LEN" -lt 3 ]; then
    exit 0
fi

# Skip y/n confirmations and common greetings (Japanese + English)
# Customize this list for your own usage patterns
case "$P" in
    y|Y|n|N|yes|no|ok|OK|thanks|hi|hello|bye)
        exit 0
        ;;
    はい|いいえ|了解|わかった|ありがとう|ありがと|うん|そうだね|おはよう|こんにちは|こんばんは|お疲れ|おつかれ|お疲れ様|おやすみ)
        exit 0
        ;;
esac

# Inject deep-thinking instructions for everything else
cat <<'JSON'
{"hookSpecificOutput":{"hookEventName":"UserPromptSubmit","additionalContext":"## Auto-injected Thinking Principles (Maximum Quality Mode)\n\nPlease follow these principles strictly:\n\n### Reasoning Depth\n- Use **ultrathink** to consider deeply before answering\n- Do NOT default to shallow conventional answers (e.g., 'just use the popular tool', 'go with the first idea')\n- Consciously try multiple reasoning paths\n- Do not jump to conclusions; consider multiple angles\n\n### Response Format (for implementation/design/comparison/proposal questions)\n- Present **3+ options in a comparison table** (pros/cons/cost/what-I-can-automate)\n- State **3 reasons** why the recommended option is best\n- Act as a **devil's advocate** and point out 3 critical weaknesses of the recommended option\n\n### Solution Priority\n1. **Custom scripts + standard OS features** (launchd / cron / AppleScript / pkill / defaults / hooks / shell / Python)\n2. **Existing OSS / free tools**\n3. **Third-party paid tools** (last resort, requires approval)\n\n### Default Assumptions\n- The user has a working Claude Code environment and can build custom automation scripts\n- Prefer 'build / extend' over 'install'\n- Do NOT assume 'the user can't do that'\n\n### Anti-Hallucination\n- Say 'I don't know' or 'this is a guess' when uncertain\n- Be explicit about uncertainty for numbers, dates, URLs, and recent information\n\nultrathink"}}
JSON

exit 0
