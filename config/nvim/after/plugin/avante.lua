---@diagnostic disable-next-line: undefined-global
local vim = vim

-- Check for API keys (must be non-empty)
local anthropic_key = vim.env and vim.env.ANTHROPIC_API_KEY and vim.env.ANTHROPIC_API_KEY ~= ""
local openai_key = vim.env and vim.env.OPENAI_API_KEY and vim.env.OPENAI_API_KEY ~= ""


-- Determine which provider to use based on available keys
local provider = "openai"
local provider_config = {}

if anthropic_key then
    provider = "claude"
    provider_config = {
        claude = {
            endpoint = "https://api.anthropic.com",
            model = "claude-3-7-sonnet-latest",
        }
    }
elseif openai_key then
    provider = "openai"
    provider_config = {
        openai = {
            endpoint = "https://api.openai.com/v1",
            model = "gpt-4o-mini-2024-07-18",
        }
    }
else
    if vim.notify then
        vim.notify("Avante requires either ANTHROPIC_API_KEY or OPENAI_API_KEY environment variable to be set.", vim.log.levels.ERROR)
    end
    return
end

local avante_config = vim.tbl_deep_extend("force", {
    provider = provider,
    behaviour = {
        auto_suggestions = false,
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = false,
    },
    mappings = {
        diff = {
            ours = "co",
            theirs = "ct",
            all_theirs = "ca",
            both = "cb",
            cursor = "cc",
            next = "]x",
            prev = "[x",
        },
        suggestion = {
            accept = "<M-l>",
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
        },
        jump = {
            next = "]]",
            prev = "[[",
        },
        submit = {
            normal = "<CR>",
            insert = "<C-s>",
        },
        sidebar = {
            switch_windows = "<Tab>",
            reverse_switch_windows = "<S-Tab>",
        },
    },
    hints = { enabled = true },
    windows = {
        position = "right", -- "right" | "left" | "top" | "bottom"
        wrap = true,
        width = 30, -- default % based on available width
        sidebar_header = {
            align = "center", -- left, center, right for title
            rounded = true,
        },
    },
    highlights = {
        diff = {
            current = "DiffText",
            incoming = "DiffAdd",
        },
    },
    diff = {
        autojump = true,
        list_opener = "copen",
    },
}, provider_config)

local status, result = pcall(function()
    local avante = require("avante")
    avante.setup(avante_config)
    return avante
end)

if status then
    if vim.notify then
        local provider_name = provider == "claude" and "Anthropic Claude" or "OpenAI GPT"
        vim.notify("Avante setup successful with " .. provider_name, vim.log.levels.INFO)
    end
    -- Create user commands for switching providers
    vim.api.nvim_create_user_command("AvanteUseClaude", function()
        if not anthropic_key then
            vim.notify("ANTHROPIC_API_KEY not found", vim.log.levels.ERROR)
            return
        end
        require("avante.config").override({
            provider = "claude",
            claude = {
                endpoint = "https://api.anthropic.com",
                model = "claude-3-7-sonnet-latest",
                timeout = 60000,  -- Increase timeout to avoid rate limiting
                temperature = 0.7, -- Adjust temperature for more varied responses
                max_tokens = 2048, -- Adjust max tokens to fit within rate limits
            }
        })
        vim.notify("Switched to Anthropic Claude", vim.log.levels.INFO)
    end, {})
    vim.api.nvim_create_user_command("AvanteUseOpenAI", function()
        if not openai_key then
            vim.notify("OPENAI_API_KEY not found", vim.log.levels.ERROR)
            return
        end
        require("avante.config").override({
            provider = "openai",
            openai = {
                endpoint = "https://api.openai.com/v1",
                            model = "gpt-40-mini",
                timeout = 30000,
                temperature = 0,
                max_tokens = 4096,
            }
        })
        vim.notify("Switched to OpenAI GPT", vim.log.levels.INFO)
    end, {})
    -- Add keybindings for quick switching
    vim.keymap.set('n', '<leader>ac', ':AvanteUseClaude<CR>', { desc = 'Switch to Claude' })
    vim.keymap.set('n', '<leader>ao', ':AvanteUseOpenAI<CR>', { desc = 'Switch to OpenAI' })
else
    if vim.notify then
        vim.notify("Error setting up Avante: " .. tostring(result), vim.log.levels.ERROR)
    end
end
