---@diagnostic disable-next-line: undefined-global
local vim = vim

local anthropic_key = vim.env and vim.env.ANTHROPIC_API_KEY

if not anthropic_key then
    if vim.notify then
        vim.notify("Avante requires ANTHROPIC_API_KEY environment variable to be set.", vim.log.levels.ERROR)
    end
    return
end

local avante_config = {
    provider = "claude",
    claude = {
        endpoint = "https://api.anthropic.com",
        model = "claude-3-opus-20240229",
        timeout = 30000,
        temperature = 0,
        max_tokens = 4096,
    },
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
}

local status, result = pcall(function()
    local avante = require("avante")
    avante.setup(avante_config)
    return avante
end)

if status then
    if vim.notify then
        vim.notify("Avante setup successful with Anthropic Claude", vim.log.levels.INFO)
    end
else
    if vim.notify then
        vim.notify("Error setting up Avante: " .. tostring(result), vim.log.levels.ERROR)
    end
end
