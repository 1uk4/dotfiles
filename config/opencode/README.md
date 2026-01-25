# OpenCode Configuration

Configuration files for [OpenCode](https://opencode.ai) and the [Oh-My-OpenCode](https://github.com/code-yeongyu/oh-my-opencode) plugin.

## Files

| File | Purpose |
|------|---------|
| `opencode.json` | Core OpenCode settings, plugin configuration |
| `oh-my-opencode.json` | Agent models, categories, background task limits |

## Installation

### 1. Symlink Configs

Configs are automatically symlinked when you run:

```bash
./install.sh link
```

This creates: `./config/opencode/` → `~/.config/opencode/`

### 2. Add API Keys

API keys are stored in `~/.localenv` (sourced automatically by zshrc):

```bash
# If you haven't already, create from template
cp localenv.template ~/.localenv

# Edit and add your API keys
vim ~/.localenv
```

Required keys:
```bash
export ANTHROPIC_API_KEY="sk-ant-..."
export OPENAI_API_KEY="sk-proj-..."
export GOOGLE_GENERATIVE_AI_API_KEY="AIza..."
```

**Get API keys:**
- Anthropic: https://console.anthropic.com/settings/keys
- OpenAI: https://platform.openai.com/api-keys
- Google: https://aistudio.google.com/apikey

### 3. Install OpenCode

```bash
# Install OpenCode globally
npm install -g opencode

# Install Oh-My-OpenCode plugin
bunx oh-my-opencode install

# Reload shell to pick up API keys
source ~/.zshrc

# Verify setup
bunx oh-my-opencode doctor
```

Expected output:
```
✓ Configuration Validity → Valid JSON config
✓ Model Resolution → 8 agents, 7 categories configured
✓ Anthropic (Claude) Auth → Authenticated
✓ OpenAI (ChatGPT) Auth → Authenticated  
✓ Google (Gemini) Auth → Authenticated
```

## Configuration Overview

### Agents (Specialized Task Handlers)

| Agent | Model | Purpose | Cost |
|-------|-------|---------|------|
| sisyphus | Claude Sonnet 4.5 | Main orchestrator | 💰💰 |
| librarian | Claude Sonnet 4.5 | Documentation/research | 💰💰 |
| explore | Gemini 2.0 Flash | Codebase exploration | 💰 Free |
| oracle | GPT-5.2 | High-IQ reasoning/architecture | 💰💰💰💰 |
| frontend-ui-ux-engineer | Gemini 2.5 Pro | UI/frontend work | 💰💰💰 |
| document-writer | Gemini 2.0 Flash | Documentation | 💰 Free |
| multimodal-looker | Gemini 2.0 Flash | Image/PDF analysis | 💰 Free |
| prometheus | Claude Sonnet 4.5 | Work planning | 💰💰 |

### Categories (Task-Based Model Selection)

When using `delegate_task(category="X")`:

| Category | Model | Use Case |
|----------|-------|----------|
| visual-engineering | Gemini 2.5 Pro | UI/frontend implementation |
| quick | Gemini 2.0 Flash | Trivial fixes, simple changes |
| ultrabrain | Claude Opus 4.5 | Complex architecture, hard problems |
| unspecified-low | Claude Sonnet 4.5 | General low-effort tasks |
| unspecified-high | Claude Opus 4.5 | General high-effort tasks |
| artistry | Gemini 2.5 Pro | Creative/design work |
| writing | Gemini 2.0 Flash | Documentation, prose |

### Background Task Limits (Cost Protection)

Prevents cost spikes from running too many expensive models in parallel:

| Limit | Value | Purpose |
|-------|-------|---------|
| defaultConcurrency | 5 | Max tasks at once |
| anthropic | 3 | Claude rate limit |
| google | 10 | Gemini is cheaper/free |
| openai | 3 | GPT-5.2 rate limit |
| gpt-5.2 | 2 | Extra protection (expensive) |
| opus-4-5 | 2 | Extra protection (expensive) |

## Maintenance

### Update Models

```bash
# Edit config
vim ~/dotfiles/config/opencode/oh-my-opencode.json

# Re-symlink (if needed)
./install.sh link

# Verify changes
bunx oh-my-opencode doctor --verbose
```

### Check Available Models

```bash
# List all available models
opencode models

# Search for specific provider
opencode models | grep google
opencode models | grep anthropic
opencode models | grep openai
```

### Rotate API Keys

```bash
# 1. Generate new keys from provider websites
# 2. Update ~/.localenv
vim ~/.localenv

# 3. Reload shell
source ~/.zshrc

# 4. Verify
bunx oh-my-opencode doctor
```

## Troubleshooting

### "API key is missing"

```bash
# Check if environment variables are set
env | grep -E "ANTHROPIC|OPENAI|GOOGLE"

# If empty, verify ~/.localenv exists and is sourced
cat ~/.localenv | grep -E "ANTHROPIC|OPENAI|GOOGLE"

# Reload shell config
source ~/.zshrc
```

### "Configuration is invalid"

```bash
# Validate JSON syntax
cat ~/.config/opencode/oh-my-opencode.json | jq .

# If error, fix JSON syntax (trailing commas, quotes, etc.)
vim ~/dotfiles/config/opencode/oh-my-opencode.json
```

### "Model not found"

```bash
# Check available models
opencode models | grep "model-name"

# Update config with correct model name
vim ~/dotfiles/config/opencode/oh-my-opencode.json
```

## Cost Optimization Tips

| Strategy | Savings |
|----------|---------|
| Use Gemini Flash for exploration/quick tasks | ~90% vs Claude |
| Use Sonnet instead of Opus for planning | ~60% cost reduction |
| Set background task limits | Prevents parallel cost spikes |
| Use category-based routing | Right model for right task |

## Security Notes

✅ **DO**:
- Store keys in `~/.localenv` (sourced by zshrc)
- Use environment variables (never hardcode)
- Add `~/.localenv` to `.gitignore` (already done)
- Rotate keys periodically

❌ **DON'T**:
- Commit keys to git
- Hardcode keys in JSON configs
- Share keys in public repos or screenshots
- Use keys in CI/CD without secret management
